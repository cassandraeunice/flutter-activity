import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? _displayNameError;
  String? _emailError;

  // Playlist switch states
  Map<String, bool> _playlistSwitches = {};

  // Loading state
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializePlaylists();
    _populateUserData();
  }

  void _initializePlaylists() {
    List<String> playlistTitles = [
      'Study Hub',
      'On Repeat',
      'Volume UPPP',
      'carpool!!',
      'focus time',
      'stuck in January',
    ];

    for (var title in playlistTitles) {
      _playlistSwitches[title] = true;
    }
  }

  Future<void> _populateUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        setState(() {
          _displayNameController.text = userDoc['name'] ?? '';
          _emailController.text = user.email ?? '';
        });
      }
    } catch (e) {
      // Handle errors if needed
    }
  }

  void _validateInput(String field) {
    setState(() {
      switch (field) {
        case "Display Name":
          _displayNameError = _displayNameController.text.trim().isEmpty
              ? "Display Name is required."
              : null;
          break;
        case "Email":
          String email = _emailController.text.trim();
          _emailError = email.isEmpty
              ? "Email is required."
              : !RegExp(r"^[^@]+@[^@]+\.[^@]+$").hasMatch(email)
              ? "Enter a valid email format (e.g., user@example.com)."
              : null;
          break;
      }
    });
  }

  void _onSaveChangesPressed() async {
    _validateInput("Display Name");
    _validateInput("Email");

    if (_displayNameError == null && _emailError == null) {
      setState(() {
        isLoading = true;
      });

      try {
        User? currentUser = _auth.currentUser;

        final String newDisplayName = _displayNameController.text.trim();
        final String newEmail = _emailController.text.trim();
        final String currentEmail = currentUser?.email ?? '';

        DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser?.uid).get();
        final String currentDisplayName = userDoc['name'] ?? '';

        // Only proceed with email uniqueness check and verification if email changed
        if (newEmail != currentEmail) {
          QuerySnapshot emailQuery = await _firestore
              .collection('users')
              .where('email', isEqualTo: newEmail)
              .get();

          if (emailQuery.docs.isNotEmpty && emailQuery.docs.first.id != currentUser?.uid) {
            setState(() {
              _emailError = "Email is already in use.";
              isLoading = false;
            });
            return;
          }

          // Send verification email only if email changed
          await currentUser?.verifyBeforeUpdateEmail(newEmail);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification email sent. Please verify your new email.')),
          );
        }

        // Update only changed fields in Firestore
        Map<String, dynamic> updates = {};
        if (newDisplayName != currentDisplayName) updates['name'] = newDisplayName;
        if (newEmail != currentEmail) updates['email'] = newEmail;

        if (updates.isNotEmpty) {
          await _firestore.collection('users').doc(currentUser?.uid).update(updates);
        }

        setState(() {
          isLoading = false;
        });

        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
        );
      }
    }
  }


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
              _buildTextField("Display Name", _displayNameController, _displayNameError),
              SizedBox(height: 16),
              _buildTextField("Email", _emailController, _emailError),
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
                onPressed: isLoading ? null : _onSaveChangesPressed,
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
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

  Widget _buildTextField(String label, TextEditingController controller, String? errorText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.white70),
            filled: true,
            fillColor: Color(0xFF222222),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white70),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          onChanged: (value) => _validateInput(label),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 16),
                SizedBox(width: 5),
                Text(
                  errorText,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ],
            ),
          ),
      ],
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
            String title = playlist['title']!;
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
                        title,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  Switch(
                    value: _playlistSwitches[title] ?? true,
                    onChanged: (bool newValue) {
                      setState(() {
                        _playlistSwitches[title] = newValue;
                      });
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