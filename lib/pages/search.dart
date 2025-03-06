import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
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
      body: SingleChildScrollView(
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

              // Search bar
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
                    Text(
                      "Artists, songs, or podcasts",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // Top Genres Section
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

                    ]
                  )
                ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenreCard(String genre, String imagePath, Color color) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4), // Card radius
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
