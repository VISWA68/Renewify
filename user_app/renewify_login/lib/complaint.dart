import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:renewify_login/confirmation.dart';
import 'dart:convert';
import 'package:renewify_login/main.dart';
import 'package:renewify_login/provider/location_provider.dart';

class ComplaintPage extends StatefulWidget {
  @override
  _ComplaintPageState createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _problemController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  Future<void> _submitComplaint() async {
    final locationProvider = context.read<LocationProvider>();
    if (_formKey.currentState!.validate()) {
      final String name = _nameController.text.trim();
      final String phone = _phoneController.text.trim();
      final String title = _titleController.text.trim();
      final String problem = _problemController.text.trim();
      final String city = _cityController.text.trim();

      // Ensure location data is available
      if (locationProvider.latitude == null || locationProvider.longitude == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location data is not available.')),
        );
        return;
      }

      // Construct the Google Maps URL
      String locationUrl =
          "https://www.google.com/maps?q=${locationProvider.latitude},${locationProvider.longitude}";

      // Prepare the request body
      final Map<String, dynamic> requestBody = {
        "title": title,
        "issue": problem,
        "phone": phone,
        "name": name,
        "city": city,
        "location": locationUrl,
      };

      try {
        // Send the POST request
        final response = await http.post(
          Uri.parse('https://9b43-14-195-39-82.ngrok-free.app/request_service'),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(requestBody),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Navigate to the confirmation page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConfirmationPage(name, phone, city, problem),
            ),
          );
        } else {
          // Handle failure
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to submit complaint. Error: ${response.body}'),
            ),
          );
        }
      } catch (e) {
        // Handle exceptions
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade300,
        title: const Text('Complaint'),
        actions: [
          PopupMenuButton<String>(
            icon: const FaIcon(FontAwesomeIcons.globe),
            onSelected: (String value) {
              if (value == 'en') {
                MyApp.of(context)!.setLocale(const Locale('en'));
              } else if (value == 'ta') {
                MyApp.of(context)!.setLocale(const Locale('ta'));
              } else if (value == 'hi') {
                MyApp.of(context)!.setLocale(const Locale('hi'));
              }
            },
            itemBuilder: (BuildContext context) => const <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'en',
                child: Text('English'),
              ),
              PopupMenuItem<String>(
                value: 'ta',
                child: Text('Tamil'),
              ),
              PopupMenuItem<String>(
                value: 'hi',
                child: Text('Hindi'),
              ),
            ],
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(12.0),
          child: Padding(
            padding: EdgeInsets.only(top: 2.0),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'City'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your city';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your problem title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              const Text('Issue', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              TextFormField(
                controller: _problemController,
                maxLines: 5,
                decoration: const InputDecoration(
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitComplaint,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
