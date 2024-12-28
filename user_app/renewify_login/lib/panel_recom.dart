import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:renewify_login/provider/location_provider.dart';
import 'package:geolocator/geolocator.dart';

class PanelRecommendation extends StatefulWidget {
  @override
  _PanelRecommendationState createState() => _PanelRecommendationState();
}

class _PanelRecommendationState extends State<PanelRecommendation> {
  String? _electricityConsumption;
  String? _roofSpace;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchLocation();
    });
  }

  // Fetch location data
  Future<void> _fetchLocation() async {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location services are disabled.')),
        );
        return;
      }

      // Request permission to access location
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied.')),
        );
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Location permission permanently denied.')),
        );
        return;
      }

      // Get the current position (latitude and longitude)
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Update the location provider with the new latitude and longitude
      locationProvider.updateLocation(position.latitude, position.longitude);
      setState(() {
        // Optionally trigger a UI update after location is fetched
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch location: $error')),
      );
    }
  }

  Future<void> _fetchAndSendRecommendation() async {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);

    // Ensure the provider has valid latitude and longitude
    final latitude = locationProvider.latitude;
    final longitude = locationProvider.longitude;

    if (_electricityConsumption != null &&
        _roofSpace != null &&
        latitude != null &&
        longitude != null) {
      await _sendRecommendationRequest(
        _electricityConsumption!,
        _roofSpace!,
        latitude,
        longitude,
      );
    } else {
      // Show error if data is missing
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields.')),
      );
    }
  }

  Future<void> _sendRecommendationRequest(String electricityConsumption,
      String roofSpace, double latitude, double longitude) async {
    const String url = 'https://983e-14-195-39-82.ngrok-free.app/recommend';

    final Map<String, dynamic> requestBody = {
      'electricity_consumption': electricityConsumption,
      'roof_space': roofSpace,
      'latitude': latitude,
      'longitude': longitude,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // Display the response in a dialog box
        _showRecommendationDialog(responseData['recommendation']);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusCode}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send request: $error')),
      );
    }
  }

  // Show recommendation in a dialog
  void _showRecommendationDialog(String recommendation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Recommendation',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade600,
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              recommendation,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'OK',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green.shade600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade300,
        title: const Text('Panel Recommendation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Electricity consumption',
                border: OutlineInputBorder(),
              ),
              items: <String>['Less than 400 units', 'More than 400 units']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _electricityConsumption = newValue;
                });
              },
              value: _electricityConsumption,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Approximate roofspace',
                border: OutlineInputBorder(),
              ),
              items: <String>['Less space', 'More space', 'No space']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _roofSpace = newValue;
                });
              },
              value: _roofSpace,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Trigger the request only after both fields are selected
                if (_electricityConsumption != null && _roofSpace != null) {
                  _fetchAndSendRecommendation();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please complete all fields.')),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Center(
                  child: Text(
                    'Recommend',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
