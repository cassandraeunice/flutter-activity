import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart'; // Import the audioplayers package
import 'edit_playlist.dart';
import 'artist_songs.dart';
import 'song.dart';

class PlaylistPage extends StatefulWidget {
  final String playlistName;
  final String playlistImage;

  PlaylistPage({required this.playlistName, required this.playlistImage});

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  int? _currentlyPlayingIndex;
  List<Map<String, dynamic>> allSongs = [];
  List<dynamic> playlistSongs = [];
  String? _updatedPlaylistName;
  String? playlistId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AudioPlayer _audioPlayer = AudioPlayer(); // AudioPlayer instance

  @override
  void initState() {
    super.initState();
    _updatedPlaylistName = widget.playlistName;
    _loadSongs();
    _loadPlaylistFromFirestore();
  }

  Future<void> _loadSongs() async {
    final String response = await rootBundle.loadString('assets/songs.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      allSongs = List<Map<String, dynamic>>.from(data);
    });
  }

  Future<void> _loadPlaylistFromFirestore() async {
    final query = await _firestore
        .collection('playlists')
        .where('name', isEqualTo: widget.playlistName)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;
      setState(() {
        playlistId = doc.id;
        playlistSongs = doc['songs'] ?? [];
      });
    }
  }

  Future<void> _addSongToPlaylist(Map<String, dynamic> song) async {
    if (playlistId == null) return;

    if (playlistSongs.any((s) => s['song_id'] == song['song_id'])) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Song already in playlist')),
      );
      return;
    }

    setState(() {
      playlistSongs.add(song);
    });

    await _firestore.collection('playlists').doc(playlistId).update({
      'songs': playlistSongs,
    });
  }

  Future<void> _removeSongFromPlaylist(int index) async {
    if (playlistId == null) return;

    setState(() {
      playlistSongs.removeAt(index);
    });

    await _firestore.collection('playlists').doc(playlistId).update({
      'songs': playlistSongs,
    });
  }

  // Play or Pause functionality
  void _playPause(int index, String audioFilePath) async {
    if (_currentlyPlayingIndex == index) {
      await _audioPlayer.pause();
      setState(() {
        _currentlyPlayingIndex = null;
      });
    } else {
      await _audioPlayer.stop(); // Stop any currently playing song
      await _audioPlayer
          .play(DeviceFileSource(audioFilePath)); // Play the new song
      setState(() {
        _currentlyPlayingIndex = index;
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer
        .dispose(); // Dispose of the audio player when the widget is disposed
    super.dispose();
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
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: widget.playlistImage.startsWith('/')
                          ? FileImage(File(widget.playlistImage))
                          : AssetImage(widget.playlistImage) as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _updatedPlaylistName ?? widget.playlistName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 33,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2, // Allow up to 2 lines
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.add, color: Colors.white, size: 25),
                        tooltip: 'Add Song',
                        onPressed: _showAddSongDialog,
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.white, size: 20),
                        tooltip: 'Edit Playlist',
                        onPressed: _showEditPlaylistDialog,
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
                  SizedBox(width: 30),
                  Expanded(
                    child: Text('Title',
                        style: TextStyle(
                            color: Color(0xFFB3B3B3),
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(width: 0),
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
              playlistSongs.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: playlistSongs.length,
                      itemBuilder: (context, index) {
                        var song = playlistSongs[index];
                        bool isPlaying = _currentlyPlayingIndex == index;
                        return _buildSongRow(
                          index,
                          song['title'],
                          song['artist'],
                          song['file'], // The file path to the audio
                          isPlaying,
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'No songs in playlist',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSongRow(int index, String title, String artist,
      String audioFilePath, bool isPlaying) {

    final song = allSongs.firstWhere(
          (s) => s['title'] == title && s['artist'] == artist,
      orElse: () => {},
    );

    final artistImage = allSongs.firstWhere(
          (song) => song['artist'].toLowerCase() == artist.toLowerCase(),
      orElse: () => {'artist_image': 'assets/defaultpic.jpg'},
    )['artist_image'];

    return GestureDetector(
      onTap: () {
        if (song.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SongPage(
                title: song['title'],
                artist: song['artist'],
                image: song['image'],
                file: song['file'],
                songs: playlistSongs.cast<Map<String, dynamic>>(),
                currentIndex: index,
              ),
            ),
          );
        }
      },
      child: Row(
        children: [
          Text('${index + 1}', style: TextStyle(color: Colors.white, fontSize: 16)),
          SizedBox(width: 30),
          Expanded(
            child: Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
          SizedBox(width: 85),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArtistSongsPage(
                      artist: artist,
                      image: artistImage,
                      allSongs: allSongs,
                    ),
                  ),
                );
              },
              child: Text(
                artist,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
              color: Colors.white,
              size: 35,
            ),
            onPressed: () {
              _playPause(index, audioFilePath);
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onSelected: (String choice) {
              if (choice == 'delete') {
                _removeSongFromPlaylist(index);
              }
            },
            color: Colors.black,
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'delete',
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Show Add Song dialog
  void _showAddSongDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF1E1E1E),
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        TextEditingController searchController = TextEditingController();
        List<Map<String, dynamic>> searchResults = List.from(allSongs);

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 5,
                    width: 40,
                    margin: EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                  TextField(
                    controller: searchController,
                    onChanged: (query) {
                      setModalState(() {
                        searchResults = allSongs
                            .where((song) =>
                                song['title']
                                    .toLowerCase()
                                    .contains(query.toLowerCase()) ||
                                song['artist']
                                    .toLowerCase()
                                    .contains(query.toLowerCase()))
                            .toList();
                      });
                    },
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search songs...',
                      hintStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Color(0xFF2A2A2A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final song = searchResults[index];
                        return ListTile(
                          title: Text(song['title'],
                              style: TextStyle(color: Colors.white)),
                          subtitle: Text(song['artist'],
                              style: TextStyle(color: Colors.white60)),
                          onTap: () async {
                            await _addSongToPlaylist(song);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Show Edit Playlist dialog
  void _showEditPlaylistDialog() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.30,
            height: MediaQuery.of(context).size.height * 0.40,
            child: EditPlaylist(
              initialName: _updatedPlaylistName ?? widget.playlistName,
              initialImagePath: widget.playlistImage,
              playlistId: playlistId!, // Assuming playlistId is not null here
            ),
          ),
        );
      },
    );

    // Process the result from the EditPlaylist screen
    if (result != null) {
      String? newName = result['name'];
      String? newImagePath = result['imagePath'];

      if (newName != null || newImagePath != null) {
        try {
          Map<String, dynamic> updateData = {};
          if (newName != null) {
            updateData['name'] = newName;
            setState(() {
              _updatedPlaylistName = newName;
            });
          }
          if (newImagePath != null && newImagePath != widget.playlistImage) {
            updateData['imagePath'] = newImagePath;
          }

          if (updateData.isNotEmpty && playlistId != null) {
            await _firestore
                .collection('playlists')
                .doc(playlistId)
                .update(updateData);
            // Optionally, you might want to refresh the playlist data here
            // _loadPlaylistFromFirestore();
          }
        } catch (e) {
          print("Error updating playlist: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update playlist')),
          );
        }
      }
    }
  }
}
