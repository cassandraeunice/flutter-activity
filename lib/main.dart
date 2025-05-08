import 'pages/login.dart';
import 'package:flutter/material.dart';
import 'pages/search.dart';
import 'pages/library.dart';
import 'pages/profile.dart';
import 'pages/playlist.dart';
import 'pages/song.dart';
import 'pages/sign_up/sign_up1.dart';
import 'pages/forgot_password/forgot_password1.dart';
import 'pages/edit_profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'guards/auth_guard.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      initialRoute: '/',
      routes: {
        '/': (context) => AuthGuard(child: HomePage()),
        '/signup1': (context) => SignUpPage1(),
        '/login': (context) => LoginPage(),
        '/homepage': (context) => AuthGuard(child: HomePage()),
        '/forgotpassword1': (context) => ForgotPasswordPage1(),
        '/editprofile': (context) => AuthGuard(child: EditProfilePage()),
        // '/settings': (context) => AuthGuard(child: SettingsPage()),
        '/profile': (context) => AuthGuard(child: ProfilePage()),
        // '/playlist': (context) => AuthGuard(
        //   child: PlaylistPage(
        //     playlistName: 'Default Playlist', // Provide a default name
        //     playlistImage: 'assets/default_song_cover.png', // Provide a default image
        //   ),
        // ),
        // '/song': (context) => AuthGuard(
        //   child: SongPage(
        //     title: '', // Provide default or placeholder values
        //     artist: '',
        //     image: '',
        //     file: '',
        //     songs: [], // Provide an empty list or a default list of songs
        //     currentIndex: 0, // Provide a default index
        //   ),
        //),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
  }

  Future<void> _checkEmailVerification() async {
    User? user = _auth.currentUser;

    if (user != null && user.emailVerified) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        String storedEmail = userDoc['email'] ?? '';

        if (user.email != storedEmail) {
          await _auth.signOut();
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: StreamBuilder<DocumentSnapshot>(
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
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage('assets/defaultpic.jpg'),
                        ),
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              userData['name'] ?? 'User',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePage()),
                              ),
                              child: Text(
                                'View Profile',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.home_filled,
                          color: Colors.white,
                          size: 30,
                        ),
                        title: Text(
                          'Home',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.library_music,
                          color: Colors.white,
                          size: 30,
                        ),
                        title: Text(
                          'Your Library',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LibraryPage()),
                        ),
                      ),
                      // ListTile(
                      //   leading: Icon(
                      //     Icons.library_music,
                      //     color: Colors.white,
                      //     size: 30,
                      //   ),
                      //   title: Text(
                      //     'Playlist',
                      //     style: TextStyle(color: Colors.white, fontSize: 18),
                      //   ),
                      //   onTap: () => Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => PlaylistPage(
                      //         playlistName: 'Sample Playlist', // Replace with actual data
                      //         playlistImage: 'assets/default_song_cover.png', // Replace with actual data
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // ListTile(
                      //   leading: Icon(
                      //     Icons.library_music,
                      //     color: Colors.white,
                      //     size: 30,
                      //   ),
                      //   title: Text(
                      //     'Song',
                      //     style: TextStyle(color: Colors.white, fontSize: 18),
                      //   ),
                      //   onTap: () => Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => SongPage(
                      //         title: 'Sample Title', // Replace with actual data
                      //         artist: 'Sample Artist',
                      //         image: 'assets/sample.jpg',
                      //         file: 'assets/sample.mp3',
                      //         songs: [], // Provide an empty list or the actual list of songs
                      //         currentIndex: 0, // Provide the appropriate index
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      ListTile(
                        leading: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 30,
                        ),
                        title: Text(
                          'Search',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SearchPage()),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 30,
                    ),
                    title: Text(
                      'Logout',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    onTap: () async {
                      try {
                        await FirebaseAuth.instance.signOut();
                        // Navigate to the login page after logout
                        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error logging out: $e')),
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, bottom: 15.0, right: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Home",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Newly Added Section for Recently Played Playlists
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('playlists')
                    .where('lastPlayed', isGreaterThan: null)
                    .orderBy('lastPlayed', descending: true)
                    .limit(5)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return SizedBox.shrink();
                  }
                  final playlists = snapshot.data!.docs;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Playlists',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      SingleChildScrollView( // Make the list scrollable horizontally
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: playlists.map((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            final playlistName = data['name'] as String? ?? 'Unnamed Playlist';
                            final imagePath = data['imagePath'] as String? ?? 'assets/defaultpic.jpg';
                            final playlistId = doc.id;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: _buildRecentlyPlayedPlaylistCard(imagePath, playlistName, playlistId),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 16), // Add some space after the section
                    ],
                  );
                },
              ),
              Text(
                "Made for You",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Wrap(
                      spacing: 2,
                      runSpacing: 2,
                      children: [
                        _buildPlaylistCard('assets/playlist/playlist1.jpg', "Top 50 Philippines", [57, 58, 59, 60, 61]),
                        _buildPlaylistCard('assets/playlist/playlist2.jpg', "Top 50 Global", [54, 55, 56, 11, 23]),
                        _buildPlaylistCard('assets/playlist/playlist5.png', "Rap Caviar", [63, 62, 11, 64, 8]),
                        _buildPlaylistCard('assets/playlist/playlist4.jpg', "Today Top Hits", [22, 43, 23, 11, 12]),
                        _buildPlaylistCard('assets/playlist/playlist3.jpg', "Discover Weekly", [23, 44, 33, 11, 6]),
                        _buildPlaylistCard('assets/playlist/playlist6.jpg', "All Out 2010s", [1, 56, 21, 33, 53]),
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

  Widget _buildPlaylistCard(String imagePath, String playlistName, List<int> songIds) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaylistPage(
              playlistName: playlistName,
              playlistImage: imagePath,
              songIds: songIds, // Pass the song IDs
            ),
          ),
        );
      },
      child: Card(
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
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentlyPlayedPlaylistCard(String imagePath, String playlistName, String playlistId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaylistPage(
              playlistName: playlistName,
              playlistImage: imagePath,
            ),
          ),
        );
      },
      child: Card(
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
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  imagePath,
                  width: 155,
                  height: 155,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/defaultpic.jpg',
                      width: 155,
                      height: 155,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              SizedBox(height: 8),
              Text(
                playlistName,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
