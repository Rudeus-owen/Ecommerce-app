import 'package:flutter/material.dart';

class Sidebar extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) toggleDarkMode;

  const Sidebar({
    Key? key,
    required this.isDarkMode,
    required this.toggleDarkMode,
  }) : super(key: key);

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  void _toggleDarkMode(bool value) {
    widget.toggleDarkMode(value);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color.fromARGB(255, 22, 25, 42), // Deep blue color
        child: Column(
          children: [
            DrawerHeader(
              child: Text(
                'User Info',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white),
              title: const Text(
                'Home',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Navigate to home or perform any action
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: const Text(
                'User',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Navigate to user profile or perform any action
              },
            ),
            ListTile(
              leading: Icon(
                Icons.dark_mode,
                color: widget.isDarkMode ? Colors.white : Colors.white70,
              ),
              title: Text(
                'Dark Mode',
                style: TextStyle(
                  color: widget.isDarkMode ? Colors.white : Colors.white70,
                ),
              ),
              onTap: () {
                _toggleDarkMode(true);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.light_mode,
                color: widget.isDarkMode ? Colors.white70 : Colors.white,
              ),
              title: Text(
                'Light Mode',
                style: TextStyle(
                  color: widget.isDarkMode ? Colors.white70 : Colors.white,
                ),
              ),
              onTap: () {
                _toggleDarkMode(false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
