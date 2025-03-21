import 'package:flutter/material.dart';

class LibraryPage extends StatelessWidget {
  final List<Map<String, dynamic>> libraryItems = [
    {
      'title': 'Liked Songs',
      'subtitle': 'Playlist - 58 songs',
      'image': 'assets/playlist/liked.jpeg',
      'isCircle': false,
    },
    {
      'title': 'On Repeat',
      'subtitle': 'Playlist',
      'image': 'assets/playlist/playlist2.jpg',
      'isCircle': false,
    },
    {
      'title': 'Kendrick Lamar',
      'subtitle': 'Artist',
      'image': 'assets/album/gnx.jpg',
      'isCircle': true,
    },
    {
      'title': 'Doechiii',
      'subtitle': 'Artist',
      'image': 'assets/album/alligatorbites.jpg',
      'isCircle': true,
    },
    {
      'title': 'Tyler, The Creator',
      'subtitle': 'Artist',
      'image': 'assets/album/chromakopia.jpg',
      'isCircle': true,
    },
    {
      'title': 'Charm',
      'subtitle': 'Album',
      'image': 'assets/album/clairo.jpg',
      'isCircle': false,
    },
    {
      'title': 'Rumors (Super Deluxe)',
      'subtitle': 'Album',
      'image': 'assets/album/fleetwoodmac.jpg',
      'isCircle': false,
    },
    {
      'title': 'Oasis',
      'subtitle': 'Artist',
      'image': 'assets/album/oasis.jpg',
      'isCircle': true,
    },
  ];

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
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
                Icon(Icons.add, color: Color(0xFFA7A7A7), size: 30),
              ],
            ),
            SizedBox(height: 16),

            // Horizontal category filters
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['Playlists', 'Artists', 'Albums', 'Podcasts & Shows']
                    .map((category) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF121212),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    padding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      category,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ))
                    .toList(),
              ),
            ),
            SizedBox(height: 20),

            // Recently Played section
            Row(
              children: [
                Icon(Icons.music_note, color: Colors.white, size: 12),
                SizedBox(width: 5),
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

            // List of library items
            Expanded(
              child: ListView.builder(
                itemCount: libraryItems.length,
                itemBuilder: (context, index) {
                  return LibraryItem(
                    title: libraryItems[index]['title'],
                    subtitle: libraryItems[index]['subtitle'],
                    imagePath: libraryItems[index]['image'],
                    isCircle: libraryItems[index]['isCircle'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LibraryItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final bool isCircle;

  const LibraryItem({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.isCircle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          isCircle
              ? CircleAvatar(radius: 35, backgroundImage: AssetImage(imagePath))
              : Image.asset(imagePath, width: 67, height: 67),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                subtitle,
                style: TextStyle(color: Color(0xFFB3B3B3), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
