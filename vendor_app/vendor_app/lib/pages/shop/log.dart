// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:seller_app/main.dart';
// import 'package:seller_app/pages/home.dart';
// import 'package:seller_app/provider/sellerProvider.dart';
// import 'package:seller_app/provider/shopProvider.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// final FlutterSecureStorage storage = FlutterSecureStorage();

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   Future<void> login() async {
//     final response = await http.post(
//       Uri.parse(
//           '${Url.url}/login'), // Replace with your server URL
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'email': emailController.text,
//         'password': passwordController.text,
//       }),
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       final sellerId = data['seller_id'];
//       final shopId = data.containsKey('shop_id') ? data['shop_id'] : null;
//       final auth0Token =
//           data['auth0_token']; // Extract the Auth0 token from response
//       print(auth0Token);
//       // Store Auth0 token securely
//       await storage.write(key: 'auth0_token', value: auth0Token);

//       // Store sellerId using the Provider
//       Provider.of<SellerProvider>(context, listen: false).sellerId = sellerId;

//       // If shopId exists, store it using the ShopProvider
//       if (shopId != null) {
//         Provider.of<ShopProvider>(context, listen: false).shopId = shopId;
//       }

//       // Navigate to the home page
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => HomePage(),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Login failed')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Renewify Seller - Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: const InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: passwordController,
//               decoration: const InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: login,
//               child: const Text('Login'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
