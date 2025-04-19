import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'drawer_menu.dart';

class HomeScreen extends StatelessWidget {
  final boards = [
    {'name': 'Tech Talk', 'icon': Icons.computer},
    {'name': 'Wellness', 'icon': Icons.spa},
    {'name': 'Gaming', 'icon': Icons.videogame_asset},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Message Boards")),
      drawer: DrawerMenu(),
      body: ListView.builder(
        itemCount: boards.length,
        itemBuilder: (context, index) {
          final board = boards[index];
          return ListTile(
            leading: Icon(board['icon'] as IconData),
            title: Text(board['name'] as String),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ChatScreen(boardName: board['name'] as String)),
              );
            },
          );
        },
      ),
    );
  }
}
