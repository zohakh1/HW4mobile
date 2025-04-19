import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'home_screen.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(child: Text('Menu')),
          ListTile(
            title: Text('Message Boards'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen())),
          ),
          ListTile(
            title: Text('Profile'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen())),
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen())),
          ),
        ],
      ),
    );
  }
}
