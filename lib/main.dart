import 'pages/login.dart';
import 'package:flutter/material.dart';
import 'pages/search.dart';
import 'pages/library.dart';
import 'pages/profile.dart';
// import 'pages/settings.dart';
import 'pages/playlist.dart';
import 'pages/song.dart';
import 'pages/start_page.dart';
import 'pages/sign_up/sign_up1.dart';
import 'pages/sign_up/sign_up2.dart';
import 'pages/sign_up/sign_up3.dart';
import 'pages/sign_up/sign_up4.dart';
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
        '/playlist': (context) => AuthGuard(child: PlaylistPage()),
        '/song': (context) => AuthGuard(
          child: SongPage(
            title: '', // Provide default or placeholder values
            artist: '',
            image: '',
            file: '',
          ),
        ),
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
                      ListTile(
                        leading: Icon(
                          Icons.library_music,
                          color: Colors.white,
                          size: 30,
                        ),
                        title: Text(
                          'Playlist',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PlaylistPage()),
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.library_music,
                          color: Colors.white,
                          size: 30,
                        ),
                        title: Text(
                          'Song',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SongPage(
                              title: 'Sample Title', // Replace with actual data
                              artist: 'Sample Artist',
                              image: 'assets/sample.jpg',
                              file: 'assets/sample.mp3',
                            ),
                          ),
                        ),
                      ),
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
              Text(
                "Recently Played Songs",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildRecentlyCard('assets/album/chromakopia.jpg', "CHROMAKOPIA", "Tyler, The Creator"),
                    SizedBox(width: 2),
                    _buildRecentlyCard('assets/album/alligatorbites.jpg', "Alligator bites...", "Doechii"),
                    SizedBox(width: 2),
                    _buildRecentlyCard('assets/album/gnx.jpg', "GNX", "Kendrick Lamar"),
                    SizedBox(width: 2),
                    _buildRecentlyCard('assets/album/fleetwoodmac.jpg', "Rumors", "Fleetwood Max"),
                    SizedBox(width: 2),
                    _buildRecentlyCard('assets/album/realityclub.jpg', "Is It The Answer", "Reality Club"),
                    SizedBox(width: 2),
                  ],
                ),
              ),
              SizedBox(height: 16),
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
                        _buildPlaylistCard('assets/playlist/playlist1.jpg', "Study Hub"),
                        _buildPlaylistCard('assets/playlist/playlist2.jpg', "On Repeat"),
                        _buildPlaylistCard('assets/playlist/playlist3.png', "volume UPPP"),
                        _buildPlaylistCard('assets/playlist/playlist4.jpg', "carpool!!"),
                        _buildPlaylistCard('assets/playlist/playlist5.jpg', "focus time"),
                        _buildPlaylistCard('assets/playlist/playlist6.jpg', "stuck in January"),
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
              overflow: TextOverflow.ellipsis,
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
        height: 225,
        padding: const EdgeInsets.all(8.0),
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              imagePath,
              width: 155,
              height: 155,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 8),
            Text(
              albumName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
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
