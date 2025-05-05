import 'package:flutter/material.dart';
import 'edit_playlist.dart';

class PlaylistPage extends StatefulWidget {
  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  int? _currentlyPlayingIndex; // Stores which song is currently playing (null means none)

  // Sample list of songs for search
  List<String> songList = [
    'Strawberries & Cigarettes',
    'Angel Baby',
    'Youth',
    'The Good Side',
    'Someone Like You',
    'Blinding Lights',
    'Stay',
    'Levitating',
  ];

  List<String> filteredSongs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Color(0xFF121212),
        elevation: 0,
        title: SizedBox.shrink(),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 300,
                  height: 350,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/album/clairo.jpg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Study Hub',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 33,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.add, color: Color(0xFFF94C57), size: 25),
                            tooltip: 'Add Song',
                            onPressed: () {
                              _showAddSongDialog();
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, color: Color(0xFFF94C57), size: 20),
                            tooltip: 'Edit Playlist',
                            onPressed: () {
                              _showEditPlaylistDialog();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundImage: AssetImage('assets/defaultpic.jpg'),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Cassandra',
                        style: TextStyle(
                          color: Color(0xFFF94C57),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('#',
                      style: TextStyle(
                          color: Color(0xFFB3B3B3),
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  SizedBox(width: 15),
                  Expanded(
                    child: Text('Title',
                        style: TextStyle(
                            color: Color(0xFFB3B3B3),
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Text('Artist',
                        style: TextStyle(
                            color: Color(0xFFB3B3B3),
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              SizedBox(height: 10),
              // Songs
              _buildSongRow(0, 'Strawberries & Cigarettes', 'Troye Sivan'),
              SizedBox(height: 16),
              _buildSongRow(1, 'Angel Baby', 'Troye Sivan'),
              SizedBox(height: 16),
              _buildSongRow(2, 'Youth', 'Troye Sivan'),
              SizedBox(height: 16),
              _buildSongRow(3, 'The Good Side', 'Troye Sivan'),
            ],
          ),
        ),
      ),
    );
  }

  // Your existing code ...

  Widget _buildSongRow(int index, String title, String artist) {
    bool isPlaying = _currentlyPlayingIndex == index;

    return Row(
      children: [
        Text('${index + 1}',
            style: TextStyle(color: Colors.white, fontSize: 16)),
        SizedBox(width: 20),
        Expanded(
          child: Text(title,
              style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
        SizedBox(width: 40),
        Expanded(
          child: Text(artist,
              style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
        IconButton(
          icon: Icon(
            isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
            color: Color(0xFFF94C57),
            size: 35,
          ),
          onPressed: () {
            setState(() {
              if (isPlaying) {
                _currentlyPlayingIndex = null; // Stop playing
              } else {
                _currentlyPlayingIndex = index; // Start this song
              }
            });
          },
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: Colors.white),
          onSelected: (String choice) {
            if (choice == 'delete') {
              // Handle delete action
              print('Delete song at index $index');
            }
          },
          color: Colors.black,
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              value: 'delete',
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                child: Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  // Method to navigate to the EditPlaylistPage as a dialog
  void _showEditPlaylistDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color(0xFF121212),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            width: 300,
            height: 350,
            padding: EdgeInsets.all(20),
            child: EditPlaylist(
              initialName: songList[0], // Pass the song title (or modify to pass selected song)
            ),
          ),
        );
      },
    );
  }

  // Show the add song dialog
  void _showAddSongDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF121212),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: Text(
            'Add songs',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Search TextField with similar design as the main page
              Container(
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.black),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        onChanged: (query) {
                          setState(() {
                            filteredSongs = songList
                                .where((song) =>
                                song.toLowerCase().contains(query.toLowerCase()))
                                .toList();
                          });
                        },
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'Search songs...',
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none, // Removes the border
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              // Display filtered songs or a no results message
              if (filteredSongs.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredSongs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        filteredSongs[index],
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        // Handle song selection
                        print('Song selected: ${filteredSongs[index]}');
                        Navigator.pop(context); // Close dialog
                      },
                    );
                  },
                )
              else
                Center(
                  child: Text(
                    'No songs found',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
          actions: [
            // Cancel button
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            // Add button
            TextButton(
              onPressed: () {
                // Optionally handle adding song
                print("Add song button pressed.");
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                'Add',
                style: TextStyle(color: Color(0xFFF94C57)),
              ),
            ),
          ],
        );
      },
    );
  }
}
