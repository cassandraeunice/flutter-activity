import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_profile.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _userName = "Loading...";

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        setState(() {
          _userName = userDoc['name'] ?? "User";
        });
      }
    } catch (e) {
      setState(() {
        _userName = "User";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Color(0xFF121212),
        elevation: 0,
        title: SizedBox.shrink(),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/sandy.jpg'),
                  radius: 60,
                ),
              ),
              SizedBox(height: 10),
              Text(
                _userName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfilePage()),
                    );
                  },
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
              ),
              SizedBox(height: 16),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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

              // _buildPlaylistItem('assets/liked.jpeg', 'Liked Songs'),
              // SizedBox(height: 16),

              // Playlist Rows
              _buildPlaylistItem('assets/playlist/playlist1.jpg', 'Study Hub'),
              SizedBox(height: 16),
              _buildPlaylistItem('assets/playlist/playlist2.jpg', 'On Repeat'),
              SizedBox(height: 16),
              _buildPlaylistItem('assets/playlist/playlist3.png', 'Volume UPPP'),
              SizedBox(height: 16),
              _buildPlaylistItem('assets/playlist/playlist4.jpg', 'carpool!!'),
              SizedBox(height: 16),
              _buildPlaylistItem('assets/playlist/playlist5.jpg', 'focus time'),
              SizedBox(height: 16),
              _buildPlaylistItem('assets/playlist/playlist6.jpg', 'stuck in January'),
              SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    "See all playlist",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
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

  Widget _buildStatsColumn(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaylistItem(String imagePath, String title) {
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
            Row(
              children: [
                Text(
                  'Playlist',
                  style: TextStyle(
                    color: Color(0xFFB3B3B3),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget _buildPlaylistCard(String imagePath, String title) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Color(0xFF1F1F1F),
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
        leading: Image.asset(imagePath, width: 50, height: 50),
        title: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
