import 'package:flutter/material.dart';
import 'add_song.dart'; // Ensure this file has AddSong defined

class SongPage extends StatefulWidget {
  @override
  _SongPageState createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Color(0xFF121212),
        elevation: 0,
        title: SizedBox.shrink(),
        leading: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 350,
                  height: 350,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/album/oasis.jpg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 15),

              // Title, artist, and heart icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Strawberries & Cigarettes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Troye Sivan',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      // Open AddSong as a Dialog with the specific size 300x350
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Container(
                            height: 350,  // Set height to 350
                            width: 300,   // Set width to 300
                            child: AddSong(), // Show the AddSong widget inside the dialog
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),

              SizedBox(height: 20),
              Row(
                children: [
                  Text('0:45', style: TextStyle(color: Colors.white, fontSize: 12)),
                  Expanded(
                    child: Slider(
                      value: 45.0,
                      min: 0,
                      max: 240,
                      onChanged: (value) {},
                      activeColor: Color(0xFFF94C57),
                      inactiveColor: Colors.grey,
                    ),
                  ),
                  Text('4:00', style: TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),

              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.skip_previous, color: Color(0xFFF94C57), size: 40),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.pause_circle_filled, color: Color(0xFFF94C57), size: 70),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_next, color: Color(0xFFF94C57), size: 40),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
