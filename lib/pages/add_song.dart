import 'package:flutter/material.dart';

class AddSong extends StatefulWidget {
  @override
  _AddSongState createState() => _AddSongState();
}

class _AddSongState extends State<AddSong> {
  final List<Map<String, String>> _playlists = [
    {'name': 'Playlist 1', 'image': 'assets/playlist/playlist1.jpg', 'songs': '12 songs'},
    {'name': 'Playlist 2', 'image': 'assets/playlist/playlist2.jpg', 'songs': '8 songs'},
  ];

  List<String> _selectedPlaylists = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Add to Playlist',
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
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // List of playlists with checkboxes
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: _playlists.map((playlist) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        children: [
                          Image.asset(
                            playlist['image']!,
                            width: 50,
                            height: 50,
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                playlist['name']!,
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                playlist['songs']!,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          Spacer(),
                          // Custom Checkbox with border color changes
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_selectedPlaylists.contains(playlist['name'])) {
                                  _selectedPlaylists.remove(playlist['name']);
                                } else {
                                  _selectedPlaylists.add(playlist['name']!);
                                }
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: _selectedPlaylists.contains(playlist['name'])
                                      ? Colors.black
                                      : Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: _selectedPlaylists.contains(playlist['name'])
                                    ? Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                )
                                    : Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Done Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, _selectedPlaylists);
                  print('Selected Playlists: $_selectedPlaylists');
                },
                child: Text('Done'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,  // White background
                  foregroundColor: Colors.black,        // Black text color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
