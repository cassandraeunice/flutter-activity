import 'package:flutter/material.dart';
import 'pages/search.dart';
import 'pages/library.dart';

void main() {
  runApp(MoodyApp());
}

class MoodyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music App',
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
        title: Text(
          'Music App',
          style: TextStyle(color: Colors.white),
        ),
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
                      Text(
                        'View Profile',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.home_filled,
                color: Color(0xFFF94C57), // Change icon color here
              ),
              title: Text(
                'Home',
                style: TextStyle(color: Color(0xFFF94C57), fontSize: 13),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()), //change SearchPage() to HomePage() if ever
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
          ],
        ),
      ),
    );
  }
}
