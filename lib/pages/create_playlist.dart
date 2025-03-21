import 'package:flutter/material.dart';

class CreatePlaylist extends StatefulWidget {
  @override
  _CreatePlaylistState createState() => _CreatePlaylistState();
}

class _CreatePlaylistState extends State<CreatePlaylist> {
  final TextEditingController _playlistController = TextEditingController();
  final List<String> _errors = [];

  void _validateInput() {
    setState(() {
      _errors.clear();
      if (_playlistController.text.isEmpty) {
        _errors.add("Playlist name cannot be empty.");
      }
    });
  }

  void _onCreatePressed() {
    _validateInput();
    if (_errors.isEmpty) {
      // Handle playlist creation logic here
      print("Playlist created: ${_playlistController.text}");
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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Give your playlist a name",
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

            // Create Button
            Center(
              child: ElevatedButton(
                onPressed: _onCreatePressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: Size(200, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(
                  'Create',
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
