import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:vendor_app/provider/sellerProvider.dart';
import 'package:vendor_app/provider/shopProvider.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _productNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _productImageController =
      TextEditingController(); 

  bool isLoading = false;

  Future<void> addProduct() async {
    setState(() {
      isLoading = true;
    });

    final shopId = Provider.of<ShopProvider>(context, listen: false).shopId;
    final sellerId =
        Provider.of<SellerProvider>(context, listen: false).sellerId;
    final response = await http.post(
      Uri.parse('http://192.168.234.231:8000/add_product'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'shop_id': shopId,
        'seller_id': sellerId,
        'name': _productNameController.text,
        'description': _descriptionController.text,
        'price': _priceController.text,
        'image': _productImageController.text, // Optional
      }),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added successfully')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add product')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _productNameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _productImageController,
              decoration:
                  const InputDecoration(labelText: 'Product Image (optional)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : addProduct,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
