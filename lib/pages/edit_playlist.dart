import 'package:flutter/material.dart';

class EditPlaylist extends StatefulWidget {
  final String initialName;

  EditPlaylist({required this.initialName});

  @override
  _EditPlaylistState createState() => _EditPlaylistState();
}

class _EditPlaylistState extends State<EditPlaylist> {
  late TextEditingController _playlistController;
  final List<String> _errors = [];

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

  void _onSavePressed() {
    _validateInput();
    if (_errors.isEmpty) {
      // Save button: return the updated playlist name
      Navigator.pop(context, _playlistController.text);
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
            // Back button: just pop the dialog without returning any data
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
            SizedBox(height: 5),

            // Display errors if any
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

            // Save Button
            Center(
              child: ElevatedButton(
                onPressed: _onSavePressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: Size(200, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
