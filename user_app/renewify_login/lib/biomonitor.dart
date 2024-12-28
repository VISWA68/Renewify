import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'biogas_services.dart';
import 'main.dart';
import 'monitoring.dart';
import 'post_view_page.dart';
import 'settings.dart';
import 'shop.dart';
import 'subsidies.dart';
import 'dashboard.dart';
import 'solarservices.dart';
import 'package:Renewify/gen_l10n/app_localizations.dart';

class MonitorBiogasPage extends StatefulWidget {
  @override
  _MonitorBiogasPageState createState() => _MonitorBiogasPageState();
}

class _MonitorBiogasPageState extends State<MonitorBiogasPage> {
  double bioGasWeight = 20.0; // Sample input weight for Bio Gas (in kg)
  double lpgGasWeight = 6; // Sample input weight for LPG Gas (in kg)
  final double maxWeight = 25.0; // Maximum weight of a full cylinder (in kg)
  bool hasBioGas = true; // Assume user has Bio Gas by default
  bool hasLpgGas = true; // Assume user has LPG Gas by default

  @override
  Widget build(BuildContext context) {
    double bioGasPercentage = (bioGasWeight / maxWeight) * 100;
    double lpgGasPercentage = (lpgGasWeight / maxWeight) * 100;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade300,
        title: Text('Biogas Monitoring'),
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
              title: Text(AppLocalizations.of(context)!.home),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.wb_sunny),
              title: Text(AppLocalizations.of(context)!.solar),
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
              title: Text(AppLocalizations.of(context)!.subl),
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
              title: Text(AppLocalizations.of(context)!.bio),
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
              title: Text(AppLocalizations.of(context)!.ele),
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
              title: Text(AppLocalizations.of(context)!.green),
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
              title: Text(AppLocalizations.of(context)!.energy),
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
              title: Text(AppLocalizations.of(context)!.set),
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
              title: Text(AppLocalizations.of(context)!.logout),
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Handle button action
                },
                child:  Text(AppLocalizations.of(context)!.find),
              ),
              const SizedBox(height: 20),
              buildGasLevelContainer(
                context,
                AppLocalizations.of(context)!.biogas,
                Icons.eco, // Cylinder icon for Bio Gas
                bioGasPercentage,
                hasBioGas,
              ),
              const SizedBox(height: 20),
              buildGasLevelContainer(
                context,
                AppLocalizations.of(context)!.lpg,
                FontAwesomeIcons.fire, // Cylinder icon for LPG Gas
                lpgGasPercentage,
                hasLpgGas,
              ),
              const SizedBox(height: 20),
              buildGasLeakContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGasLevelContainer(BuildContext context, String title,
      IconData iconData, double percentage, bool isEnabled) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isEnabled ? Colors.white : Colors.grey[300],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                iconData,
                size: 50,
                color: isEnabled ? Colors.green : Colors.grey,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: Colors.grey[300],
                      color: Colors.green,
                      minHeight: 20,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildGasLeakContainer() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppLocalizations.of(context)!.gas,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
           Text(
            AppLocalizations.of(context)!.add,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
           Text(
            AppLocalizations.of(context)!.num1,
            style: TextStyle(
              fontSize: 14,
              color: Colors.red,
            ),
          ),
           Text(
            AppLocalizations.of(context)!.num2,
            style: TextStyle(
              fontSize: 14,
              color: Colors.red,
            ),
          ),
           Text(
            AppLocalizations.of(context)!.num3,
            style: TextStyle(
              fontSize: 14,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
