import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/BottomNavigatorBar.dart';
import '../widgets/Sidebar.dart';
import 'search.dart';

class SettingPage extends StatefulWidget {
   const SettingPage ({Key? key}) : super(key: key);

   @override
  State<SettingPage> createState() => _SettingPageState();
}


class _SettingPageState extends State<SettingPage> {
  int _selectedIndex = 1;
  bool _isDarkMode = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadDarkModePreference();
  }

  Future<void> _loadDarkModePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('darkMode') ?? false; // Retrieve dark mode preference
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleDarkMode(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', value); // Store dark mode preference
    setState(() {
      _isDarkMode = value;
    });
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    Color appBarColor = _isDarkMode ? const Color.fromRGBO(46, 40, 77, 1) : Colors.white;
    Color backgroundColor = _isDarkMode ? const Color.fromRGBO(46, 40, 77, 1) : const Color.fromRGBO(238, 241, 242, 1);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          "Profile Page",
          style: TextStyle(
            color: _isDarkMode ? const Color.fromRGBO(229, 186, 142, 1) : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: appBarColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: _isDarkMode ? const Color.fromRGBO(229, 186, 142, 1) : Colors.black),
          onPressed: _openDrawer,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: _isDarkMode ? const Color.fromRGBO(229, 186, 142, 1) : Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        isDarkMode: _isDarkMode,
      ),
      drawer: Sidebar(
        isDarkMode: _isDarkMode,
        toggleDarkMode: _toggleDarkMode,
      ),
    );
  }
}