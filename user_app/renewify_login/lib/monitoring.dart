
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

// import 'biogas_services.dart';
import 'complaint.dart';
import 'dashboard.dart';
import 'main.dart';
import 'post_view_page.dart';
import 'settings.dart';
import 'shop.dart';
import 'solarservices.dart';
import 'subsidies.dart';

class SolarElectricity extends StatefulWidget {
  @override
  _SolarElectricityState createState() => _SolarElectricityState();
}

class _SolarElectricityState extends State<SolarElectricity> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String formattedDate = DateFormat('dd MMMM yyyy').format(DateTime.now());
  String formattedDay = DateFormat('EEEE').format(DateTime.now());

  String weatherDescription = '';
  String temperature = '';
  IconData weatherIcon = Icons.wb_sunny;

  String solar1Current = '0.00 A';
  String solar1Voltage = '0.00 V';

  String solar2Current = '0.00 A';
  String solar2Voltage = '0.00 V';

  String batteryCurrent = '0.00 A';
  String batteryVoltage = '0.00 V';
  int batteryPercentage = 0;
  // String gasAlert = '';

  double _expectedPowerOutput = 0.0;

  int _currentEndpointId = 2088;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    fetchExpectedPowerOutput().then((value) {
      setState(() {
         _expectedPowerOutput = double.parse(value.toStringAsFixed(2));
      });
    });

    _timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
      _fetchSensorData(_currentEndpointId);
      _currentEndpointId++;
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    _fetchWeather(position.latitude, position.longitude);
  }

  Future<void> _fetchWeather(double lat, double lon) async {
    String apiKey = '7098953cebde95726ac3b354d2f780e7';
    String weatherApiUrl =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey';

    http.Response weatherResponse = await http.get(Uri.parse(weatherApiUrl));
    if (weatherResponse.statusCode == 200) {
      Map<String, dynamic> weatherData = jsonDecode(weatherResponse.body);
      setState(() {
        weatherDescription = weatherData['weather'][0]['description'];
        temperature = weatherData['main']['temp'].toString();
        weatherIcon = _getWeatherIcon(weatherData['weather'][0]['main']);
      });
    } else {
      print('Failed to load weather data');
    }

    fetchExpectedPowerOutput().then((value) {
      setState(() {
        _expectedPowerOutput = value;
      });
    });
  }

  Future<double> fetchExpectedPowerOutput() async {
    final response = await http.get(Uri.parse(
        'https://renewify-solar-output-prediction-zfy2.onrender.com/solar-power-expectation'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['expected_total_power_output'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _fetchSensorData(int id) async {
  final response = await http.get(
      Uri.parse('http://192.168.170.45:8000/api/sensor-data/$id/'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    setState(() {
      solar1Current = '${(data['current1'] as double).toStringAsFixed(2)} A';
      solar1Voltage = '${(data['voltage1'] as double).toStringAsFixed(2)} V';

      solar2Current = '${(data['current2'] as double).toStringAsFixed(2)} A';
      solar2Voltage = '${(data['voltage2'] as double).toStringAsFixed(2)} V';

      batteryCurrent = '${(data['battery_current'] as double).toStringAsFixed(2)} A';
      batteryVoltage = '${(data['battery_voltage'] as double).toStringAsFixed(2)} V';
      batteryPercentage = data['battery_percentage'].toInt();
      // gasAlert = data['gas_alert'];
    });
  } else {
    print('Failed to fetch sensor data');
  }
}


  IconData _getWeatherIcon(String weatherMain) {
    switch (weatherMain.toLowerCase()) {
      case 'thunderstorm':
        return Icons.flash_on;
      case 'drizzle':
        return Icons.cloud_circle_outlined;
      case 'rain':
        return Icons.beach_access;
      case 'snow':
        return Icons.ac_unit;
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      default:
        return Icons.wb_sunny;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.green.shade300,
        title: Text('Electricity Monitoring'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Dashboard()),
                        );
                      },
                      child: Image.asset(
                        'assets/images/logo1.png',
                        height: 40,
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Dashboard()),
                        );
                      },
                      child: Text(
                        'RENEWIFY',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.wb_sunny),
              title: Text('Solar Installation'),
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
              leading: Icon(Icons.attach_money),
              title: Text('Subsidies /Loans'),
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
              leading: Icon(Icons.warning_rounded),
              title: Text('Complaints'),
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
              leading: Icon(Icons.electric_bolt),
              title: Text('Electricity'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SolarElectricityMonitoringPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.podcasts),
              title: Text('Green Edge'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostViewPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Energy Market'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShopPage()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AccountSettingsPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date, Day, Weather Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      formattedDay,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      weatherIcon,
                      size: 24,
                      color: Colors.orange,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '$temperature°C',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      weatherDescription,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            // Expected Power Output
            Center(
              child: Text(
                'Expected Power Output: $_expectedPowerOutput kW',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Solar 1 and Solar 2 Cards
// Solar 1 and Solar 2 Cards
Expanded(
  child: Row(
    children: [
      // Solar 1 Container
      Expanded(
        child: Container(
          height: 150, // Set the desired height here
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Solar 1',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Current:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        solar1Current,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Voltage:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        solar1Voltage,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      SizedBox(width: 10),
      // Solar 2 Container
      Expanded(
        child: Container(
          height: 150, // Set the same height for consistency
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Solar 2',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Current:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        solar2Current,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Voltage:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        solar2Voltage,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  ),
),
SizedBox(height: 10),

// Raise Complaint Container
Container(
  padding: EdgeInsets.all(12.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        'Raise Complaint',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
      SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ComplaintPage()), 
          );
        },
        child: Text('Raise Complaint'),
      ),
    ],
  ),
),
SizedBox(height: 10),

// Battery Monitoring Card
Card(
  elevation: 4,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Battery Monitoring',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Current:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            Text(
              batteryCurrent,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Voltage:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            Text(
              batteryVoltage,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Charge Level:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            Text(
              '$batteryPercentage%',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      //   if (gasAlert.isNotEmpty)
      //     Padding(
      //       padding: const EdgeInsets.only(top: 10),
      //       child: Row(
      //         children: [
      //           Icon(
      //             Icons.warning,
      //             color: Colors.red,
      //             size: 24,
      //           ),
      //           SizedBox(width: 8),
      //           Text(
      //             'Gas Alert: $gasAlert',
      //             style: TextStyle(
      //               fontSize: 16,
      //               color: Colors.red,
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      ],
    ),
  ),

          ],
        ),
      ),
    );
  }
}
class SolarElectricityMonitoringPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SolarElectricity();
  }
}

