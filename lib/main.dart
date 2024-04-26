import 'package:ecommerce_app/screens/first_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/home.dart';
import 'widgets/theme_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter binding is initialized
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]); // Set preferred orientations
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeManager(),
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'My App', // Add a title for your app
            themeMode: themeManager.themeMode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
           home: FirstScreen(), 
          );
        },
      ),
    );
  }
}
