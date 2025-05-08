import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For loading JSON file
import 'song.dart';
import 'add_song.dart';
import 'artist_songs.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Controller for the search text field
  TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> allSongs = [];
  List<Map<String, dynamic>> filteredSongs = [];
  List<String> filteredArtists = []; // Add a list to store filtered artists

  @override
  void initState() {
    super.initState();
    // Load songs once when the page is initialized
    _loadSongs();
  }

  // Load songs from the JSON file asynchronously
  Future<void> _loadSongs() async {
    final String response = await rootBundle.loadString('assets/songs.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      allSongs = List<Map<String, dynamic>>.from(data);
      filteredSongs = List.from(allSongs); // Initially show all songs
    });
  }

  // Filter the songs based on the search query
  void _filterSongs(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredSongs = List.from(allSongs); // Show all songs if query is empty
        filteredArtists = []; // Clear filtered artists
      } else {
        filteredSongs = allSongs.where((song) {
          final titleLower = song['title'].toLowerCase();
          final artistLower = song['artist'].toLowerCase();
          final queryLower = query.toLowerCase();

          // Filter based on title or artist matching the query
          return titleLower.contains(queryLower) || artistLower.contains(queryLower);
        }).toList();

        // Filter unique artists matching the query
        filteredArtists = allSongs
            .map((song) => song['artist'] as String)
            .where((artist) => artist.toLowerCase().contains(query.toLowerCase()))
            .toSet()
            .toList();
      }
    });
  }

  List<String> _getArtistsFromSongs(List<Map<String, dynamic>> songs) {
    return songs.map((song) => song['artist'] as String).toSet().toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
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
      ),
      body: allSongs.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loading until songs are loaded
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, bottom: 15.0, right: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Search",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),

              // Search bar (editable text)
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
                        controller: _searchController,
                        maxLength: 120,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        decoration: InputDecoration(
                          hintText: "Artists, songs, or podcasts",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none,
                          counterText: "", // Hides the character counter
                        ),
                        onChanged: (value) {
                          _filterSongs(value); // Filter songs and artists based on search query
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // Display results only if user starts typing
              if (_searchController.text.isNotEmpty) ...[
                // Artists Section
                if (filteredArtists.isNotEmpty) ...[
                  Text(
                    "Artists",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filteredArtists.length,
                    itemBuilder: (context, index) {
                      final artist = filteredArtists[index];
                      final artistImage = allSongs.firstWhere(
                            (song) => song['artist'] == artist,
                        orElse: () => {'artist_image': 'assets/defaultpic.jpg'},
                      )['artist_image'];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(artistImage),
                            radius: 30,
                          ),
                          title: Text(
                            artist,
                            style: TextStyle(color: Colors.white),
                          ),
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
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16),
                ],

                // Songs Section
                if (filteredSongs.isNotEmpty) ...[
                  Text(
                    "Songs",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filteredSongs.length,
                    itemBuilder: (context, index) {
                      final song = filteredSongs[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: ClipRRect(
                          borderRadius: BorderRadius.zero,
                          child: Image.asset(
                            song['image'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          song['title'],
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          song['artist'],
                          style: TextStyle(color: Colors.white54),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.add, color: Colors.white),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Container(
                                  height: 350,
                                  width: 300,
                                  child: AddSong(song: song),
                                ),
                              ),
                            );
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SongPage(
                                title: song['title'],
                                artist: song['artist'],
                                image: song['image'],
                                file: song['file'],
                                songs: allSongs,
                                currentIndex: allSongs.indexOf(song),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 16),
                ],
              ] else ...[
                Text(
                  "Artists",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 120, // Adjust height as needed
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _getArtistsFromSongs(allSongs).map((artist) {
                        final artistImage = allSongs.firstWhere(
                              (song) => song['artist'] == artist,
                          orElse: () => {'artist_image': 'assets/defaultpic.jpg'},
                        )['artist_image'];

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            children: [
                              GestureDetector(
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
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: AssetImage(artistImage),
                                  onBackgroundImageError: (exception, stackTrace) {
                                    // Fallback to default image if there's an error
                                  },
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                artist,
                                style: TextStyle(color: Colors.white, fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Songs",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: ListView.builder(
                      itemCount: allSongs.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        // Shuffle the songs list
                        allSongs.shuffle();
                        final song = allSongs[index];
                        return ListTile(
                          leading: Image.asset(
                            song['image'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.music_note, color: Colors.white);
                            },
                          ),
                          title: Text(song['title'], style: TextStyle(color: Colors.white)),
                          subtitle: Text(song['artist'], style: TextStyle(color: Colors.white54)),
                          trailing: IconButton(
                            icon: Icon(Icons.add, color: Colors.white),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Container(
                                    height: 350,
                                    width: 300,
                                    child: AddSong(song: song),
                                  ),
                                ),
                              );
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SongPage(
                                  title: song['title'],
                                  artist: song['artist'],
                                  image: song['image'],
                                  file: song['file'],
                                  songs: allSongs,
                                  currentIndex: allSongs.indexOf(song),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

