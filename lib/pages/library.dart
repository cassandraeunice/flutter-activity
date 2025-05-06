import 'package:flutter/material.dart';
import 'create_playlist.dart';
import 'edit_playlist.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  List<Map<String, String>> _playlists = [];
  List<Map<String, dynamic>> _songs = [];
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    final String response = await rootBundle.loadString('assets/songs.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      _songs = List<Map<String, dynamic>>.from(data)
        ..sort((a, b) => a['title'].toLowerCase().compareTo(b['title'].toLowerCase()));
    });
  }

  final ScrollController _scrollController = ScrollController();
  final List<String> _alphabet = List.generate(26, (index) => String.fromCharCode(65 + index));

  void _scrollToLetter(String letter) {
    Map<String, List<Map<String, dynamic>>> groupedSongs = {};
    for (var song in _songs) {
      String firstLetter = song['title'][0].toUpperCase();
      if (!groupedSongs.containsKey(firstLetter)) {
        groupedSongs[firstLetter] = [];
      }
      groupedSongs[firstLetter]!.add(song);
    }

    if (groupedSongs.containsKey(letter)) {
      double offset = 0.0;
      for (var key in groupedSongs.keys) {
        if (key == letter) break;
        offset += (groupedSongs[key]!.length * 80) + 40; // Approximate height of items and headers
      }
      _scrollController.animateTo(
        offset,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

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
      body: Stack(
        children: [
          ListView(
            controller: _scrollController,
            padding: const EdgeInsets.only(left: 15.0, bottom: 15.0, right: 15.0),
            children: [
              Text(
                "Your Library",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip('All'),
                    SizedBox(width: 8),
                    _buildCategoryChip('Artists'),
                    SizedBox(width: 8),
                    _buildCategoryChip('Songs'),
                    SizedBox(width: 8),
                    _buildCategoryChip('Playlists'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              if (_selectedCategory == 'All' || _selectedCategory == 'Songs') ...[
                _buildSongList(),
              ],
              if (_selectedCategory == 'All' || _selectedCategory == 'Artists') ...[
                ..._getUniqueArtists().map((artist) => _buildArtistItem(artist)).toList(),
              ],
              if (_selectedCategory == 'All' || _selectedCategory == 'Playlists') ...[
                ..._playlists.map((_playlists) => _buildPlaylistItem(_playlists)).toList(),
              ],
            ],
          ),
          if (_selectedCategory == 'All' || _selectedCategory == 'Songs')
            Positioned(
              right: 0,
              top: 50,
              bottom: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _alphabet.map((letter) {
                  return GestureDetector(
                    onTap: () => _scrollToLetter(letter),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Text(
                        letter,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = label;
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

  Widget _buildSongList() {
    Map<String, List<Map<String, dynamic>>> groupedSongs = {};
    for (var song in _songs) {
      String firstLetter = song['title'][0].toUpperCase();
      if (!groupedSongs.containsKey(firstLetter)) {
        groupedSongs[firstLetter] = [];
      }
      groupedSongs[firstLetter]!.add(song);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groupedSongs.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                entry.key,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...entry.value.map((song) => _buildSongItem(song)).toList(),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSongItem(Map<String, dynamic> song) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Image.asset(
            song['image'],
            width: 67,
            height: 67,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song['title'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  maxLines: 2, // Allow up to 2 lines for long titles
                  overflow: TextOverflow.ellipsis, // Add ellipsis if it exceeds 2 lines
                ),
                Text(
                  song['artist'],
                  style: TextStyle(
                    color: Color(0xFFB3B3B3),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArtistItem(String artist) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.grey,
            child: Text(
              artist[0],
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          SizedBox(width: 10),
          Text(
            artist,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistItem(Map<String, String> playlist) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          _buildRecentlyPlayedItem(
            playlist['name'] ?? 'Unknown Playlist', // Default value
            'Playlist',
            playlist['image'] ?? 'assets/defaultpic.jpg', // Default image
          ),
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
                      child: EditPlaylist(initialName: playlist['name'] ?? ''),
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
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.broken_image, color: Colors.grey, size: 67);
          },
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Text(
              subtitle,
              style: TextStyle(color: Color(0xFFB3B3B3), fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  List<String> _getUniqueArtists() {
    return _songs
        .map((song) => song['artist'] as String)
        .toSet()
        .toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  }
}