import 'package:flutter/material.dart';

class RoomItemsScreen extends StatelessWidget {
  final String roomName;

  const RoomItemsScreen({super.key, required this.roomName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // רקע עם תמונה
          SizedBox.expand(
            child: Image.asset(
              'assets/images/login_background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // שכבת כהות לשיפור קריאות
          Container(color: const Color.fromRGBO(0, 0, 0, 0.5)),

          // תוכן
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    roomName,
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'No items yet',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
