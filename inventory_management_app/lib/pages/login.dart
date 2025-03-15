import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/constants.dart';
import 'home.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login successful!")));  // change this to alert box

      // Navigate to HomeScreen after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: backgroundColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // StockMate Text
            Text(
              'StockMate',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: buttonColor,
              ),
            ),
            SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Welcome back',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 3),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Sign in to manage inventory seamlessly',
                style: TextStyle(
                  fontSize: 10,
                  color: buttonColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Center(
              child: Image.asset(
                'assests/login.png', // Replace with the path of your image asset
                height: 160, // Adjust height of the image
                width: 160, // Adjust width of the image
              ),
            ),
            SizedBox(height: 20),

            // Email TextField
            Center(
              child: Card(
                elevation: 5, // Shadow effect for the card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    12,
                  ), // Rounded corners for the card
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                ), // Horizontal margin
                child: Padding(
                  padding: const EdgeInsets.all(
                    16.0,
                  ), // Padding inside the card
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Enter your email or username',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Card(
                elevation: 5, // Shadow effect for the card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    12,
                  ), // Rounded corners for the card
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                ), // Horizontal margin
                child: Padding(
                  padding: const EdgeInsets.all(
                    16.0,
                  ), // Padding inside the card
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Enter your password',
                    ),
                    obscureText: true,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Login Button
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
              ), // Add horizontal margin
              child: ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      buttonColor, // Use the button color from constants.dart
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.zero, // Make the button rectangular
                  ),
                  minimumSize: Size(
                    double.infinity,
                    50,
                  ), // Set a fixed height for the button
                ),
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                  ), // Make text color white
                ),
              ),
            ),
            SizedBox(height: 10),

            // Signup Option Text
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupScreen()),
                );
              },
              child: Text(
                "Don't have an account? Sign Up",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
