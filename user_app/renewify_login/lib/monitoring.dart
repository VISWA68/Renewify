<<<<<<< HEAD
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

=======
>>>>>>> 2894a4c3b299db4a521ce84532adef8da767119f
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
<<<<<<< HEAD
import 'package:renewify_login/post_view_page.dart';
import 'package:renewify_login/provider/data_provider.dart';
=======
import 'package:renewify_login/provider/prediction_provider.dart';
import 'dart:async';

// import 'biogas_services.dart';
import 'complaint.dart';
>>>>>>> 2894a4c3b299db4a521ce84532adef8da767119f
import 'dashboard.dart';
import 'solarservices.dart';
import 'subsidies.dart';

//import 'post_view_page.dart';
import 'complaint.dart';
import 'shop.dart';
import 'solar.dart';

class SolarElectricityMonitoringPage extends StatefulWidget {
  @override
  _SolarElectricityMonitoringPageState createState() =>
      _SolarElectricityMonitoringPageState();
}

class _SolarElectricityMonitoringPageState
    extends State<SolarElectricityMonitoringPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String formattedDate = DateFormat('dd MMMM yyyy').format(DateTime.now());
  String formattedDay = DateFormat('EEEE').format(DateTime.now());

  String weatherDescription = '';
  String temperature = '';
  IconData weatherIcon = Icons.wb_sunny; // Default weather icon

  // Sample battery data (replace with actual data)
  // String batteryCurrent = '30 A';
  // String batteryVoltage = '240 V';
  // int batteryPercentage = 70;

  double _expectedPowerOutput = 0.0;


  /* final DatabaseReference _database = FirebaseDatabase.instance.ref();
  String panel1Current = 'Loading...';
  String panel1Voltage = 'Loading...';
  String panel2Current = 'Loading...';
  String panel2Voltage = 'Loading...'; */

  @override
  void initState() {
    super.initState();

    // Start a timer to navigate to the FirstPage after 5 seconds
    /* Timer(
        Duration(seconds: 10),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => SolarElectricity()))); */

    // Fetch current location and expected power output
    _getCurrentLocation();
    fetchExpectedPowerOutput().then((value) {
      setState(() {
<<<<<<< HEAD
        _expectedPowerOutput = value;
=======
        _expectedPowerOutput = double.parse(value.toStringAsFixed(2));
>>>>>>> 2894a4c3b299db4a521ce84532adef8da767119f
      });
    });

    
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
    String apiKey =
        '7098953cebde95726ac3b354d2f780e7'; // Replace with your OpenWeatherMap API key
    String weatherApiUrl =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey';

    http.Response weatherResponse = await http.get(Uri.parse(weatherApiUrl));
    if (weatherResponse.statusCode == 200) {
      Map<String, dynamic> weatherData = jsonDecode(weatherResponse.body);
      setState(() {
        weatherDescription = weatherData['weather'][0]['description'];
        temperature = weatherData['main']['temp'].toString();
        // Set weather icon based on weather condition
        weatherIcon = _getWeatherIcon(weatherData['weather'][0]['main']);
      });
    } else {
      print('Failed to load weather data');
    }

    // Fetch expected power output
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

<<<<<<< HEAD
=======
  Future<void> _fetchSensorData(int id) async {
    final response = await http
        .get(Uri.parse('http://192.168.170.45:8000/api/sensor-data/$id/'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        solar1Current = '${(data['current1'] as double).toStringAsFixed(2)} A';
        solar1Voltage = '${(data['voltage1'] as double).toStringAsFixed(2)} V';

        solar2Current = '${(data['current2'] as double).toStringAsFixed(2)} A';
        solar2Voltage = '${(data['voltage2'] as double).toStringAsFixed(2)} V';

        batteryCurrent =
            '${(data['battery_current'] as double).toStringAsFixed(2)} A';
        batteryVoltage =
            '${(data['battery_voltage'] as double).toStringAsFixed(2)} V';
        batteryPercentage = data['battery_percentage'].toInt();
        // gasAlert = data['gas_alert'];
      });
    } else {
      print('Failed to fetch sensor data');
    }
  }

>>>>>>> 2894a4c3b299db4a521ce84532adef8da767119f
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
<<<<<<< HEAD
    final solarBatteryProvider = Provider.of<SolarBatteryProvider>(context);

    // Fetch data on page load
    solarBatteryProvider.fetchData();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Electricity Monitoring'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
=======
    final predictedEnergyOutput =
        Provider.of<PredictionProvider>(context).predictedEnergyOutput;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.green.shade300,
        title: const Text('Electricity Monitoring'),
>>>>>>> 2894a4c3b299db4a521ce84532adef8da767119f
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: Colors.green),
            onPressed: () {
              // Handle profile action
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
        ),
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
              leading: Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Dashboard(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.wb_sunny),
              title: const Text('Solar'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SolarServices(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.attach_money),
              title: const Text('Subsidies/Loans'),
             onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubsidiesPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.warning_rounded),
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
              leading: Icon(Icons.electric_bolt),
              title: const Text('Electricity'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SolarElectricityMonitoringPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.update),
              title: const Text('Updates'),
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
              leading: Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Handle Settings navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // Handle Logout navigation
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /* Text(
                            'Today Weather',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ), */
                          //SizedBox(height: 10),
                          Icon(
                            weatherIcon,
                            size: 50,
                            color: Colors.orange,
                          ),
                          SizedBox(height: 20),
                          Text(
                            '$temperature°C',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            weatherDescription,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            formattedDay,
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Solar 1',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Current:',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  solarBatteryProvider.solarPanel1Current.toStringAsFixed(2),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Voltage:',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  solarBatteryProvider.solarPanel1Voltage.toStringAsFixed(2),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Solar 2',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Current:',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  solarBatteryProvider.solarPanel2Current.toStringAsFixed(2),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Voltage:',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  solarBatteryProvider.solarPanel2Voltage.toStringAsFixed(2),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                        color: Colors.green[100],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Battery Status',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                solarBatteryProvider.batteryCurrent.toStringAsFixed(2),
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              /* Text(
                                //batteryCurrent,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ), */
                            ],
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Voltage:',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text(
                                solarBatteryProvider.batteryCurrent.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Percentage:',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text(
                                solarBatteryProvider.batteryPercentage.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                     Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                        color: Colors.green[100],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Raise Complaint',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ), 
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            'If you are facing any issues, We will be there for your assistance',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ComplaintPage(),
                                    ),
                                  );
                                },
                                child: Text('Complaint'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
<<<<<<< HEAD
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                        color: Colors.green[100],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Future solar power',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            'Expected Solar energy for next month',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '${_expectedPowerOutput.toStringAsFixed(0)} KWh',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
=======
              ],
            ),
            SizedBox(height: 20),
            // Expected Power Output
            Center(
              child: Text(
                'Expected Power Output: $predictedEnergyOutput kW',
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                        MaterialPageRoute(
                            builder: (context) => ComplaintPage()),
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
>>>>>>> 2894a4c3b299db4a521ce84532adef8da767119f
        ),
      ),
    );
  }
<<<<<<< HEAD
}
=======
}

class SolarElectricityMonitoringPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SolarElectricity();
  }
}
>>>>>>> 2894a4c3b299db4a521ce84532adef8da767119f
