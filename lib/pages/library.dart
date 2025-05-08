import 'package:flutter/material.dart';
import 'create_playlist.dart';
import 'edit_playlist.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'song.dart';
import 'artist_songs.dart';
import 'playlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  List<Map<String, dynamic>> _playlists = [];
  List<Map<String, dynamic>> _songs = [];
  String _selectedCategory = 'Songs';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoadingPlaylists = false;

  List<String> _getArtistsFromPlaylists() {
    final Set<String> artistSet = {};
    for (var playlist in _playlists) {
      final List<dynamic> songs = playlist['songs'] ?? [];
      for (var song in songs) {
        if (song['artist'] != null) {
          artistSet.add(song['artist'] as String);
        }
      }
    }
    final artists = artistSet.toList();
    artists.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return artists;
  }

  List<Map<String, dynamic>> _getSongsFromPlaylists() {
    final Map<String, Map<String, dynamic>> uniqueSongs = {};
    for (var playlist in _playlists) {
      final List<dynamic> songs = playlist['songs'] ?? [];
      for (var song in songs) {
        // Use the file path as a unique key
        if (song['file'] != null) {
          uniqueSongs[song['file']] = Map<String, dynamic>.from(song);
        }
      }
    }
    // Sort by title
    final songsList = uniqueSongs.values.toList();
    songsList.sort((a, b) => a['title'].toLowerCase().compareTo(b['title'].toLowerCase()));
    return songsList;
  }

  @override
  void initState() {
    super.initState();
    _loadSongs();
    _loadUserPlaylists();
  }

  Future<void> _loadSongs() async {
    final String response = await rootBundle.loadString('assets/songs.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      _songs = List<Map<String, dynamic>>.from(data)
        ..sort((a, b) =>
            a['title'].toLowerCase().compareTo(b['title'].toLowerCase()));
    });
  }

  final ScrollController _scrollController = ScrollController();
  final List<String> _alphabet =
      List.generate(26, (index) => String.fromCharCode(65 + index));

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
        offset += (groupedSongs[key]!.length * 80) +
            40; // Approximate height of items and headers
      }

      _scrollController.animateTo(
        offset,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _loadUserPlaylists() async {
    setState(() {
      _isLoadingPlaylists = true;
    });

    try {
      final String userId = _auth.currentUser?.uid ?? '';
      if (userId.isEmpty) return;
      // Query Firestore for playlists belonging to current user
      final QuerySnapshot playlistsSnapshot = await _firestore
          .collection('playlists')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      setState(() {
        _playlists = playlistsSnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;

          return {
            'id': doc.id,
            'name': data['name'] ?? 'Unnamed Playlist',
            'image': data['imagePath'] ?? 'assets/default_song_cover.png',
            'userId': data['userId'],
            'songs': data['songs'] ?? [],
          };
        }).toList();
      });
    } catch (e) {
      print("Error loading playlists: $e");
    } finally {
      setState(() {
        _isLoadingPlaylists = false;
      });
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
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
                _loadUserPlaylists();
              }
            },
          )
        ],
      ),
      body: Stack(
        children: [
          ListView(
            controller: _scrollController,
            padding:
                const EdgeInsets.only(left: 15.0, bottom: 15.0, right: 15.0),
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
                _getSongsFromPlaylists().isEmpty
                    ? Center(
                  child: Text(
                    'No Songs Yet',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                )
                    : _buildSongList(_getSongsFromPlaylists()),
              ],
              if (_selectedCategory == 'Artists') ...[
                _getArtistsFromPlaylists().isEmpty
                    ? Center(
                  child: Text(
                    'No Artists Yet',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                )
                    : Column(
                  children: _getArtistsFromPlaylists()
                      .map((artist) => _buildArtistItem(artist))
                      .toList(),
                ),
              ],
              if (_selectedCategory == 'Playlists') ...[
                _isLoadingPlaylists
                    ? Center(child: CircularProgressIndicator())
                    : _playlists.isEmpty
                        ? Center(
                            child: Text('No Playlists Found',
                                style: TextStyle(color: Colors.white, fontSize: 16)))
                        : Column(
                            children: _playlists
                                .map((playlist) => _buildPlaylistItem(playlist))
                                .toList(),
                          ),
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

  Widget _buildSongList(List<Map<String, dynamic>> songs) {
    Map<String, List<Map<String, dynamic>>> groupedSongs = {};
    for (var song in songs) {
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
              title: song['title'],
              artist: song['artist'],
              image: song['image'],
              file: song['file'],
              songs: _songs, // Pass the list of all songs
              currentIndex: _songs.indexOf(song), // Pass the current song index
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8), // Adjust the radius as needed
              child: Image.asset(
                song['image'],
                width: 65,
                height: 65,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.music_note, color: Colors.grey, size: 65);
                },
              ),
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
              image: artistImage,
              allSongs: _songs,
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
              backgroundImage: AssetImage(artistImage),
              onBackgroundImageError: (exception, stackTrace) {},
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

  Widget _buildPlaylistItem(Map<String, dynamic> playlist) {
    final songCount = (playlist['songs'] as List?)?.length ?? 0;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaylistPage(
              playlistName: playlist['name'] ?? 'Unknown Playlist',
              playlistImage: playlist['image'] ?? 'assets/default_song_cover.png',
            ),
          ),
        ).then((_) {
          _loadUserPlaylists();
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          children: [
            _buildRecentlyPlayedItem(
              playlist['name'] ?? 'Unknown Playlist',
              '$songCount songs', // <-- Show song count here
              playlist['image'] ?? 'assets/default_song_cover.png',
            ),
            Spacer(),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: Colors.white),
              onSelected: (value) async {
                if (value == 'Edit') {
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
                          child: EditPlaylist(
                            initialName: playlist['name'] ?? '',
                            initialImagePath: playlist['image'],
                            playlistId: playlist['id'],
                          ),
                        ),
                      );
                    },
                  );

                  if (result != null) {
                    try {
                      await _firestore
                          .collection('playlists')
                          .doc(playlist['id'])
                          .update({
                        'name': result['name'],
                        if (result['imagePath'] != null)
                          'imagePath': result['imagePath'],
                      });

                      _loadUserPlaylists();
                    } catch (e) {
                      print("Error updating playlist: $e");
                    }
                  }
                } else if (value == 'Delete') {
                  try {
                    await _firestore
                        .collection('playlists')
                        .doc(playlist['id'])
                        .delete();

                    _loadUserPlaylists();
                  } catch (e) {
                    print("Error deleting playlist: $e");
                  }
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  value: 'Edit',
                  child: Text('Edit', style: TextStyle(color: Colors.white)),
                ),
                PopupMenuItem(
                  value: 'Delete',
                  child: Text('Delete', style: TextStyle(color: Colors.white)),
                ),
              ],
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentlyPlayedItem(
      String title, String subtitle, String imagePath) {
    bool isFilePath =
        imagePath.startsWith('/') || imagePath.startsWith('file://');

    return Row(
      children: [
        if (isFilePath)
          ClipRRect(
            borderRadius: BorderRadius.circular(8), // Adjust the radius as needed
            child: Container(
              width: 65,
              height: 65,
              child: Image.file(
                File(imagePath),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/default_song_cover.png',
                    width: 65,
                    height: 65,
                  );
                },
              ),
            ),
          )
        else
          ClipRRect(
            borderRadius: BorderRadius.circular(8), // Adjust the radius as needed
            child: Image.asset(
              imagePath,
              width: 65,
              height: 65,
              fit: BoxFit.cover, // Ensures the image fits within the rounded corners
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/default_song_cover.png',
                  width: 65,
                  height: 65,
                  fit: BoxFit.cover,
                );
              },
            ),
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
    return _songs.map((song) => song['artist'] as String).toSet().toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  }
}
