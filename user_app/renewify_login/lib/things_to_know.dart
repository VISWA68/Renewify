import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:renewify_login/complaint.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'biogas_services.dart';
import 'dashboard.dart';
import 'main.dart';
import 'monitoring.dart';
import 'post_view_page.dart';
import 'settings.dart';
import 'shop.dart';
import 'solarservices.dart';
import 'subsidies.dart';

class thingstoknow extends StatelessWidget {
  const thingstoknow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double containerHeight = 220.0;
    final double containerHeightNOC =
        260.0; // Increased height for NOC container
    final double containerMargin = 16.0;
    final double iconSize = 32.0;
    final double iconRadius = 40.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade300,
        title: Text('Things to know'),
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 15.0), // Adjust top padding here
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
                        'assets/images/logo1.png', // Replace with your logo path
                        height: 40, // Adjust the height of the image
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
                          fontSize: 20, // Adjust the font size if needed
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
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildContainer(
              color: Colors.lightBlueAccent,
              icon: Icons.location_city,
              title: 'No Objection Certificate',
              text:
                  'To apply for a No Objection Certificate (NOC) from the municipality, visit the following link:',
              containerHeight: containerHeightNOC,
              iconSize: iconSize,
              iconRadius: iconRadius,
              containerMargin: containerMargin,
              buttonText: 'Apply for NOC',
              buttonLink:
                  'https://parivahan.gov.in/parivahan//en/content/no-objection-certificate',
            ),
            _buildContainer(
              color: const Color.fromARGB(255, 193, 255, 114),
              icon: Icons.info,
              title: 'Cost of Solar Installation',
              text:
                  'The average cost of a solar installation today is between Rs.15,000 to Rs.20,000 per kilowatt, depending on the size of the system and other factors.',
              containerHeight: containerHeight,
              iconSize: iconSize,
              iconRadius: iconRadius,
              containerMargin: containerMargin,
            ),
            _buildContainer(
              color: Color.fromARGB(235, 156, 252, 115),
              icon: Icons.warning,
              title: 'Subsidies for Solar Installations',
              text:
                  'Subsidies for solar installations can cover up to 30% of the total cost, depending on the state and the specific program.',
              containerHeight: containerHeight,
              iconSize: iconSize,
              iconRadius: iconRadius,
              containerMargin: containerMargin,
            ),
            _buildContainer(
              color: const Color.fromARGB(255, 193, 255, 114),
              icon: Icons.help,
              title: 'Payback Period',
              text:
                  'The payback period for a solar installation can range from 3 to 7 years, depending on the cost of electricity and the amount of sunlight your location receives.',
              containerHeight: containerHeight,
              iconSize: iconSize,
              iconRadius: iconRadius,
              containerMargin: containerMargin,
            ),
            _buildContainer(
              color: const Color.fromARGB(255, 162, 241, 129),
              icon: Icons.check_circle,
              title: 'Financing Options',
              text:
                  'Financing options for solar installations include loans, leases, and power purchase agreements (PPAs), which can help reduce the upfront cost.',
              containerHeight: containerHeight,
              iconSize: iconSize,
              iconRadius: iconRadius,
              containerMargin: containerMargin,
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 248, 246, 246),
    );
  }

  Widget _buildContainer({
    required Color color,
    required IconData icon,
    required String title,
    required String text,
    required double containerHeight,
    required double iconSize,
    required double iconRadius,
    required double containerMargin,
    String? buttonText,
    String? buttonLink,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: containerMargin),
      padding: const EdgeInsets.all(16),
      height: containerHeight,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 10,
            child: CircleAvatar(
              radius: iconRadius / 2,
              backgroundColor: Colors.white,
              child: Icon(
                icon,
                size: iconSize,
                color: color,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: iconRadius + 20, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  text,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                if (buttonText != null && buttonLink != null) ...[
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      launchURL(buttonLink);
                    },
                    child: Text(buttonText),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
