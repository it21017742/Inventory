import 'package:flutter/material.dart';
import 'package:inventory_management_app/utils/constants.dart';
import 'login.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: backgroundColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'StockMate',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: buttonColor,
              ),
            ),
            Center(
              child: Image.asset(
                'assests/splash.png', // Replace with the path of your image asset
                height: 160, // Adjust height of the image
                width: 160, // Adjust width of the image
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Smart Inventory, Smarter Business',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),

            Card(
              elevation: 5, // Set shadow effect for the card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  12,
                ), // Optional: Rounded corners
              ),
              color: backgroundColor, // Optional: Background color for the card
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ), // Padding inside the card
                child: Text(
                  'StockMate helps you efficiently manage your shop\'s inventory, track stock levels, and streamline sales—all in one place. Stay organized, reduce losses, and grow your business with ease.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 9,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),

            Align(
              alignment:
                  Alignment.bottomCenter, // Align the button to the bottom
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                ), // Set 10 pixels above the bottom
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ), // Add horizontal margin
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          buttonColor, // Use the button color from constants.dart
                      shape: RoundedRectangleBorder(
                        // Make the button rectangular
                        borderRadius:
                            BorderRadius
                                .zero, // Remove rounded corners (make it rectangular)
                      ),
                      minimumSize: Size(
                        double.infinity,
                        50,
                      ), // Set a fixed height for the button
                    ),
                    child: Text(
                      'Get Started !',
                      style: TextStyle(
                        color: Colors.white,
                      ), // Make text color white
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
