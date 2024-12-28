import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      title: 'Renewify Seller',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const RegisterPage(),
    );
  }
}


class Url {
  static const String url = "http://192.168.23.5:8000";
}
