import 'package:Renewify/main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'map_page.dart';
import 'solarservices.dart';
import 'subsidies.dart';
import 'package:url_launcher/url_launcher.dart';
import 'biogas_services.dart';
import 'dashboard.dart';

class Market extends StatelessWidget {
  const Market({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade300,
        title: const Text('Contact Renewable Shops'),
        actions: [
          PopupMenuButton<String>(
            icon: FaIcon(FontAwesomeIcons.globe),
            onSelected: (String value) {
              if (value == 'en') {
                MyApp.of(context)!.setLocale(const Locale('en'));
              } else if (value == 'ta') {
                MyApp.of(context)!.setLocale(const Locale('ta'));
              } else if(value =='hi'){
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
              leading: const Icon(Icons.local_gas_station),
              title: const Text('Biogas'),
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
              leading: const Icon(Icons.electric_bolt),
              title: const Text('Electricity'),
            ),
            ListTile(
              leading: const Icon(Icons.update),
              title: const Text('Updates'),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Energy Market'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact the Energy Market Shops Near You!!',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 65, 200, 69)),
            ),
            const SizedBox(height: 20),
            _buildContactCenter(
              'SUNRISE POWERS SOLUTION',
              '1/2B, Mount Poonamallee Rd, Venugopal Nagar, Porur, Chennai, Tamil Nadu 600116',
              '9940037337',
              'sunrisepowersol@gmail.com',
              context,
            ),
            _buildContactCenter(
              'BSustain Energy Projects Pvt Ltd.,',
              'No: 1, Vadanoombal, main road, Perumalagaram, Thiruverkadu, Chennai, Tamil Nadu 600077',
              '9176650001',
              'bsustainenergypvt@gmail.com',
              context,
            ),
            _buildContactCenter(
              'Loom Solar Chennai Distributor & Dealer',
              '4, Gowthaman St, Pasumpon Nagar, Pammal, Chennai, Tamil Nadu 600075',
              '7200262046',
              'loomsolardealer@gmail.com',
              context,
            ),
            _buildContactCenter(
              'Eco Power Technologies',
              '100/5 & 100/2, Vellala St, Bharathi Nagar, Ayanavaram, Chennai, Tamil Nadu 600023',
              '9445512876',
              'ecopowertech@gmail.com',
              context,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCenter(String name, String address, String phone,
      String email, BuildContext context) {
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
                icon: Icons.location_on,
                tooltip: address,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapPage(),
                    ),
                  );
                },
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