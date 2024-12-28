import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:vendor_app/main.dart';
import 'package:vendor_app/pages/shop/addproduct.dart';
import 'package:vendor_app/pages/shop/myshop.dart';
import 'package:vendor_app/pages/shop/shop.dart';
import 'package:vendor_app/provider/sellerProvider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? sellerData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchSellerData();
    });
  }

  Future<void> fetchSellerData() async {
    final sellerId =
        Provider.of<SellerProvider>(context, listen: false).sellerId;

    final response = await http.get(
      Uri.parse('${Url.url}/seller/$sellerId'),
    );

    if (response.statusCode == 200) {
      setState(() {
        sellerData = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch seller data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height; 
    return Scaffold(
      appBar: AppBar(title: const Text('Renewify Seller Dashboard')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : sellerData == null
              ? const Center(child: Text('No seller data found'))
              : Stack(
                  children: [
                    ClipPath(
                      clipper: MyClipper(),
                      child: Container(
                        width: double.infinity,
                        height: height * 0.8,
                        color: const Color.fromARGB(219, 201, 235, 206),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 120), 
                          Text(
                            'Welcome, ${sellerData!['name']}',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Phone number:  ${sellerData!['phone']}',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddShopPage(),
                                  ));
                            },
                            child: const Text('Add shop'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ShopPage(),
                                  ));
                            },
                            child: const Text('Manage shop'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddProductPage(),
                                  ));
                            },
                            child: const Text('Add products'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height - 150) 
      ..quadraticBezierTo(
        size.width / 4,
        size.height - 80,
        size.width / 2,
        size.height - 60, 
      )
      ..quadraticBezierTo(
        3 / 4 * size.width,
        size.height - 40, 
        size.width,
        size.height - 20,
      )
      ..lineTo(size.width, 0);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

