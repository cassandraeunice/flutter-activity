import 'package:flutter/material.dart';

class MiniPlayer extends StatelessWidget {
  final String title;
  final String image;
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onTap;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const MiniPlayer({
    required this.title,
    required this.image,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onTap,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E), // Dark background
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(image, width: 50, height: 50, fit: BoxFit.cover),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white, // White text
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.skip_previous,
              color: Color(0xFFF94C57), // Accent color
            ),
            onPressed: onPrevious,
          ),
          IconButton(
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: Color(0xFFF94C57), // Accent color
            ),
            onPressed: onPlayPause,
          ),
          IconButton(
            icon: Icon(
              Icons.skip_next,
              color: Color(0xFFF94C57), // Accent color
            ),
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}