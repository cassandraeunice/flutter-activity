import 'package:flutter/material.dart';
import 'create_playlist.dart'; // Ensure this import points to your CreatePlaylist file

class LibraryPage extends StatelessWidget {
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.add, // The plus icon
              color: Color(0xFFA7A7A7),
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreatePlaylist()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, bottom: 15.0, right: 15.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Your Library",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryChip('Playlists'),
                  SizedBox(width: 10),
                  _buildCategoryChip('Artists'),
                  SizedBox(width: 10),
                  _buildCategoryChip('Albums'),
                  SizedBox(width: 10),
                  _buildCategoryChip('Podcasts & Shows'),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(
                  Icons.music_note,
                  color: Colors.white,
                  size: 12,
                ),
                Text(
                  "Recently Played",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildRecentlyPlayedItem('Liked Songs', 'Playlist - 58 songs', 'assets/playlist/liked.jpeg'),
            SizedBox(height: 16),
            _buildRecentlyPlayedItem('On Repeat', 'Playlist', 'assets/playlist/playlist2.jpg'),
            SizedBox(height: 16),
            _buildArtistItem('Kendrick Lamar', 'Artist', 'assets/album/gnx.jpg'),
            SizedBox(height: 16),
            _buildArtistItem('Doechiii', 'Artist', 'assets/album/alligatorbites.jpg'),
            SizedBox(height: 16),
            _buildArtistItem('Tyler, The Creator', 'Artist', 'assets/album/chromakopia.jpg'),
            SizedBox(height: 16),
            _buildAlbumItem('Charm', 'Album', 'assets/album/clairo.jpg'),
            SizedBox(height: 16),
            _buildAlbumItem('Rumors (Super Deluxe)', 'Album', 'assets/album/fleetwoodmac.jpg'),
            SizedBox(height: 16),
            _buildArtistItem('Oasis', 'Artist', 'assets/album/oasis.jpg'),
            SizedBox(height: 16),
            _buildArtistItem('Reality Club', 'Artist', 'assets/album/realityclub.jpg'),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF121212),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildRecentlyPlayedItem(String title, String subtitle, String imagePath) {
    return Row(
      children: [
        Image.asset(
          imagePath,
          width: 67,
          height: 67,
        ),
        SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Text(
              subtitle,
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

  Widget _buildArtistItem(String name, String subtitle, String imagePath) {
    return Row(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundImage: AssetImage(imagePath),
        ),
        SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Text(
              subtitle,
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

  Widget _buildAlbumItem(String title, String subtitle, String imagePath) {
    return Row(
      children: [
        Image.asset(
          imagePath,
          width: 67,
          height: 67,
        ),
        SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: Color(0xFFB3B3B3),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
