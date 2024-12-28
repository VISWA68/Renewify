import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vendor_app/main.dart';
import 'package:vendor_app/pages/service_provider/service_login.dart';

class ServiceProviderRegisterPage extends StatefulWidget {
  const ServiceProviderRegisterPage({super.key});

  @override
  _ServiceProviderRegisterPageState createState() =>
      _ServiceProviderRegisterPageState();
}

class _ServiceProviderRegisterPageState
    extends State<ServiceProviderRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _phone = '';
  String _password = '';
  String _serviceType = 'Installation';

  Future<void> _registerServiceProvider() async {
    final response = await http.post(
      Uri.parse('${Url.url}/register_service_provider'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': _name,
        'email': _email,
        'phone': _phone,
        'password': _password,
        'service_type': _serviceType,
      }),
    );

    final responseData = json.decode(response.body);

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(responseData['message'])));
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceProviderLoginPage(),
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
          'Register as Service Provider',
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
                'Create an Account',
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
                    label: 'Name',
                    onSaved: (value) => _name = value!,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your name' : null,
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    label: 'Email',
                    onSaved: (value) => _email = value!,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your email' : null,
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    label: 'Phone',
                    onSaved: (value) => _phone = value!,
                    validator: (value) => value!.isEmpty
                        ? 'Please enter your phone number'
                        : null,
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    label: 'Password',
                    obscureText: true,
                    onSaved: (value) => _password = value!,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your password' : null,
                  ),
                  SizedBox(height: 20),
                  _buildDropdownField(),
                  SizedBox(height: 30),
                  _buildCustomButton(
                    text: 'Register',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _registerServiceProvider();
                      }
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

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _serviceType,
      items: [
        DropdownMenuItem(value: 'Installation', child: Text('Installation')),
        DropdownMenuItem(value: 'Service', child: Text('Service')),
        DropdownMenuItem(value: 'Both', child: Text('Both')),
      ],
      onChanged: (value) {
        setState(() {
          _serviceType = value!;
        });
      },
      decoration: InputDecoration(
        labelText: 'Service Type',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      ),
    );
  }

  Widget _buildCustomButton(
      {required String text, required VoidCallback onPressed}) {
    return Container(
      width: double.infinity,
      height: 50,
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
