import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized
  await Firebase.initializeApp(); // Initialize Firebase

  runApp(MyApp()); // Start the app
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory Management',
      home: Scaffold(
        appBar: AppBar(title: Text('Home')),
        body: Center(child: Text('Welcome to Inventory Management')),
      ),
    );
  }
}
