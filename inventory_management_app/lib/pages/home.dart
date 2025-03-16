import 'package:flutter/material.dart';
import 'home_tab.dart';
import 'items_tab.dart';
import 'orders_tab.dart';
import 'suppliers_tab.dart';
import '../utils/constants.dart'; // Import constants for buttonColor

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // List of screens for each tab
  static List<Widget> _widgetOptions = <Widget>[
    HomeTab(),
    ItemsTab(),
    OrdersTab(),
    SuppliersTab(),
  ];

  // Method to change screen on tab selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Home')),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Items'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Suppliers',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: buttonColor,
        unselectedItemColor: Colors.black,
      ),
    );
  }
}
