import 'package:ecommerce_app/screens/home.dart';
import 'package:ecommerce_app/screens/profile.dart';
import 'package:ecommerce_app/screens/setting.dart';
import 'package:flutter/material.dart';

final Color bottomNavBgColor = Color(0xFF17203A);

class CustomBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final bool isDarkMode;

  CustomBottomNavigationBar({
    required this.selectedIndex,
    required this.onItemTapped,
    required this.isDarkMode,
  });

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: bottomNavBgColor.withOpacity(0.8),
        borderRadius: BorderRadius.all(Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: bottomNavBgColor.withOpacity(0.3),
            offset: Offset(0, 20),
            blurRadius: 20,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.home,
                color: widget.selectedIndex == 0
                    ? Colors.white
                    : widget.isDarkMode
                        ? Colors.grey
                        : Colors.black),
            onPressed: () {
              widget.onItemTapped(0);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HomePage()), // Replace SettingsScreen with your actual settings screen
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings,
                color: widget.selectedIndex == 1
                    ? Colors.white
                    : widget.isDarkMode
                        ? Colors.grey
                        : Colors.black),
            onPressed: () {
              widget.onItemTapped(1);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SettingPage()), // Replace SettingsScreen with your actual settings screen
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle,
                color: widget.selectedIndex == 2
                    ? Colors.white
                    : widget.isDarkMode
                        ? Colors.grey
                        : Colors.black),
            onPressed: () {
              widget.onItemTapped(2);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ProfilePage()), // Replace SettingsScreen with your actual settings screen
              );
            },
          ),
        ],
      ),
    );
  }
}
