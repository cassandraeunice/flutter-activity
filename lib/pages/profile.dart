import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_profile.dart';
import 'change_password.dart';

class ProfilePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection('users')
            .doc(_auth.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text(
                "Error loading data",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final userData = snapshot.data!;
          return SingleChildScrollView(
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
                    userData['name'] ?? 'User',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  // Center(
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(builder: (context) => EditProfilePage()),
                  //       );
                  //     },
                  //     child: Container(
                  //       decoration: BoxDecoration(
                  //         color: Color(0x003e3f3f),
                  //         borderRadius: BorderRadius.circular(30),
                  //         border: Border.all(
                  //           color: Colors.white,
                  //           width: 1,
                  //         ),
                  //       ),
                  //       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  //       child: Text(
                  //         'Edit Profile',
                  //         style: TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 12,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 16),

                  // Edit Profile section (added onTap here to navigate to EditProfilePage)
                  _buildSettingItem("Edit Profile", context, onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfilePage()),
                    );
                  }),

                  // Password section with arrow icon
                  _buildSettingItem("Change Password", context , onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                    );
                  }),

                  // Commented out playlist section
                  // SizedBox(height: 20),
                  // Playlist Section
                  // Row(
                  //   children: [
                  //     Text(
                  //       "6",
                  //       style: TextStyle(
                  //         color: Colors.grey,
                  //         fontSize: 18,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //     Text(
                  //       "Playlist",
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 18,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(height: 20),
                  // _buildPlaylistItem('assets/playlist/playlist1.jpg', 'Study Hub'),
                  // SizedBox(height: 16),
                  // _buildPlaylistItem('assets/playlist/playlist2.jpg', 'On Repeat'),
                  // SizedBox(height: 16),
                  // _buildPlaylistItem('assets/playlist/playlist3.png', 'Volume UPPP'),
                  // SizedBox(height: 16),
                  // _buildPlaylistItem('assets/playlist/playlist4.jpg', 'carpool!!'),
                  // SizedBox(height: 16),
                  // _buildPlaylistItem('assets/playlist/playlist5.jpg', 'focus time'),
                  // SizedBox(height: 16),
                  // _buildPlaylistItem('assets/playlist/playlist6.jpg', 'stuck in January'),
                  // SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Reusable widget for settings item (like password and edit profile)
  Widget _buildSettingItem(String title, BuildContext context, {VoidCallback? onTap}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.white,
        size: 16,
      ),
      onTap: onTap, // Pass the onTap callback
    );
  }

// Commented out playlist item widget
// Widget _buildPlaylistItem(String imagePath, String title) {
//   return Row(
//     children: [
//       Image.asset(
//         imagePath,
//         width: 67,
//         height: 67,
//       ),
//       SizedBox(width: 10),
//       Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//             ),
//           ),
//           Row(
//             children: [
//               Text(
//                 'Playlist',
//                 style: TextStyle(
//                   color: Color(0xFFB3B3B3),
//                   fontSize: 13,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       )
//     ],
//   );
// }
}
