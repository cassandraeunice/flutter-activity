import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart'; // Import path_provider
import 'package:flutter/foundation.dart'; // Import for kIsWeb

class CreatePlaylist extends StatefulWidget {
  @override
  _CreatePlaylistState createState() => _CreatePlaylistState();
}

class _CreatePlaylistState extends State<CreatePlaylist> {
  final TextEditingController _playlistController = TextEditingController();
  final List<String> _errors = [];
  XFile? _pickedFile; // Use XFile from image_picker
  bool _isCreating = false;

  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      // Local saving not supported on web using path_provider
      print("Saving locally is not supported on web.");
      return null;
    }

    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final Directory playlistPicturesDir = Directory(path.join(appDocDir.parent.path, 'playlist_pictures'));

      // Create the directory if it doesn't exist
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

  Future<void> _createPlaylist() async {
    _validateInput();
    if (_errors.isEmpty) {
      setState(() {
        _isCreating = true;
      });

      try {
        final String userId = _auth.currentUser?.uid ?? '';
        if (userId.isEmpty) {
          throw Exception("User not authenticated");
        }

        // Step 1: Create playlist without imagePath initially
        final playlistRef = await _firestore.collection('playlists').add({
          'name': _playlistController.text,
          'userId': userId,
          'createdAt': FieldValue.serverTimestamp(),
          'songs': [],
        });

        final playlistId = playlistRef.id;
        String? localImagePath;

        // Step 2: Save the image locally (if picked and not on web)
        if (!kIsWeb && _pickedFile != null) {
          localImagePath = await _saveImageLocally(_pickedFile!, playlistId);
        }

        // Step 3: Update Firestore with the image path
        await _firestore.collection('playlists').doc(playlistId).update({
          'imagePath': localImagePath ?? 'assets/default_song_cover.png', // Use local path or default
        });

        Navigator.pop(context, {
          'name': _playlistController.text,
          'image': localImagePath ?? 'assets/default_song_cover.png',
        });
      } catch (e) {
        setState(() {
          _errors.add("Error creating playlist: ${e.toString()}");
        });
      } finally {
        setState(() {
          _isCreating = false;
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
          "Create playlist name",
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
              style: TextStyle(color: Colors.white),
              maxLength: 50,
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
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(5),
                  image: _pickedFile != null
                      ? DecorationImage(
                    fit: BoxFit.cover,
                    image: kIsWeb
                        ? NetworkImage(_pickedFile!.path) // Display blob for web preview
                        : FileImage(File(_pickedFile!.path)), // Display local file for mobile preview
                  )
                      : null,
                ),
                child: _pickedFile == null
                    ? Center(
                  child: Text(
                    "Tap to upload cover image",
                    style: TextStyle(color: Colors.white70),
                  ),
                )
                    : null,
              ),
            ),
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
          ],
        ),
      ),
        bottomNavigationBar: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _isCreating ? null : _createPlaylist,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    (states) {
                  if (states.contains(WidgetState.disabled)) {
                    return Colors.white.withOpacity(0.6);
                  }
                  return Colors.white;
                },
              ),
              foregroundColor: WidgetStateProperty.resolveWith<Color>(
                    (states) {
                  if (states.contains(WidgetState.disabled)) {
                    return Colors.black.withOpacity(0.4);
                  }
                  return Colors.black;
                },
              ),
              elevation: WidgetStateProperty.all(6),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(color: Colors.black12),
                ),
              ),
              padding: WidgetStateProperty.all(
                EdgeInsets.symmetric(vertical: 16),
              ),
              textStyle: WidgetStateProperty.all(
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            child: _isCreating
                ? CircularProgressIndicator(color: Colors.black)
                : Text(
              'Create',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
    );
  }
}