import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:vendor_app/main.dart';
import 'package:vendor_app/provider/sellerProvider.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  Map<String, dynamic>? shopData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchShopDetails();
  }

  Future<void> fetchShopDetails() async {
    final sellerId =
        Provider.of<SellerProvider>(context, listen: false).sellerId;

    try {
      final response = await http.get(
        Uri.parse('${Url.url}/shops/$sellerId'),
      );

      if (response.statusCode == 200) {
        setState(() {
          shopData = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch shop data')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching shop data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : shopData == null || shopData!['shops'].isEmpty
              ? const Center(
                  child: Text(
                    'No shops or products found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: shopData!['shops'].length,
                  itemBuilder: (context, index) {
                    final shop = shopData!['shops'][index];
                    return _buildShopCard(shop);
                  },
                ),
    );
  }

  Widget _buildShopCard(Map<String, dynamic> shop) {
    return Column(children: [
      Card(
        elevation: 5,
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shop Details
              Text(
                shop['shop_name'],
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                'Address: ${shop['address']}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 5),
              Text(
                'UPI ID: ${shop['upi_id']}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
      // Product List
      const Text(
        'Products',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 10),
      shop['products'].isEmpty
          ? const Text(
              'No products available',
              style: TextStyle(color: Colors.grey),
            )
          : SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: shop['products'].length,
                itemBuilder: (context, index) {
                  final product = shop['products'][index];
                  return _buildProductCard(product);
                },
              ),
            ),
    ]);
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(right: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Expanded(
        child: Container(
          width: 150,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: product['image'] != ''
                      ? DecorationImage(
                          image: NetworkImage(product['image']),
                          fit: BoxFit.cover,
                        )
                      : const DecorationImage(
                          image: AssetImage('assets/placeholder.png'),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(height: 8),
              // Product Name
              Text(
                product['name'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              const Spacer(),

              // Product Price
              Text(
                '₹${product['price']}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
