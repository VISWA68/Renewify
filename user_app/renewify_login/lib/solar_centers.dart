import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:renewify_login/provider/location_provider.dart';
import 'solarservices.dart';
import 'complaint.dart';
import 'map_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
// import 'biogas_services.dart';
import 'dashboard.dart';
import 'monitoring.dart';
import 'shop.dart';
import 'subsidies.dart';

class SolarCenters extends StatelessWidget {
  const SolarCenters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade300,
        title: const Text('Contact Solar Centers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'RENEWIFY',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Dashboard(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.wb_sunny),
              title: const Text('Solar'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SolarServices(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('Subsidies/Loans'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SubsidiesPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.warning_rounded),
              title: const Text('Complaints'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ComplaintPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.electric_bolt),
              title: const Text('Electricity'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  SolarElectricityMonitoringPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.update),
              title: const Text('Updates'),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Energy Market'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ShopPage(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double padding = constraints.maxWidth > 600 ? 32.0 : 16.0;
          return SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Contact the Solar Centers Near You!!',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 65, 200, 69)),
                ),
                const SizedBox(height: 20),
                _buildContactCenter(
                  'Loom Solar Distributor',
                  '62, Ambattur Red Hills Rd, Pudur, Ambattur, Chennai, Tamil Nadu 600053',
                  '9440045678',
                  context,
                ),
                _buildContactCenter(
                  'CHENNAI SOLAR ENERGY SYSTEMS',
                  'No. 1, Gopalakrishna Nagar, Korattur, Chennai, Tamil Nadu 600076',
                  '8428939860',
                  context,
                ),
                 _buildContactCenter(
                  'L.V.SOLAR SOLUTIONS',
                  '52, 4, Surapet Main Rd,Thirumal Nagar, Lakshmipuram, Chennai, Tamil Nadu 600099',
                  '9566055540',
                  context,
                ),

              ],
            ),
          );
        },
      ),
    );
  }

Widget _buildContactCenter(
    String name, String address, String phone, BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 16.0),
    padding: const EdgeInsets.all(12.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.0),
      boxShadow: const [
        BoxShadow(
          color: Colors.black38,
          blurRadius: 4.0,
          offset: Offset(2, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(address),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildIconButton(
              icon: Icons.phone,
              tooltip: phone,
              onTap: () => _launchUrl('tel:$phone'),
            ),
            _buildIconButton(
              icon: Icons.location_on,
              tooltip: address,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapPage(), // Ensure MapPage is defined
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                _showBookingDialog(context, name, address); // Corrected call
              },
              child: const Text('Book'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildIconButton({
  required IconData icon,
  required VoidCallback onTap,
  String? tooltip,
}) {
  return Tooltip(
    message: tooltip ?? '',
    child: IconButton(
      icon: Icon(icon, color: Colors.green),
      onPressed: onTap,
    ),
  );
}

Future<void> _launchUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

void _showBookingDialog(BuildContext context, String name, String address) {
  // Show dialog to collect name and phone number
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Define text controllers for the form fields
      TextEditingController nameController = TextEditingController();
      TextEditingController phoneController = TextEditingController();

      return AlertDialog(
        title: const Text('Booking Form'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Input fields for name and phone number
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog on Cancel
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              String nameInput = nameController.text;
              String phone = phoneController.text;

              if (nameInput.isNotEmpty && phone.isNotEmpty) {
                await _sendDataToServer(context,nameInput,phone);
                Navigator.of(context).pop(); // Close the dialog after submission
              } else {
                // Show a simple alert if fields are empty
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill in all fields')),
                );
              }
            },
            child: const Text('Submit'),
          ),
        ],
      );
    },
  );
}

Future<void> _sendDataToServer(BuildContext context, String name, String phone) async {
  try {
    // Fetch the current location using the location package
    Location location = Location();

    // Ensure location services are enabled
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }
    }

    // Ensure location permissions are granted
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw 'Location permission is denied.';
      }
    }

    // Fetch the current location
    LocationData locationData = await location.getLocation();
    double? latitude = locationData.latitude;
    double? longitude = locationData.longitude;

    if (latitude == null || longitude == null) {
      throw 'Unable to fetch location coordinates.';
    }

    // Construct the Google Maps URL
    final locationUrl = 'https://maps.google.com/?q=$latitude,$longitude';

    // Prepare data for the server
    Map<String, dynamic> requestData = {
      'name': name,
      'phone': phone,
      'location': locationUrl,
    };

    // Send data to the server
    const String serverUrl =
        'https://9b43-14-195-39-82.ngrok-free.app/request_installation';
    final response = await http.post(
      Uri.parse(serverUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestData),
    );

    // Handle the response
    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data successfully sent to the server!')),
      );
      print('Data successfully sent to server: ${response.body}');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send data. Status: ${response.statusCode}')),
      );
      print('Failed to send data to server: ${response.statusCode}');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
    print('Error: $e');
  }
}




}