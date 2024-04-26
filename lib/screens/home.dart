import 'dart:convert';
import 'package:ecommerce_app/screens/create_screen.dart';
import 'package:ecommerce_app/screens/search.dart';
import 'package:ecommerce_app/screens/update_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../widgets/BottomNavigatorBar.dart';
import '../widgets/Sidebar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isHovered = false;
  bool _isDarkMode = false;

  List<dynamic> _products = []; // Updated to hold products
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadDarkModePreference();
    _fetchProducts();
  }

  Future<void> _loadDarkModePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  Future<void> _fetchProducts() async {
    var url = Uri.parse('http://10.0.2.2:8000/api/products');
    try {
      var response = await http.get(url);
      print("API response body: ${response.body}");
      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        if (decodedResponse['success'] == true &&
            decodedResponse.containsKey('data')) {
          setState(() {
            _products = decodedResponse['data'];
          });
        } else {
          print("Data key not found or success is false");
        }
      } else {
        print(
            "Error fetching products with status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleDarkMode(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', value);
    setState(() {
      _isDarkMode = value;
    });
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  Future<void> _deleteProduct(int productId) async {
    // Correctly use productId to construct the URL
    var url = Uri.parse(
        'http://10.0.2.2:8000/api/products/$productId'); // Adjust as necessary
    try {
      var response = await http.delete(url);
      if (response.statusCode == 200) {
        print("Product deleted successfully");
        _fetchProducts(); // Refresh the product list
      } else {
        print("Failed to delete product: ${response.statusCode}");
      }
    } catch (e) {
      print("Error deleting product: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    Color appBarColor =
        _isDarkMode ? const Color.fromRGBO(51, 54, 72, 1) : Colors.white;
    Color backgroundColor = _isDarkMode
        ? const Color.fromRGBO(51, 54, 72, 1)
        : const Color.fromRGBO(238, 241, 242, 1);
    Color productBackgroundColor =
        _isDarkMode ? const Color.fromRGBO(61, 65, 84, 1) : Colors.white;
    Color textColor = _isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("Home Page",
            style: GoogleFonts.ubuntu(
                color: textColor, fontWeight: FontWeight.bold)),
        backgroundColor: appBarColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: textColor),
          onPressed: _openDrawer,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: textColor),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchPage()));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Create your new product!',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CreatePage()));
                    },
                    child: Container(
                      height: 210,
                      decoration: BoxDecoration(
                        color: productBackgroundColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3))
                        ],
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset('assets/images/world.jpg',
                                height: 210, fit: BoxFit.cover),
                          ),
                          Center(
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              onEnter: (_) => setState(() => _isHovered = true),
                              onExit: (_) => setState(() => _isHovered = false),
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    color:
                                        _isHovered ? Colors.grey : Colors.white,
                                    shape: BoxShape.circle),
                                child: const Center(
                                    child: Icon(Icons.add,
                                        size: 40, color: Colors.pink)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Products',
                      style: GoogleFonts.ubuntu(
                          color: textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 490,
                    child: ListView.builder(
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        var product =
                            _products[index]; // Make sure this is not null
                        return Dismissible(
                          key: Key(product['id']
                              .toString()), // Ensure 'id' is valid and not null
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            _deleteProduct(
                                product['id']); // Use product['id'] directly
                          },
                          background: Container(
                            alignment: Alignment.centerRight,
                            color: Colors.red,
                            child: const Padding(
                              padding: EdgeInsets.only(right: 20.0),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                          child: Card(
                            color: productBackgroundColor,
                            child: ListTile(
                              title: Text(product['name'],
                                  style: TextStyle(color: textColor)),
                              subtitle: Text(product['description'],
                                  style: TextStyle(color: textColor)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: textColor),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const UpdatePage()),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: textColor),
                                    onPressed: () =>
                                        _deleteProduct(product['id']),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
          isDarkMode: _isDarkMode),
      drawer: Sidebar(isDarkMode: _isDarkMode, toggleDarkMode: _toggleDarkMode),
    );
  }
}
