import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SuppliersTab extends StatefulWidget {
  @override
  _SuppliersTabState createState() => _SuppliersTabState();
}

class _SuppliersTabState extends State<SuppliersTab> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suppliers'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search Supplier...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('items').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No suppliers available.'));
          }

          // Get unique suppliers
          var suppliers = snapshot.data!.docs
              .map((doc) => doc['supplierName'] as String)
              .toSet()
              .where((supplier) => supplier.toLowerCase().contains(searchQuery.toLowerCase()))
              .toList();

          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: suppliers.length,
            itemBuilder: (context, index) {
              String supplier = suppliers[index];
              return SupplierCard(supplier: supplier);
            },
          );
        },
      ),
    );
  }
}

class SupplierCard extends StatefulWidget {
  final String supplier;
  SupplierCard({required this.supplier});

  @override
  _SupplierCardState createState() => _SupplierCardState();
}

class _SupplierCardState extends State<SupplierCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        title: Text(widget.supplier, style: TextStyle(fontWeight: FontWeight.bold)),
        initiallyExpanded: isExpanded,
        onExpansionChanged: (value) {
          setState(() {
            isExpanded = value;
          });
        },
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('items')
                .where('supplierName', isEqualTo: widget.supplier)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('No items available.'),
                );
              }

              var items = snapshot.data!.docs;

              return Column(
                children: items.map((item) {
                  return ListTile(
                    title: Text(item['itemName']),
                    subtitle: Text('Quantity: ${item['quantity']}'),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
