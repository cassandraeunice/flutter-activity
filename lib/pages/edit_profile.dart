import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Color(0xFF121212),
        elevation: 0,
        title: Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/sandy.jpg'),
                      radius: 60,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.camera_alt, color: Colors.black),
                          onPressed: () {
                            // Add image upload functionality
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              _buildTextField("Display Name", "Cassandra Cortez"),
              SizedBox(height: 16),
              _buildTextField("Username", "cassie123"),
              SizedBox(height: 16),
              _buildTextField("Email", "cassie@example.com"),
              SizedBox(height: 16),
              _buildPlaylistSection(),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                ),
                onPressed: () {
                  // Save profile changes
                },
                child: Text(
                  "Save Changes",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String initialValue, {int maxLines = 1}) {
    return TextField(
      style: TextStyle(color: Colors.white),
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white70),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildPlaylistSection() {
    List<Map<String, String>> playlists = [
      {'image': 'assets/playlist/playlist1.jpg', 'title': 'Study Hub'},
      {'image': 'assets/playlist/playlist2.jpg', 'title': 'On Repeat'},
      {'image': 'assets/playlist/playlist3.png', 'title': 'Volume UPPP'},
      {'image': 'assets/playlist/playlist4.jpg', 'title': 'carpool!!'},
      {'image': 'assets/playlist/playlist5.jpg', 'title': 'focus time'},
      {'image': 'assets/playlist/playlist6.jpg', 'title': 'stuck in January'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Public Playlists",
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Column(
          children: playlists.map((playlist) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        playlist['image']!,
                        width: 50,
                        height: 50,
                      ),
                      SizedBox(width: 10),
                      Text(
                        playlist['title']!,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  Switch(
                    value: true,
                    onChanged: (bool newValue) {
                      // Handle switch toggle functionality
                    },
                    activeColor: Colors.green,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
