import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
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
              color: Colors.white, // Your desired color
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: SingleChildScrollView( // Make the body scrollable vertically
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, bottom: 15.0, right: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Center everything
            children: [
              // CircleAvatar with increased size
              Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/sandy.jpg'),
                  radius: 60,
                ),
              ),
              SizedBox(height: 30),

              // Centered "Edit Profile" button
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0x003e3f3f),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Horizontally scrollable stats
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Center stats horizontally
                  children: [
                    _buildStatsColumn('10', 'PLAYLISTS'),
                    SizedBox(width: 20),
                    _buildStatsColumn('58', 'FOLLOWERS'),
                    SizedBox(width: 20),
                    _buildStatsColumn('20', 'FOLLOWING'),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Playlist title and song details
              Row(
                children: [
                  Text(
                    "Playlist",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Liked Songs section
              _buildPlaylistCard('assets/liked.jpeg', 'Liked Songs'),
              SizedBox(height: 16),

              // Artist section (repeated)
              _buildArtistRow('Lana Del Rey', 'Artist'),
              _buildArtistRow('Lana Del Rey', 'Artist'),
              _buildArtistRow('Lana Del Rey', 'Artist'),
              _buildArtistRow('Lana Del Rey', 'Artist'),

              SizedBox(height: 16),

              // See all playlist button
              Row(
                children: [
                  Text(
                    "See all playlist",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build stats block
  Widget _buildStatsColumn(String value, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // Helper function to build a playlist card
  Widget _buildPlaylistCard(String imagePath, String title) {
    return Row(
      children: [
        Image.asset(
          imagePath,
          width: 67,
          height: 67,
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.push_pin,
                  color: Color(0xFFFF375F),
                  size: 12,
                ),
                SizedBox(width: 8),
                Text(
                  'Playlist - 58 songs',
                  style: TextStyle(
                    color: Color(0xFFB3B3B3),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Helper function to build artist row
  Widget _buildArtistRow(String artistName, String role) {
    return Row(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundImage: AssetImage('assets/sandy.jpg'),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              artistName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Text(
              role,
              style: TextStyle(
                color: Color(0xFFB3B3B3),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
