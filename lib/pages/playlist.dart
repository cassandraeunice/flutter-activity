import 'package:flutter/material.dart';

class PlaylistPage extends StatelessWidget {
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
                      image: AssetImage('assets/album/clairo.jpg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 8), // Space between image and text

              // Study Hub, Cassandra, and Avatar in a single row
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Study Hub',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 33,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 20), // Space between 'Study Hub' and the avatar

                  CircleAvatar(
                    radius: 10,
                    backgroundImage: AssetImage('assets/sandy.jpg'),
                  ),
                  SizedBox(width: 15), // Space between avatar and 'Cassandra' text

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cassandra',
                        style: TextStyle(
                          color: Color(0xFFF94C57),
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 4),
                    ],
                  ),
                ],
              ),

              // Header section for #, Title, Artist
              SizedBox(height: 20), // Space before header section
              Row(
                children: [
                  // Adding spaces between each header element
                  Text(
                    '#',
                    style: TextStyle(
                      color: Color(0xFFB3B3B3), // Grey color for header text
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 15), // Space between header elements
                  Expanded( // This will help adjust space for the Title
                    child: Text(
                      'Title',
                      style: TextStyle(
                        color: Color(0xFFB3B3B3),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 15), // Space between header elements
                  Expanded( // This will help adjust space for the Artist
                    child: Text(
                      'Artist',
                      style: TextStyle(
                        color: Color(0xFFB3B3B3),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10), // Space below the header

              // Content for songs
              _buildSongRow('1', 'Strawberries & Cigarettes', 'Troye Sivan'),
              SizedBox(height: 16), // Space between rows

              _buildSongRow('2', 'Strawberries & Cigarettes', 'Troye Sivan'),
              SizedBox(height: 16),

              _buildSongRow('3', 'Strawberries & Cigarettes', 'Troye Sivan'),
              SizedBox(height: 16),

              _buildSongRow('4', 'Strawberries & Cigarettes', 'Troye Sivan'),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build the song row
  Widget _buildSongRow(String number, String title, String artist) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Song number
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              number,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
        SizedBox(width: 20), // Space between number and title
        // Song title
        Expanded( // Allows the title to take up remaining space
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 40), // Space between title and artist
        // Song artist
        Expanded( // Allows the artist to take up remaining space
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
        SizedBox(width: 20), // Space between artist and button
        // Pause button at the end
        IconButton(
          icon: Icon(
            Icons.pause_circle_filled,
            color: Color(0xFFF94C57),
            size: 40,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
