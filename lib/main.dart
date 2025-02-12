import 'package:flutter/material.dart';
import 'pages/log_mood.dart';
import 'pages/journal.dart';
import 'pages/mood_statistics.dart';
import 'pages/settings.dart';

void main() {
  runApp(MoodTrackerApp());
}

class MoodTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mood Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mood Tracker')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/sandy.jpg'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Sandy',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.mood),
              title: Text('Log Mood'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LogMoodPage()),
              ),
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Journal'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => JournalPage()),
              ),
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('Mood Statistics'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MoodStatisticsPage()),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Mood Tracker!',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.yellow[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text('Today\'s Mood: 😊', style: TextStyle(fontSize: 20)),
                  SizedBox(height: 12),
                ],
              ),
            ),
            SizedBox(height: 24),
            Text('Quick Actions:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.mood),
                  label: Text('Log Mood'),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LogMoodPage()),
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.book),
                  label: Text('Journal'),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => JournalPage()),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Text('Recent Journal Entries:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: Icon(Icons.note),
                title: Text('Had a great day!'),
                subtitle: Text('Felt really productive today and accomplished a lot.'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JournalPage()),
                ),
              ),
            ),
            SizedBox(height: 24),
            Text('Mood Trends:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Text('Mood graph placeholder', style: TextStyle(fontSize: 16))),
            ),
          ],
        ),
      ),
    );
  }
}
