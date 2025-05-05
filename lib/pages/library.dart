import 'package:flutter/material.dart';
import 'create_playlist.dart';
import 'edit_playlist.dart';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  List<Map<String, String>> _playlists = [];
  List<Map<String, String>> _artists = [
    {'name': 'Kendrick Lamar', 'imagePath': 'assets/album/gnx.jpg'},
    {'name': 'Doechiii', 'imagePath': 'assets/album/alligatorbites.jpg'},
    {'name': 'Tyler, The Creator', 'imagePath': 'assets/album/chromakopia.jpg'},
  ];

  String _selectedCategory = 'All';  // Track selected category

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Color(0xFF121212),
        elevation: 0,
        title: SizedBox.shrink(),
        leading: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Color(0xFFA7A7A7),
              size: 30,
            ),
            onPressed: () async {
              final result = await showDialog<Map<String, String>>(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Container(
                      width: 300,
                      height: 350,
                      child: CreatePlaylist(), // Your CreatePlaylist widget here
                    ),
                  );
                },
              );

              if (result != null) {
                setState(() {
                  _playlists.add(result);
                });
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, bottom: 15.0, right: 15.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Your Library",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryChip('Playlists'),
                  SizedBox(width: 10),
                  _buildCategoryChip('Artists'),
                  SizedBox(width: 10),
                ],
              ),
            ),
            SizedBox(height: 20),
            if (_selectedCategory == 'All' || _selectedCategory == 'Playlists') ...[
              _buildRecentlyPlayedItem('Liked Songs', 'Playlist - 58 songs', 'assets/playlist/liked.jpeg'),
              SizedBox(height: 16),
              _buildRecentlyPlayedItem('On Repeat', 'Playlist', 'assets/playlist/playlist2.jpg'),
              SizedBox(height: 16),
              ..._playlists.map((playlist) => _buildPlaylistItem(playlist)).toList(),
            ],
            if (_selectedCategory == 'All' || _selectedCategory == 'Artists') ...[
              SizedBox(height: 16),
              _buildArtistItem('Kendrick Lamar', 'Artist', 'assets/album/gnx.jpg'),
              SizedBox(height: 16),
              _buildArtistItem('Doechiii', 'Artist', 'assets/album/alligatorbites.jpg'),
              SizedBox(height: 16),
              _buildArtistItem('Tyler, The Creator', 'Artist', 'assets/album/chromakopia.jpg'),
              SizedBox(height: 16),
              _buildArtistItem('Oasis', 'Artist', 'assets/album/oasis.jpg'),
              SizedBox(height: 16),
              _buildArtistItem('Reality Club', 'Artist', 'assets/album/realityclub.jpg'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = (_selectedCategory == label) ? 'All' : label; // Toggle the selected category
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: _selectedCategory == label ? Colors.white : Color(0xFF121212),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(
          label,
          style: TextStyle(
            color: _selectedCategory == label ? Colors.black : Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildRecentlyPlayedItem(String title, String subtitle, String imagePath) {
    return Row(
      children: [
        Image.asset(
          imagePath,
          width: 67,
          height: 67,
        ),
        SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: Color(0xFFB3B3B3),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlaylistItem(Map<String, String> playlist) {
    return Row(
      children: [
        _buildRecentlyPlayedItem(playlist['name']!, 'Playlist', playlist['imagePath']!),
        IconButton(
          icon: Icon(Icons.edit, color: Colors.white),
          onPressed: () async {
            final result = await showDialog<String>(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Container(
                    width: 300,
                    height: 350,
                    child: EditPlaylist(initialName: playlist['name']!),
                  ),
                );
              },
            );
            if (result != null) {
              setState(() {
                int index = _playlists.indexOf(playlist);
                _playlists[index]['name'] = result;
              });
            }
          },
        ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.white),
          onPressed: () {
            setState(() {
              _playlists.remove(playlist);
            });
          },
        ),
      ],
    );
  }

  Widget _buildArtistItem(String name, String subtitle, String imagePath) {
    return Row(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundImage: AssetImage(imagePath),
        ),
        SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: Color(0xFFB3B3B3),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
