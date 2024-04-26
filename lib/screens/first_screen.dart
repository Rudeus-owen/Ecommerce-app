import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'home.dart'; // Ensure this import path is correct for your Home page

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  bool _loginFieldsVisible = false;
  bool _signupFieldsVisible = false;
 final TextEditingController  _emailController = TextEditingController();
 final TextEditingController _passwordController = TextEditingController();
 final TextEditingController _usernameController = TextEditingController();
 final TextEditingController _roleController = TextEditingController();
 final TextEditingController _expirationDurationController = TextEditingController();
 final TextEditingController _expirationUnitController = TextEditingController();

  
   final String _baseURL = 'http://10.0.2.2:8000/api' ; // for androidstudio
    // final String _baseURL = 'http://192.168.56.1:8000/api';//for device
 Future<void> _signup() async {
  final url = Uri.parse('$_baseURL/signup');
  var payload = {
    'username': _usernameController.text,
    'email': _emailController.text,
    'password': _passwordController.text,
    if (_roleController.text.isNotEmpty)
      'role': _roleController.text,
    if (_expirationDurationController.text.isNotEmpty)
      'expiration_duration': int.tryParse(_expirationDurationController.text),
    if (_expirationUnitController.text.isNotEmpty)
      'expiration_unit': _expirationUnitController.text,
  };

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    ).timeout(Duration(seconds: 30));

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.headers['content-type']?.contains('application/json') ?? false) {
      final responseData = json.decode(response.body);
      if (response.statusCode == 201) {
        _handleSuccess(context);
      } else {
        _handleError(context, responseData['message'] ?? 'Unknown error occurred during signup.');
      }
    } else {
      _handleError(context, 'Received non-JSON response from the server');
    }
  } catch (error) {
    _handleError(context, 'An error occurred while signing up: $error');
  }
}

Future<void> _signin() async {
  final url = Uri.parse('$_baseURL/signin');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    ).timeout(Duration(seconds: 30));  // Adjust the timeout as necessary

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.headers['content-type']?.contains('application/json') ?? false) {
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
      } else {
        _handleError(context, responseData['message'] ?? 'Unknown error occurred during signin.');
      }
    } else {
      _handleError(context, 'Received non-JSON response from the server');
    }
  } catch (error) {
    _handleError(context, 'An error occurred while signing in: $error');
  }
 }


  void _handleSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: Text('Success'),
        content: Text('Your account has been created successfully.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                _loginFieldsVisible = true;
                _signupFieldsVisible = false;
              });
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("./assets/images/planets.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(child: Center()),
            _buildLoginSignupUI(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginSignupUI() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                _loginFieldsVisible = !_loginFieldsVisible;
                _signupFieldsVisible = false;
              });
            },
            child: Icon(
              _loginFieldsVisible ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
              color: Colors.white,
            ),
          ),
          _buildVisibilityBasedUI(),
        ],
      ),
    );
  }

  Widget _buildVisibilityBasedUI() {
    if (_loginFieldsVisible) {
      return Column(
        children: [
          _buildTextField(hint: 'Email', icon: Icons.email, controller: _emailController),
          SizedBox(height: 15),
          _buildTextField(
            hint: 'Password', icon: Icons.lock_outline, obscureText: true, controller: _passwordController),
          SizedBox(height: 20),
          _buildButton(context, title: 'Sign in', onPressed: _signin),
          SizedBox(height: 10),
          TextButton(
            onPressed: () {
              setState(() {
                _loginFieldsVisible = false;
                _signupFieldsVisible = true;
              });
            },
            child: Text('Sign up instead', style: GoogleFonts.ubuntu(color: Colors.white70, fontSize: 15)),
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () {}, // Implement guest login functionality
            child: Text('Continue as Guest', style: GoogleFonts.ubuntu(color: Colors.white70, fontSize: 15)),
          ),
        ],
      );
    } else if (_signupFieldsVisible) {
      return Column(
        children: [
          _buildTextField(hint: 'Username', icon: Icons.person_outline, controller: _usernameController),
          SizedBox(height: 15),
          _buildTextField(hint: 'Email', icon: Icons.email, controller: _emailController),
          SizedBox(height: 15),
          _buildTextField(hint: 'Password', icon: Icons.lock_outline, obscureText: true, controller: _passwordController),
          SizedBox(height: 15),
          // _buildTextField(hint: 'Role', icon: Icons.assignment_ind, controller: _roleController),
          // SizedBox(height: 15),
          // _buildTextField(hint: 'Expiration Duration', icon: Icons.access_time, controller: _expirationDurationController),
          // SizedBox(height: 15),
          // _buildTextField(hint: 'Expiration Unit', icon: Icons.calendar_today, controller: _expirationUnitController),
          // SizedBox(height: 20),
          _buildButton(context, title: 'Sign up', onPressed: _signup),
          SizedBox(height: 10),
          TextButton(
            onPressed: () {
              setState(() {
                _loginFieldsVisible = true;
                _signupFieldsVisible = false;
              });
            },
            child: Text('Sign in instead', style: GoogleFonts.ubuntu(color: Colors.white70, fontSize: 15)),
          ),
        ],
      );
    } else {
      return Container(); // Return an empty container when neither is visible
    }
  }
Widget _buildTextField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool obscureText = false,
    bool isRequired = true,
}) {
  return TextField(
    controller: controller,
    style: GoogleFonts.ubuntu(color: Colors.white),
    obscureText: obscureText,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.ubuntu(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white70),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white70),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
    ),
  );
}


  Widget _buildButton(BuildContext context, {required String title, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        minimumSize: Size(double.infinity, 50),
      ),
      child: Text(
        title,
        style: GoogleFonts.ubuntu(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
