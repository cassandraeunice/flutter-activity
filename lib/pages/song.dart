import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'mini_player.dart';
import 'add_song.dart'; // Import AddSong screen

class SongPage extends StatefulWidget {
  final String title;
  final String artist;
  final String image;
  final String file;
  final List<Map<String, dynamic>> songs;
  final int currentIndex;

  SongPage({
    required this.title,
    required this.artist,
    required this.image,
    required this.file,
    required this.songs,
    required this.currentIndex,
  });

  @override
  _SongPageState createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();

    // Listen for changes in the total duration of the audio
    _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() {
          _totalDuration = duration;
        });
      }
    });

    // Listen for changes in the current position of the audio
    _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
    });

    // Reset the state when the audio finishes playing
    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _currentPosition = Duration.zero;
        });
      }
    });

    // Load the audio file
    _audioPlayer.setSourceDeviceFile(widget.file);
  }

  void _playPause() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
        if (mounted) {
          setState(() {
            _isPlaying = false;
          });
        }
      } else {
        String? filePath = widget.file.isNotEmpty ? widget.file : null;

        if (filePath != null) {
          await _audioPlayer.setSourceDeviceFile(filePath);
          await _audioPlayer.resume(); // Use resume to start playback
          if (mounted) {
            setState(() {
              _isPlaying = true;
            });
          }
        } else {
          print("No file selected or file path is empty.");
        }
      }
    } catch (e) {
      print("Error in play/pause: $e");
    }
  }

  void _nextTrack() async {
    if (widget.currentIndex < widget.songs.length - 1) {
      final nextSong = widget.songs[widget.currentIndex + 1];
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SongPage(
            title: nextSong['title'],
            artist: nextSong['artist'],
            image: nextSong['image'],
            file: nextSong['file'],
            songs: widget.songs,
            currentIndex: widget.currentIndex + 1,
          ),
        ),
      );
      _playPause(); // Automatically play the next track
    }
  }

  void _prevTrack() async {
    if (widget.currentIndex > 0) {
      final prevSong = widget.songs[widget.currentIndex - 1];
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SongPage(
            title: prevSong['title'],
            artist: prevSong['artist'],
            image: prevSong['image'],
            file: prevSong['file'],
            songs: widget.songs,
            currentIndex: widget.currentIndex - 1,
          ),
        ),
      );
      _playPause(); // Automatically play the previous track
    }
  }

  void _showAddSongDialog() async {
    // Show AddSong as a dialog box with smaller size
    final selectedPlaylists = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            height: 350,
            width: 300,
            child: AddSong(), // Use AddSong screen here
          ),
        );
      },
    );

    // Check if any playlists were selected
    if (selectedPlaylists != null && selectedPlaylists.isNotEmpty) {
      // Show confirmation or process the selected playlists
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Song added to ${selectedPlaylists.length} playlist(s)')),
      );
      // You can now update the UI or the song data based on the selected playlists
      print('Selected Playlists: $selectedPlaylists');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Color(0xFF121212),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 350,
                      height: 350,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(widget.image),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2, // Limit to 2 lines
                              overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                            ),
                            SizedBox(height: 4),
                            Text(
                              widget.artist,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.favorite_border, color: Colors.white, size: 30),
                        onPressed: _showAddSongDialog, // Show the dialog on heart icon click
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        _formatDuration(_currentPosition),
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      Expanded(
                        child: Slider(
                          value: _currentPosition.inSeconds.toDouble(),
                          min: 0,
                          max: _totalDuration.inSeconds.toDouble() > 0
                              ? _totalDuration.inSeconds.toDouble()
                              : 1, // Prevent division by zero
                          onChanged: (value) async {
                            final position = Duration(seconds: value.toInt());
                            await _audioPlayer.seek(position);
                            if (mounted) {
                              setState(() {
                                _currentPosition = position;
                              });
                            }
                          },
                          activeColor: Colors.white,
                          inactiveColor: Colors.grey,
                        ),
                      ),
                      Text(
                        _formatDuration(_totalDuration),
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.skip_previous, color: Colors.white, size: 40),
                        onPressed: _prevTrack,
                      ),
                      IconButton(
                        icon: Icon(
                          _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                          color: Colors.white,
                          size: 70,
                        ),
                        onPressed: _playPause,
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next, color: Colors.white, size: 40),
                        onPressed: _nextTrack,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
