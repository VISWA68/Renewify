import 'package:Renewify/confirmation.dart';
import 'package:Renewify/main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'dart:convert';

class ComplaintPage extends StatefulWidget {
  @override
  _ComplaintPageState createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _problemController = TextEditingController();
  TextEditingController _cityController = TextEditingController();

  LocationData? _locationData;
  bool _isFetchingLocation = false;

  Future<void> _fetchLocation() async {
    setState(() {
      _isFetchingLocation = true;
    });
    try {
      Location location = Location();

      bool _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          throw Exception('Location services are disabled.');
        }
      }

      PermissionStatus _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          throw Exception('Location permission denied.');
        }
      }

      _locationData = await location.getLocation();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch location: $e')),
      );
    } finally {
      setState(() {
        _isFetchingLocation = false;
      });
    }
  }

  Future<void> _submitComplaint() async {
  if (_formKey.currentState!.validate()) {
    final String name = _nameController.text;
    final String phone = _phoneController.text;
    final String title = _titleController.text;
    final String problem = _problemController.text;
    final String city = _cityController.text;

    Location location = Location();

    try {
      // Check and request location services and permissions
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          throw Exception('Location services are disabled.');
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          throw Exception('Location permissions are denied.');
        }
      }

      // Get the current location
      LocationData _locationData = await location.getLocation();

      // Construct the Google Maps URL
      String locationUrl =
          "https://www.google.com/maps?q=${_locationData.latitude},${_locationData.longitude}";

      // Prepare the request body
      final Map<String, dynamic> requestBody = {
        "title": title,
        "issue": problem,
        "phone": phone,
        "name": name,
        "city": city,
        "location": locationUrl,
      };

      if (Global.sessionCookie == null || Global.sessionCookie!.isEmpty) {
        throw Exception('Session cookie is not available');
      }

      // Send the POST request
      final response = await http.post(
        Uri.parse('https://983e-14-195-39-82.ngrok-free.app/request_service'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Navigate to the confirmation page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ConfirmationPage(name, phone, city, problem),
          ),
        );
      } else {
        // Handle failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to submit complaint. Error: ${response.body}')),
        );
      }
    } catch (error) {
      print("Request failed: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Failed to submit complaint. Please ensure location is enabled and try again.')),
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
              } else if (value == 'hi') {
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
                onPressed: _isFetchingLocation ? null : _submitComplaint,
                child: Text(_isFetchingLocation ? 'Fetching Location...' : 'Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
