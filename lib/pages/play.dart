import 'package:flutter/material.dart';

class PlayPage extends StatelessWidget {
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
              SizedBox(height: 15), // Space between image and text

              // Row for title and artist, with heart icon on the right side
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
                      SizedBox(height: 4), // Space between title and artist
                      Text(
                        'Troye Sivan',
                        style: TextStyle(
                          color: Colors.grey, // Grey color for the artist
                          fontSize: 16, // Smaller font size for the artist name
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.favorite_border, // Heart icon (you can change this to filled if you want)
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),

              // Add progress bar with timestamp
              SizedBox(height: 20), // Space before the progress bar
              Row(
                children: [
                  Text(
                    '0:45', // Current position timestamp (this would be dynamic in a real app)
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Expanded(
                    child: Slider(
                      value: 45.0, // This is the current position in seconds
                      min: 0,
                      max: 240, // Max time in seconds (4 minutes in this example)
                      onChanged: (value) {
                        // Implement progress tracking here
                      },
                      activeColor: Color(0xFFF94C57),
                      inactiveColor: Colors.grey,
                    ),
                  ),
                  Text(
                    '4:00', // Total duration of the song
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),

              // Music control buttons in the same row
              SizedBox(height: 20), // Space before buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.skip_previous,
                      color: Color(0xFFF94C57),
                      size: 40,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.pause_circle_filled,
                      color: Color(0xFFF94C57),
                      size: 70,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.skip_next,
                      color: Color(0xFFF94C57),
                      size: 40,
                    ),
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
