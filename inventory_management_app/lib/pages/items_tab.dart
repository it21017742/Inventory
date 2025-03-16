import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'home_tab.dart'; // Import HomeTab file

class ItemsTab extends StatefulWidget {
  @override
  _ItemsTabState createState() => _ItemsTabState();
}

class _ItemsTabState extends State<ItemsTab> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Items', textAlign: TextAlign.center),  // Center the title
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Back button icon
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeTab()),  // Navigate to HomeTab
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 200,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search by Item Name',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('items')
            .where('itemName', isGreaterThanOrEqualTo: searchQuery)
            .where('itemName', isLessThanOrEqualTo: searchQuery + '\uf8ff') // For substring search
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No items available.'));
          }

          var items = snapshot.data!.docs;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              var item = items[index];
              int quantity = item['quantity'];
              Color dotColor = _getDotColor(quantity); // Get dot color based on quantity

              return ListTile(
                title: Text(item['itemName']),
                subtitle: Text('Supplier: ${item['supplierName']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Quantity: $quantity'),
                    SizedBox(width: 8),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show AddItemPage as a dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddItemPage();
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Method to get dot color based on quantity
  Color _getDotColor(int quantity) {
    if (quantity > 10) {
      return Colors.green; // Green if quantity > 10
    } else if (quantity > 0 && quantity <= 10) {
      return Colors.orange; // Orange if quantity is between 1 and 10
    } else {
      return Colors.red; // Red if quantity is 0
    }
  }
}

class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _supplierNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _addItem() async {
    String itemName = _itemNameController.text.trim();
    String supplierName = _supplierNameController.text.trim();
    int quantity = int.tryParse(_quantityController.text.trim()) ?? 0;

    // Check if an item with the same supplierName and itemName exists
    QuerySnapshot snapshot = await _firestore
        .collection('items')
        .where('supplierName', isEqualTo: supplierName)
        .where('itemName', isEqualTo: itemName)
        .get();

    if (snapshot.docs.isNotEmpty) {
      // Item exists, update the quantity
      DocumentSnapshot doc = snapshot.docs[0];
      int existingQuantity = doc['quantity'];
      int newQuantity = existingQuantity + quantity;

      await _firestore.collection('items').doc(doc.id).update({
        'quantity': newQuantity,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Quantity updated successfully')),
      );
    } else {
      // Item doesn't exist, add a new document
      await _firestore.collection('items').add({
        'itemName': itemName,
        'supplierName': supplierName,
        'quantity': quantity,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item added successfully')),
      );
    }

    // Clear text fields after submission
    _itemNameController.clear();
    _supplierNameController.clear();
    _quantityController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _itemNameController,
            decoration: InputDecoration(labelText: 'Item Name'),
          ),
          TextField(
            controller: _supplierNameController,
            decoration: InputDecoration(labelText: 'Supplier Name'),
          ),
          TextField(
            controller: _quantityController,
            decoration: InputDecoration(labelText: 'Quantity'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            _addItem();
            Navigator.of(context).pop();
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
