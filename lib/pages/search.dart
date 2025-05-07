import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For loading JSON file
import 'song.dart';
import 'add_song.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Controller for the search text field
  TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> allSongs = [];
  List<Map<String, dynamic>> filteredSongs = [];

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
      } else {
        filteredSongs = allSongs.where((song) {
          final titleLower = song['title'].toLowerCase();
          final artistLower = song['artist'].toLowerCase();
          final queryLower = query.toLowerCase();

          // Filter based on title or artist matching the query
          return titleLower.contains(queryLower) || artistLower.contains(queryLower);
        }).toList();
      }
    });
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
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        decoration: InputDecoration(
                          hintText: "Artists, songs, or podcasts",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          _filterSongs(value); // Filter songs based on search query
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // Display songs only if user starts typing
              if (_searchController.text.isNotEmpty) ...[
                // Songs Section (Display filtered songs here)
                Text(
                  "Songs",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                // List view to show filtered songs
                ListView.builder(
                  shrinkWrap: true, // To avoid taking up unnecessary space
                  physics: NeverScrollableScrollPhysics(), // Prevent scrolling if inside SingleChildScrollView
                  itemCount: filteredSongs.length,
                  itemBuilder: (context, index) {
                    final song = filteredSongs[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: ClipRRect(
                        borderRadius: BorderRadius.zero, // Make the image square
                        child: Image.asset(
                          song['image'], // Use the image from the JSON
                          width: 50, // Set the width of the image
                          height: 50, // Set the height of the image
                          fit: BoxFit.cover, // Ensure the image covers the square area
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
                                child: AddSong(), // Display the AddSong widget
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
                              songs: allSongs, // Pass the list of all songs
                              currentIndex: allSongs.indexOf(song), // Pass the current song index
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 16),
              ] else ...[
                // Initial UI with genres and categories
                Text(
                  "Your top genres",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildGenreCard("R&B", 'assets/category/freudian.jpg', Color(0xFF9854B2)),
                      _buildGenreCard("Hip-hop", 'assets/category/drake.png', Color(0xFF678026)),
                      _buildGenreCard("Pop", 'assets/category/1975.png', Color(0xFF3371E4)),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                // Popular Podcast Categories Section
                Text(
                  "Popular podcast categories",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildGenreCard("News & Politics", 'assets/category/politics.jpg', Color(0xFF8768A7)),
                      _buildGenreCard("Comedy", 'assets/category/comedy.jpg', Color(0xFFCF4321)),
                      _buildGenreCard("Games", 'assets/category/game.jpg', Color(0xFF3371E4)),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                // Browse all
                Text(
                  "Browse all",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                // Grid view section
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Wrap(
                        children: [
                          _buildGenreCard("2024 Wrapped", 'assets/category/wrapped.jpg', Color(0xFFABBB6D)),
                          _buildGenreCard("Podcasts", 'assets/category/podcast.jpg', Color(0xFF223160)),
                          _buildGenreCard("Charts", 'assets/category/charts.jpg', Color(0xFF8768A7)),
                          _buildGenreCard("Made for you", 'assets/category/made for you.jpg', Color(0xFF75A768)),
                        ],
                      ),
                    ],
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenreCard(String genre, String imagePath, Color color) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      elevation: 5,
      color: color,
      child: Container(
        width: 170, // Set consistent width
        height: 110, // Set consistent height
        padding: const EdgeInsets.only(top: 8.0, left: 8.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  genre,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              right: -15,
              child: Transform.rotate(
                angle: 0.5,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: Offset(-4, 4),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
