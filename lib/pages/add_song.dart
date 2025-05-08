import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddSong extends StatefulWidget {
  final Map<String, dynamic> song;
  AddSong({required this.song});

  @override
  _AddSongState createState() => _AddSongState();
}

class _AddSongState extends State<AddSong> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _playlists = [];
  List<String> _selectedPlaylistIds = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchEligiblePlaylists();
  }

  Future<void> _fetchEligiblePlaylists() async {
    final userId = _auth.currentUser?.uid ?? '';
    final songFile = widget.song['file'];
    final snapshot = await _firestore
        .collection('playlists')
        .where('userId', isEqualTo: userId)
        .get();

    final eligible = snapshot.docs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final List<dynamic> songs = data['songs'] ?? [];
      // Filter out playlists that already contain the song
      return !songs.any((s) => s['file'] == songFile);
    }).map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'id': doc.id,
        'name': data['name'] ?? 'Unnamed Playlist',
        'image': data['imagePath'] ?? 'assets/default_song_cover.png',
        'songs': data['songs'] ?? [],
      };
    }).toList();

    setState(() {
      _playlists = eligible;
      _loading = false;
    });
  }

  Future<void> _addSongToSelectedPlaylists() async {
    for (final playlist in _playlists.where((p) => _selectedPlaylistIds.contains(p['id']))) {
      await _firestore.collection('playlists').doc(playlist['id']).update({
        'songs': FieldValue.arrayUnion([widget.song])
      });
    }
    Navigator.pop(context, _selectedPlaylistIds);
  }

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
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Container(
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
            Flexible(
              child: _playlists.isEmpty
                  ? Center(
                child: Text(
                  "Looks like you don't have any playlists yet. Please create one.",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              )
                  : SingleChildScrollView(
                child: Column(
                  children: _playlists.map((playlist) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        children: [
                          Image.asset(
                            playlist['image'],
                            width: 50,
                            height: 50,
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                playlist['name'],
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                '${(playlist['songs'] as List).length} songs',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_selectedPlaylistIds.contains(playlist['id'])) {
                                  _selectedPlaylistIds.remove(playlist['id']);
                                } else {
                                  _selectedPlaylistIds.add(playlist['id']);
                                }
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: _selectedPlaylistIds.contains(playlist['id'])
                                      ? Colors.black
                                      : Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: _selectedPlaylistIds.contains(playlist['id'])
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
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _selectedPlaylistIds.isEmpty ? null : _addSongToSelectedPlaylists,
                child: Text('Done'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}