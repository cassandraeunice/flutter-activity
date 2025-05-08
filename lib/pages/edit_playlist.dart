import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

class EditPlaylist extends StatefulWidget {
  final String initialName;
  final String? initialImagePath;
  final String playlistId;

  EditPlaylist({
    required this.initialName,
    this.initialImagePath,
    required this.playlistId,
  });

  @override
  _EditPlaylistState createState() => _EditPlaylistState();
}

class _EditPlaylistState extends State<EditPlaylist> {
  late TextEditingController _playlistController;
  final List<String> _errors = [];
  XFile? _pickedFile;
  bool _isSaving = false;

  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _playlistController = TextEditingController(text: widget.initialName);
  }

  void _validateInput() {
    setState(() {
      _errors.clear();
      if (_playlistController.text.isEmpty) {
        _errors.add("Playlist name cannot be empty.");
      }
    });
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _pickedFile = pickedFile;
    });
  }

  Future<String?> _saveImageLocally(XFile pickedFile, String playlistId) async {
    if (kIsWeb) {
      print("Saving locally is not supported on web.");
      return null;
    }

    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final Directory playlistPicturesDir = Directory(path.join(appDocDir.parent.path, 'playlist_pictures'));

      if (!await playlistPicturesDir.exists()) {
        await playlistPicturesDir.create(recursive: true);
      }

      final String fileName = 'playlist_cover_${playlistId}_${DateTime.now().millisecondsSinceEpoch}.png';
      final String savedPath = path.join(playlistPicturesDir.path, fileName);

      final File imageFile = File(pickedFile.path);
      await imageFile.copy(savedPath);

      return savedPath;
    } catch (e) {
      print("Error saving image locally: $e");
      return null;
    }
  }

  Future<void> _onSavePressed() async {
    _validateInput();
    if (_errors.isEmpty) {
      setState(() {
        _isSaving = true;
      });

      try {
        String? localImagePath;

        if (!kIsWeb && _pickedFile != null) {
          localImagePath = await _saveImageLocally(_pickedFile!, widget.playlistId);
        }

        String finalImagePath = localImagePath ?? widget.initialImagePath ?? 'assets/default_song_cover.png';

        await _firestore.collection('playlists').doc(widget.playlistId).update({
          'name': _playlistController.text,
          'imagePath': finalImagePath,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        Navigator.pop(context, {
          'name': _playlistController.text,
          'imagePath': finalImagePath,
        });
      } catch (e) {
        setState(() {
          _errors.add("Error saving changes: ${e.toString()}");
        });
      } finally {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Edit your playlist name",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey[800]!, Colors.grey[600]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _playlistController,
              onChanged: (value) {
                if (value.length > 30) { // Change the limit to 30
                  _playlistController.text = value.substring(0, 30); // Substring to 30 characters
                  _playlistController.selection = TextSelection.fromPosition(
                    TextPosition(offset: 30), // Set cursor position at the 30th character
                  );
                }
              },
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Playlist Name",
                labelStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Color(0xFF777777),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF777777)),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),


            SizedBox(height: 10),
            // GestureDetector(
            //   onTap: _pickImage,
            //   child: Container(
            //     height: MediaQuery.of(context).size.height * 0.2,
            //     width: MediaQuery.of(context).size.width * 0.8,
            //     decoration: BoxDecoration(
            //       color: Colors.grey[700],
            //       borderRadius: BorderRadius.circular(5),
            //       image: DecorationImage(
            //         image: _pickedFile != null
            //             ? (kIsWeb
            //             ? NetworkImage(_pickedFile!.path)
            //             : FileImage(File(_pickedFile!.path))) as ImageProvider
            //             : (widget.initialImagePath != null
            //             ? (widget.initialImagePath!.startsWith('assets/')
            //             ? AssetImage(widget.initialImagePath!)
            //             : FileImage(File(widget.initialImagePath!)))
            //             : AssetImage('assets/default_song_cover.png')) as ImageProvider,
            //         fit: BoxFit.cover,
            //       ),
            //     ),
            //     child: _pickedFile == null && widget.initialImagePath == null
            //         ? Center(
            //       child: Text(
            //         "Tap to upload cover image",
            //         style: TextStyle(color: Colors.white70),
            //       ),
            //     )
            //         : null,
            //   ),
            // ),
            SizedBox(height: 5),
            if (_errors.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _errors.map((error) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, top: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 16),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            error,
                            style: TextStyle(color: Colors.red, fontSize: 14),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _isSaving ? null : _onSavePressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.white.withOpacity(0.6); // ~60% opacity when disabled
                }
                return Colors.white;
              },
            ),
            foregroundColor: MaterialStateProperty.resolveWith<Color>(
                  (states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.black.withOpacity(0.4); // ~40% opacity when disabled
                }
                return Colors.black;
              },
            ),
            elevation: MaterialStateProperty.all(6),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: Colors.black12),
              ),
            ),
            padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(vertical: 16),
            ),
            textStyle: MaterialStateProperty.all(
              TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          child: _isSaving
              ? CircularProgressIndicator(color: Colors.black)
              : Text(
            'Save',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
