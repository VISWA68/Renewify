import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:Renewify/gen_l10n/app_localizations.dart';
import 'package:Renewify/main.dart'; // Adjust the import based on your project structure

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key}) : super(key: key);

  Future<bool> _registerUser(String username, String email, String password) async {
    final url = Uri.parse('http://192.168.1.6:8000//api/register/'); // Use localhost IP

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Registration successful
        print('Registration successful');
        return true;
      } else {
        // Registration failed
        print('Registration failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    // Controllers for text fields
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _phoneNumberController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _confirmPasswordController = TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double width = constraints.maxWidth;

            double getWidth(double percentage) => width * percentage;

            return Center(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: height,
                    color: Colors.white,
                  ),
                  ClipPath(
                    clipper: MyClipper(),
                    child: Container(
                      width: double.infinity,
                      height: height * 0.6,
                      color: const Color.fromRGBO(219, 246, 220, 1),
                    ),
                  ),
                  Positioned(
                    top: height * 0.15,
                    left: getWidth(0.05),
                    right: getWidth(0.05),
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.newe,
                          style: const TextStyle(fontSize: 24, color: Colors.black),
                        ),
                        Text(
                          AppLocalizations.of(context)!.sign,
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _nameController,
                          obscureText: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: AppLocalizations.of(context)!.name,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _emailController,
                          obscureText: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: AppLocalizations.of(context)!.email,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _phoneNumberController,
                          obscureText: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: AppLocalizations.of(context)!.phone,
                          ),
                          maxLength: 10,
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: AppLocalizations.of(context)!.newpass,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: AppLocalizations.of(context)!.confirm,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            String name = _nameController.text.trim();
                            String email = _emailController.text.trim();
                            String password = _passwordController.text.trim();
                            String confirmPassword = _confirmPasswordController.text.trim();

                            if (password == confirmPassword) {
                              _registerUser(name, email, password).then((isRegistered) {
                                if (isRegistered) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeScreen(
                                        /* name: name,
                                        email: email,
                                        phoneNumber: _phoneNumberController.text.trim(),
                                        password: password, */
                                      ),
                                    ),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Registration Failed'),
                                        content: Text('An error occurred during registration. Please try again.'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text(AppLocalizations.of(context)!.ok),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              });
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Password Mismatch'),
                                    content: Text('Please ensure both passwords match.'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text(AppLocalizations.of(context)!.ok),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.but,
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height - 50)
      ..quadraticBezierTo(
        size.width / 4,
        size.height - 40,
        size.width / 2,
        size.height - 20,
      )
      ..quadraticBezierTo(
        3 / 4 * size.width,
        size.height,
        size.width,
        size.height - 30,
      )
      ..lineTo(size.width, 0);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
