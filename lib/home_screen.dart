import 'package:flutter/material.dart';
import 'room_items_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';


class HomeScreen extends StatefulWidget {
  final Box appBox;
  const HomeScreen({super.key, required this.appBox});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> rooms = [
    'Living Room',
    'Kitchen',
    'Master Bedroom',
    'Kids Room',
    'Home Office',
    'Storage',
  ];

  void _addRoomDialog() {
    String newRoom = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add a new room'),
        content: TextField(
          autofocus: true,
          onChanged: (value) => newRoom = value,
          decoration: const InputDecoration(hintText: 'Room name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (newRoom.trim().isNotEmpty) {
                setState(() {
                  rooms.add(newRoom.trim());
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          SizedBox.expand(
            child: Image.asset(
              'assets/images/login_background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Optional dim layer for readability
          Container(color: const Color.fromRGBO(0, 0, 0, 0.5)),

          // Content
          SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Select a Room',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: rooms.length,
                    itemBuilder: (context, index) => Card(
                      color: Colors.white70,
                      child: ListTile(
                        title: Text(rooms[index]),
                        onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RoomItemsScreen(roomName: rooms[index]),
                              ),
                            );
                          // בעתיד: מעבר לדף המוצרים של החדר
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ElevatedButton.icon(
                    onPressed: _addRoomDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Room'),
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
