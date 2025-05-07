import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';  // Import the audioplayers package
import 'edit_playlist.dart';

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
      await _audioPlayer.play(DeviceFileSource(audioFilePath)); // Play the new song
      setState(() {
        _currentlyPlayingIndex = index;
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();  // Dispose of the audio player when the widget is disposed
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
                  width: 300,
                  height: 350,
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
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _updatedPlaylistName ?? widget.playlistName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 33,
                      fontWeight: FontWeight.bold,
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

  Widget _buildSongRow(int index, String title, String artist, String audioFilePath, bool isPlaying) {
    return Row(
      children: [
        Text('${index + 1}',
            style: TextStyle(color: Colors.white, fontSize: 16)),
        SizedBox(width: 30),
        Expanded(
          child: Text(title,
              style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
        SizedBox(width: 85),
        Expanded(
          child: Text(artist,
              style: TextStyle(color: Colors.white, fontSize: 16)),
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
        )
      ],
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
                          title: Text(song['title'], style: TextStyle(color: Colors.white)),
                          subtitle: Text(song['artist'], style: TextStyle(color: Colors.white60)),
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
  void _showEditPlaylistDialog() {
    TextEditingController nameController = TextEditingController(text: _updatedPlaylistName);
    File? selectedImage;
    String updatedImage = widget.playlistImage;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Color(0xFF121212),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                padding: EdgeInsets.all(20),
                constraints: BoxConstraints(maxHeight: 500),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Playlist Name",
                        labelStyle: TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Color(0xFF2A2A2A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          final newPath = 'assets/playlist_cover/${pickedFile.name}';
                          final newFile = File(newPath);

                          await File(pickedFile.path).copy(newFile.path);

                          setState(() {
                            selectedImage = newFile;
                            updatedImage = newPath;
                          });
                        }
                      },
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: selectedImage != null
                                ? FileImage(selectedImage!)
                                : widget.playlistImage.startsWith('/')
                                ? FileImage(File(widget.playlistImage))
                                : AssetImage(widget.playlistImage) as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: selectedImage == null
                            ? Center(
                          child: Text(
                            "Tap to change cover image",
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                            : null,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _updatedPlaylistName = nameController.text;
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("Save Changes",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
