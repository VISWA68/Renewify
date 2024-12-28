import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:vendor_app/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vendor_app/pages/service_provider/service_login.dart';

class ServiceProviderHome extends StatefulWidget {
  final String userId;

  ServiceProviderHome({required this.userId});

  @override
  _ServiceProviderRequestsPageState createState() =>
      _ServiceProviderRequestsPageState();
}

class _ServiceProviderRequestsPageState extends State<ServiceProviderHome> {
  late Future<List<dynamic>> requests;

  Future<List<dynamic>> _fetchRequests() async {
    final url = '${Url.url}/get_requests?user_id=${widget.userId}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return List<dynamic>.from(responseData['requests']);
    } else {
      throw Exception('Failed to load requests');
    }
  }

  @override
  void initState() {
    super.initState();
    requests = _fetchRequests();
  }

  // Function to launch Google Maps
  _launchMap(String location) async {
    final Uri mapUrl = Uri.parse(location);
    try {
      // Check if the URL can be launched
      if (await canLaunch(mapUrl.toString())) {
        await launch(mapUrl.toString(),
            forceSafariVC: false, forceWebView: false);
      } else {
        throw 'Could not launch $mapUrl';
      }
    } catch (e) {
      print('Error launching map: $e');
    }
  }

  // Function to make a call
  _makeCall(String phoneNumber) async {
    final Uri phoneUrl = Uri.parse('tel:$phoneNumber');
    if (await canLaunch(phoneUrl.toString())) {
      await launch(phoneUrl.toString());
    } else {
      throw 'Could not call $phoneNumber';
    }
  }

  // Function to show bottom sheet with options
  _showRequestOptions(BuildContext context, dynamic request) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.check, color: Colors.green),
              title: Text("Accept Request", style: TextStyle(fontSize: 18)),
              onTap: () {
                // Handle accept request logic here
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Request Accepted for ${request['name']}')));
              },
            ),
            ListTile(
              leading: Icon(Icons.call, color: Colors.blue),
              title: Text("Make a Call", style: TextStyle(fontSize: 18)),
              onTap: () {
                _makeCall(request['phone']);
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Requests'),
        centerTitle: true,
        leading: SizedBox(),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServiceProviderLoginPage(),
                  ));
            },
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: requests,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final requestList = snapshot.data!;
            return ListView.builder(
              itemCount: requestList.length,
              itemBuilder: (ctx, index) {
                final request = requestList[index];
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    title: Text(
                      request['name'],
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Location: ${request['location']}'),
                        Text(
                          '${request['type']} Request',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.location_on, color: Colors.blue),
                      onPressed: () {
                        // Launch the map view for the location
                        _launchMap(request['location']);
                      },
                    ),
                    onTap: () {
                      // Show options on tap
                      _showRequestOptions(context, request);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
