import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vendor_app/main.dart';
import 'package:vendor_app/pages/service_provider/service_home.dart';
import 'package:vendor_app/pages/service_provider/service_register.dart';

class ServiceProviderLoginPage extends StatefulWidget {
  @override
  _ServiceProviderLoginPageState createState() =>
      _ServiceProviderLoginPageState();
}

class _ServiceProviderLoginPageState extends State<ServiceProviderLoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  Future<void> _loginServiceProvider() async {
    final response = await http.post(
      Uri.parse('${Url.url}/login_service_provider'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': _email,
        'password': _password,
      }),
    );

    final responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(responseData['message'])));
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceProviderHome(
              userId: responseData['service_provider_id'],
            ),
          ));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(responseData['error'])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login as Service Provider',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.green, 
        automaticallyImplyLeading: false, 
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    label: 'Email',
                    onSaved: (value) => _email = value!,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your email' : null,
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    label: 'Password',
                    obscureText: true,
                    onSaved: (value) => _password = value!,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your password' : null,
                  ),
                  SizedBox(height: 30),
                  _buildCustomButton(
                    text: 'Login',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _loginServiceProvider();
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  Center(child: Text("Not registered?")),
                  _buildCustomButton(
                    text: 'Register here',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ServiceProviderRegisterPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    bool obscureText = false,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      ),
      obscureText: obscureText,
      onSaved: onSaved,
      validator: validator,
    );
  }

  Widget _buildCustomButton(
      {required String text, required VoidCallback onPressed}) {
    return Container(
      width: double.infinity,
      height: 70,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.green, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25), 
          ),
          padding: EdgeInsets.symmetric(vertical: 15),
          elevation: 8,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
