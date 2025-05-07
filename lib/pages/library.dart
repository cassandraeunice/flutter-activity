import 'package:flutter/material.dart';
import 'create_playlist.dart';
import 'edit_playlist.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'song.dart';
import 'artist_songs.dart';
import 'playlist.dart';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  List<Map<String, String>> _playlists = [];
  List<Map<String, dynamic>> _songs = [];
  String _selectedCategory = 'Songs';

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
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.53,
                      child: CreatePlaylist(),
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
                    _buildCategoryChip('Songs'),
                    SizedBox(width: 8),
                    _buildCategoryChip('Artists'),
                    SizedBox(width: 8),
                    _buildCategoryChip('Playlists'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              if (_selectedCategory == 'Songs') ...[
                _buildSongList(),
              ],
              if (_selectedCategory == 'Artists') ...[
                ..._getUniqueArtists().map((artist) => _buildArtistItem(artist)).toList(),
              ],
              if (_selectedCategory == 'Playlists') ...[
                ..._playlists.map((_playlists) => _buildPlaylistItem(_playlists)).toList(),
              ],
            ],
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SongPage(
              title: song['title'], // Pass the song title
              artist: song['artist'], // Pass the song artist
              image: song['image'], // Pass the song image
              file: song['file'], // Pass the song file
            ),
          ),
        );
      },
      child: Padding(
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
      ),
    );
  }

  Widget _buildArtistItem(String artist) {
    // Find the first song by the artist to get the artist image
    final artistImage = _songs.firstWhere(
          (song) => song['artist'].toLowerCase() == artist.toLowerCase(),
      orElse: () => {'artist_image': 'assets/defaultpic.jpg'},
    )['artist_image'];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArtistSongsPage(
              artist: artist,
              image: artistImage, // Pass the artist image
              allSongs: _songs, // Pass all songs to filter in ArtistSongsPage
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: AssetImage(artistImage ?? 'assets/defaultpic.jpg'),
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
      ),
    );
  }

  Widget _buildPlaylistItem(Map<String, String> playlist) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaylistPage(
              playlistName: playlist['name'] ?? 'Unknown Playlist',
              playlistImage: playlist['image'] ?? 'assets/defaultpic.jpg',
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          children: [
            _buildRecentlyPlayedItem(
              playlist['name'] ?? 'Unknown Playlist',
              'Playlist',
              playlist['image'] ?? 'assets/defaultpic.jpg',
            ),
            Spacer(),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: Colors.white),
              onSelected: (value) async {
                if (value == 'Edit') {
                  final result = await showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.53,
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
                } else if (value == 'Delete') {
                  setState(() {
                    _playlists.remove(playlist);
                  });
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  value: 'Edit',
                  child: Text('Edit'),
                ),
                PopupMenuItem(
                  value: 'Delete',
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentlyPlayedItem(String title, String subtitle, String imagePath) {
    return Row(
      children: [
        imagePath.startsWith('/') // Check if the imagePath is a file path
            ? Image.file(
          File(imagePath),
          width: 67,
          height: 67,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.broken_image, color: Colors.grey, size: 67);
          },
        )
            : Image.asset(
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