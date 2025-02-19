import 'package:flutter/material.dart';
import 'pages/search.dart';
import 'pages/library.dart';
import 'pages/profile.dart';
import 'pages/album.dart';
import 'pages/settings.dart';


void main() {
  runApp(MoodyApp());
}

class MoodyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Moody',
      theme: ThemeData(
        primaryColor: Color(0xFF121212),
        scaffoldBackgroundColor: Color(0xFF121212),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF121212),
          elevation: 0,
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        backgroundColor: Color(0xFF202223),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF202223)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/sandy.jpg'),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Cassandra',
                        style: TextStyle(color: Color(0xFFF94C57), fontSize: 15),
                      ),
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilePage()),
                        ),
                        child: Text(
                          'View Profile',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.home_filled,
                color: Color(0xFFF94C57),
              ),
              title: Text(
                'Home',
                style: TextStyle(color: Color(0xFFF94C57), fontSize: 13),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.library_music,
                color: Color(0xFFF94C57),
              ),
              title: Text(
                'Your Library',
                style: TextStyle(color: Color(0xFFF94C57), fontSize: 13),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LibraryPage()),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.search,
                color: Color(0xFFF94C57),
              ),
              title: Text(
                'Search',
                style: TextStyle(color: Color(0xFFF94C57), fontSize: 13),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.album,
                color: Color(0xFFF94C57),
              ),
              title: Text(
                'Album',
                style: TextStyle(color: Color(0xFFF94C57), fontSize: 13),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AlbumPage()),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Color(0xFFF94C57),
              ),
              title: Text(
                'Settings',
                style: TextStyle(color: Color(0xFFF94C57), fontSize: 13),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              ),
            ),
          ],
        ),
      ),

      // Home PAge
      body: SingleChildScrollView( // Wrap the entire body in a SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, bottom: 15.0, right: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Recently Played",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildRecentlyCard('assets/chromakopia.jpg', "CHROMAKOPIA", "Tyler, The Creator"),
                    SizedBox(width: 2),
                    _buildRecentlyCard('assets/alligatorbites.jpg', "Alligator bites...", "Doechii"),
                    SizedBox(width: 2),
                    _buildRecentlyCard('assets/gnx.jpg', "GNX", "Kendrick Lamar"),
                    SizedBox(width: 2),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Made for You",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.vertical, // Vertical scrolling
                child: Column(
                  children: [
                    Wrap(
                      spacing: 2, // Horizontal space between the items
                      runSpacing: 2, // Vertical space between the rows
                      children: [
                        _buildPlaylistCard('assets/playlist1.jpg', "Study Hub"),
                        _buildPlaylistCard('assets/playlist2.jpg', "On Repeat"),
                        _buildPlaylistCard('assets/playlist3.png', "volume UPPP"),
                        _buildPlaylistCard('assets/playlist4.jpg', "carpool!!"),
                        _buildPlaylistCard('assets/playlist5.jpg', "focus time"),
                        _buildPlaylistCard('assets/playlist6.jpg', "stuck in January"),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Add the _buildGenreCard method here
  Widget _buildPlaylistCard(String imagePath, String playlistName) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
      ),
      elevation: 5,
      child: Container(
        width: 170,
        height: 220,
        padding: const EdgeInsets.all(10.0),
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset(
              imagePath,
              width: 155,
              height: 155,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 8),
            Text(
              playlistName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis, // Handles overflow
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentlyCard(String imagePath, String albumName, String artistName) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      elevation: 5,
      child: Container(
        width: 175,
        height: 225, // Increased height to accommodate text
        padding: const EdgeInsets.all(8.0),
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Album Image
            Image.asset(
              imagePath,
              width: 155,
              height: 155,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 8),
            // Album Name
            Text(
              albumName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Artist Name
            Text(
              artistName,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
