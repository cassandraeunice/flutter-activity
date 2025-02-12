import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  bool darkMode = false;
  double fontSize = 16.0;
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            SwitchListTile(
              title: Text('Enable Notifications'),
              value: notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Dark Mode'),
              value: darkMode,
              onChanged: (bool value) {
                setState(() {
                  darkMode = value;
                });
              },
            ),
            ListTile(
              title: Text('Font Size: ${fontSize.toInt()}'),
              subtitle: Slider(
                value: fontSize,
                min: 12.0,
                max: 24.0,
                onChanged: (double value) {
                  setState(() {
                    fontSize = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Language'),
              subtitle: DropdownButton<String>(
                value: selectedLanguage,
                items: ['English', 'Spanish', 'French', 'German'].map((String language) {
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Text(language),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedLanguage = newValue!;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Placeholder for backup functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Data backed up successfully!')),
                );
              },
              child: Text('Backup Data'),
            ),
          ],
        ),
      ),
    );
  }
}
