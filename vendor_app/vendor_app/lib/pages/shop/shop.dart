import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:vendor_app/main.dart';
import 'package:vendor_app/provider/sellerProvider.dart';
import 'package:vendor_app/provider/shopProvider.dart';


class AddShopPage extends StatefulWidget {
  @override
  _AddShopPageState createState() => _AddShopPageState();
}

class _AddShopPageState extends State<AddShopPage> {
  final _shopNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _upiIdController = TextEditingController();
  final _shopImageController =
      TextEditingController(); 

  bool isLoading = false;

  Future<void> addShop() async {
    setState(() {
      isLoading = true;
    });

    final sellerId =
        Provider.of<SellerProvider>(context, listen: false).sellerId;

    final response = await http.post(
      Uri.parse('${Url.url}/add_shop'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'seller_id': sellerId,
        'shop_name': _shopNameController.text,
        'address': _addressController.text,
        'upi_id': _upiIdController.text,
        'shop_image': _shopImageController.text, 
      }),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final shopId = data['shop_id'];

      // Store sellerId using the Provider
      Provider.of<ShopProvider>(context, listen: false).shopId = shopId;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Shop added successfully')),
      );
      Navigator.pop(context); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add shop')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Shop')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _shopNameController,
              decoration: const InputDecoration(labelText: 'Shop Name'),
            ),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: _upiIdController,
              decoration: const InputDecoration(labelText: 'UPI ID'),
            ),
            TextField(
              controller: _shopImageController,
              decoration:
                  const InputDecoration(labelText: 'Shop Image (optional)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : addShop,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Add Shop'),
            ),
          ],
        ),
      ),
    );
  }
}
