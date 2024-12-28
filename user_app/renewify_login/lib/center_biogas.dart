import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:url_launcher/url_launcher.dart';
import 'biogas_services.dart';
import 'dashboard.dart';
import 'main.dart';
import 'monitoring.dart';
import 'post_view_page.dart';
import 'settings.dart';
import 'shop.dart';
import 'solarservices.dart';
import 'subsidies.dart';

class BiogasCenters extends StatelessWidget {
  const BiogasCenters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade300,
        title: Text('Solar Services'),
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
              title: Text('Installation Centers'),
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
              leading: Icon(Icons.local_gas_station),
              title: Text('Biogas'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BiogasServices(),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'CONTACT THE BIOGAS INSTALLATION CENTERS NEAR YOU!!',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            const SizedBox(height: 20),
            _buildContactCenter(
              'HRG Solutions',
              '1025,Balaji Chambers,E Ward Rajaram Road, Retteri, Chennai',
              '9674028382',
              'contacthomebiogas@gmail.com',
              'https://www.homebiogas.com',
            ),
            _buildContactCenter(
              'Diamond engineering enterprises',
              'No.122/38 Near Tondiarpet Market, Tondiarpet Chennai - 600081, Tamil Nadu, India',
              '8048600293',
              'Diamondenggchennai@gmail.com',
              'https://www.indiamart.com/diamond-engineering-enterprises',
            ),
            _buildContactCenter(
              'Flexi Balloon Biogas Plant',
              'No. 827, Nandgam, District Kheda, Taluka Mahudha, Ahmedabad-387335, Gujarat, India',
              '8047828100',
              'Balloonbiogas@gmail.com',
              'https://www.indiamart.com/flexiballoonbiogasplant-ahmedabad/?pid=12784349097&c_id=424&mid=121272&pn=Mini+Digester+1',
            ),
            _buildContactCenter(
              'ORCCI Eco Products',
              '1a 4, Monish Enclave, Sri Abinandhan Nagar, Nanmangalam, Chengalpattu, Nanmangalam Chennai - 600129, Tamil Nadu, India',
              '8043870034',
              'contactorcciecoprouduct@gmail.com',
              'https://www.indiamart.com/orcci-eco-products',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCenter(
      String name, String address, String phone, String email, String website) {
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
                icon: Icons.email,
                tooltip: email,
                onTap: () => _launchUrl('mailto:$email'),
              ),
              _buildIconButton(
                icon: Icons.link,
                onTap: () => _launchUrl(website),
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
}
