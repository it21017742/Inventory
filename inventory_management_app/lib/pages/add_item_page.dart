import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

    await _firestore.collection('items').add({
      'itemName': itemName,
      'supplierName': supplierName,
      'quantity': quantity,
      'createdAt': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Item added successfully')));

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
