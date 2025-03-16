import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int totalQuantity = 0;      // To hold the total quantity
  int uniqueSuppliers = 0;    // To hold the number of unique suppliers
  List<DocumentSnapshot> lowStockItems = []; // To store items with quantity less than 10
  Set<String> suppliersSet = Set(); // To store unique suppliers' names

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Function to fetch data from Firestore and calculate totals
  Future<void> _fetchData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Query all items in the 'items' collection
    QuerySnapshot snapshot = await firestore.collection('items').get();

    int totalQty = 0;
    Set<String> suppliers = Set(); // Temporary set to hold unique suppliers
    List<DocumentSnapshot> lowStock = []; // Temporary list for items with quantity < 10

    // Loop through each document (item) in the snapshot
    snapshot.docs.forEach((doc) {
      // Safely cast 'quantity' to int, ensuring it doesn't cause an error
      totalQty += (doc['quantity'] as num).toInt();

      // Add the supplier name to the set (duplicates are automatically handled)
      suppliers.add(doc['supplierName']);

      // If quantity is less than 10, add to lowStockItems
      if ((doc['quantity'] as num).toInt() < 10) {
        lowStock.add(doc);
      }
    });

    // Update the state with the aggregated data
    setState(() {
      totalQuantity = totalQty;          // Set the total quantity
      uniqueSuppliers = suppliers.length; // Set the number of unique suppliers
      lowStockItems = lowStock;          // Set the list of low stock items
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inventory Overview"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display total quantity and unique suppliers in 2x2 grid cards
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildCard('Total Quantity', '$totalQuantity'),
                  _buildCard('Total Suppliers', '$uniqueSuppliers'),
                ],
              ),
              // Display low stock items
              lowStockItems.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          'No low stock items.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          'Low Stock Items',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    ),
              // List low stock items with an orange dot
              lowStockItems.isEmpty
                  ? Container()
                  : Column(
                      children: lowStockItems.map((item) {
                        return Card(
                          elevation: 2.0,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.orange,
                              ),
                            ),
                            title: Center(
                              child: Text(
                                item['itemName'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            subtitle: Center(
                              child: Text(
                                'Quantity: ${item['quantity']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to create a card for total quantity and total suppliers
  Widget _buildCard(String title, String subtitle) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
