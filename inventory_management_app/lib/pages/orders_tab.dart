import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrdersTab extends StatefulWidget {
  @override
  _OrdersTabState createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: ItemSearchDelegate());
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('items')
            .where('itemName', isGreaterThanOrEqualTo: _searchQuery)
            .where('itemName', isLessThanOrEqualTo: _searchQuery + '\uf8ff')
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
          Map<String, List<Map<String, dynamic>>> groupedItems = {};

          // Group items by itemName
          for (var item in items) {
            String itemName = item['itemName'];
            String supplierName = item['supplierName'];
            int quantity = item['quantity'];

            if (!groupedItems.containsKey(itemName)) {
              groupedItems[itemName] = [];
            }
            groupedItems[itemName]!.add({
              'supplierName': supplierName,
              'quantity': quantity,
              'itemId': item.id, // Store item ID for future updates
            });
          }

          return ListView.builder(
            itemCount: groupedItems.keys.length,
            itemBuilder: (context, index) {
              String itemName = groupedItems.keys.elementAt(index);
              List<Map<String, dynamic>> suppliers = groupedItems[itemName]!;

              return ExpansionTile(
                title: Text(itemName),
                children: suppliers.map((supplier) {
                  return ListTile(
                    title: Text('${supplier['supplierName']}'),
                    subtitle: Text('Quantity: ${supplier['quantity']}'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        _placeOrder(
                          supplier['supplierName'],
                          supplier['quantity'],
                          supplier['itemId'],
                        );
                      },
                      child: Text('Order'),
                    ),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }

  // Method to handle placing an order
  void _placeOrder(String supplierName, int availableQuantity, String itemId) {
    int _orderQuantity = 0;

    // Controller to handle input for order quantity
    TextEditingController _quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Make an Order'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Supplier: $supplierName'),
              Text('Available Quantity: $availableQuantity'),
              TextField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Order Quantity'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _orderQuantity = int.tryParse(value) ?? 0;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_orderQuantity > 0 && _orderQuantity <= availableQuantity) {
                  // Proceed with the order
                  await _updateQuantity(itemId, availableQuantity - _orderQuantity);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Order placed for $_orderQuantity items')),
                  );
                  Navigator.of(context).pop(); // Close the dialog
                } else {
                  // Show error if the order exceeds available quantity
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Insufficient quantity available')),
                  );
                }
              },
              child: Text('Confirm Order'),
            ),
          ],
        );
      },
    );
  }

  // Update quantity in Firestore
  Future<void> _updateQuantity(String itemId, int newQuantity) async {
    try {
      await FirebaseFirestore.instance.collection('items').doc(itemId).update({
        'quantity': newQuantity,
      });
      // Optionally: You can also update the order history or another collection for orders if necessary
    } catch (e) {
      print("Error updating quantity: $e");
    }
  }
}

// Search delegate to filter items and suppliers
class ItemSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(query);
  }

  // Build search results
  Widget _buildSearchResults(String query) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('items')
          .where('itemName', isGreaterThanOrEqualTo: query)
          .where('itemName', isLessThanOrEqualTo: query + '\uf8ff')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No results found.'));
        }

        var items = snapshot.data!.docs;
        Map<String, List<Map<String, dynamic>>> groupedItems = {};

        // Group items by itemName
        for (var item in items) {
          String itemName = item['itemName'];
          String supplierName = item['supplierName'];
          int quantity = item['quantity'];

          if (!groupedItems.containsKey(itemName)) {
            groupedItems[itemName] = [];
          }
          groupedItems[itemName]!.add({
            'supplierName': supplierName,
            'quantity': quantity,
            'itemId': item.id, // Store item ID for future updates
          });
        }

        return ListView.builder(
          itemCount: groupedItems.keys.length,
          itemBuilder: (context, index) {
            String itemName = groupedItems.keys.elementAt(index);
            List<Map<String, dynamic>> suppliers = groupedItems[itemName]!;

            return ExpansionTile(
              title: Text(itemName),
              children: suppliers.map((supplier) {
                return ListTile(
                  title: Text('${supplier['supplierName']}'),
                  subtitle: Text('Quantity: ${supplier['quantity']}'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Call the order method with the selected supplier's details
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Make an Order'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Supplier: ${supplier['supplierName']}'),
                                Text('Available Quantity: ${supplier['quantity']}'),
                                TextField(
                                  decoration: InputDecoration(labelText: 'Order Quantity'),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {},
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Your order confirmation code here
                                },
                                child: Text('Confirm Order'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('Order'),
                  ),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}
