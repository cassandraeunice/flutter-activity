import 'package:flutter/material.dart';

class LogMoodPage extends StatefulWidget {
  @override
  _LogMoodPageState createState() => _LogMoodPageState();
}

class _LogMoodPageState extends State<LogMoodPage> {
  String? selectedMood;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log Mood'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How are you feeling today?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: ['😀', '😐', '😢'].map((emoji) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedMood = emoji;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: selectedMood == emoji ? Colors.blue.withOpacity(0.3) : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          emoji,
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: ['😡', '😴'].map((emoji) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedMood = emoji;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: selectedMood == emoji ? Colors.blue.withOpacity(0.3) : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          emoji,
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(hintText: 'Add a note about your mood...'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                print('Saved Mood: $selectedMood');
              },
              child: Text('Save Mood'),
            ),
          ],
        ),
      ),
    );
  }
}
