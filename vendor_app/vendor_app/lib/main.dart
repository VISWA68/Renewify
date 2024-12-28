import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/entry.dart';

import 'package:vendor_app/provider/sellerProvider.dart';
import 'package:vendor_app/provider/shopProvider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SellerProvider()),
        ChangeNotifierProvider(create: (context) => ShopProvider()),
      ],
      child: RenewifyApp(),
    ),
  );
}

class RenewifyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Renewify Seller',
      theme: ThemeData(primarySwatch: Colors.green),
      home: EntryPage(),
    );
  }
}

class Url {
  static const String url = "https://983e-14-195-39-82.ngrok-free.app";
}
