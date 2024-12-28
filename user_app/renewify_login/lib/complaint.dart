import 'package:Renewify/confirmation.dart';
import 'package:Renewify/main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ComplaintPage extends StatefulWidget {
  @override
  _ComplaintPageState createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _problemController = TextEditingController();

  Future<void> _submitComplaint() async {
    if (_formKey.currentState!.validate()) {
      final String name = _nameController.text;
      final String phone = _phoneController.text;
      final String city = _cityController.text;
      final String title = _titleController.text;
      final String problem = _problemController.text;

      // Prepare the request body
      final Map<String, dynamic> requestBody = {
        "title": title,
        "description": problem,
        "phoneno": phone,
        "city": city,
        "user_name": name
      };

      try {

        if (Global.sessionCookie == null || Global.sessionCookie!.isEmpty) {
          throw Exception('Session cookie is not available');
        }
        // Send the POST request
        final response = await http.post(
          Uri.parse('http://192.168.1.3:8000//api/complaint/'),
          headers: {"Content-Type": "application/json",
          "Cookie": Global.sessionCookie ?? "",
          "X-CSRFToken": Global.csrfToken ?? "",
          },
          body: jsonEncode(requestBody),
        );

        // Debugging: Print response status and body
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Navigate to the confirmation page if the POST request is successful
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConfirmationPage(name, phone, city, problem),
            ),
          );
        } else {
          // Handle failure
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit complaint. Error: ${response.body}')),
          );
        }
      } catch (error) {
        // Handle any exceptions during the request
        print("Request failed: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit complaint. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade300,
        title: Text('Complaint'),
        actions: [
          PopupMenuButton<String>(
            icon: FaIcon(FontAwesomeIcons.globe),
            onSelected: (String value) {
              if (value == 'en') {
                MyApp.of(context)!.setLocale(const Locale('en'));
              } else if (value == 'ta') {
                MyApp.of(context)!.setLocale(const Locale('ta'));
              }else if(value =='hi'){
                MyApp.of(context)!.setLocale(const Locale('hi'));
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'en',
                child: Text('English'),
              ),
              const PopupMenuItem<String>(
                value: 'ta',
                child: Text('Tamil'),
              ),
              const PopupMenuItem<String>(
                value: 'hi',
                child: Text('Hindi'),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(12.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 2.0),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'City'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your city';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your problem title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Text('Issue', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              TextFormField(
                controller: _problemController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Describe your problem here...',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please describe your problem';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitComplaint,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}