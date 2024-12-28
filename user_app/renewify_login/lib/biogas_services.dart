import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:renewify_login/gen_l10n/app_localizations.dart';

import 'package:url_launcher/url_launcher.dart';
import 'biomonitor.dart';
import 'center_biogas.dart';
import 'dashboard.dart';
import 'main.dart';
import 'monitoring.dart';
import 'post_view_page.dart';
import 'requirement.dart';
import 'settings.dart';
import 'shop.dart';
import 'solarservices.dart';
import 'subsidies.dart';

class BiogasServices extends StatefulWidget {
  const BiogasServices({Key? key}) : super(key: key);

  @override
  _BiogasServicesState createState() => _BiogasServicesState();
}

class _BiogasServicesState extends State<BiogasServices> {
  late PageController _pageController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_pageController.page == 3) {
        _pageController.animateToPage(
          0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      } else {
        _pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade300,
        title: Text(AppLocalizations.of(context)!.bio_service),
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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SizedBox(
            height: 200,
            child: PageView(
              controller: _pageController,
              children: [
                _buildPageViewItem('assets/images/carb1.png'),
                _buildPageViewItem('assets/images/carb2.png'),
                _buildPageViewItem('assets/images/carb3.png'),
                _buildPageViewItem('assets/images/carb4.png'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: _buildPageIndicator(_pageController, 4),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 4,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            children: [
              _buildServiceItem(
                AppLocalizations.of(context)!.required,
                Icons.note_alt,
                context,
                onTap: () {},
              ),
              _buildServiceItem(
                AppLocalizations.of(context)!.ar_view,
                Icons.view_in_ar,
                context,
                url: 'https://playcanv.as/b/ddc5934c',
                onTap: () {},
              ),
              _buildServiceItem(
                AppLocalizations.of(context)!.bio_monitor,
                Icons.monitor,
                context,
                onTap: () {},
              ),
              _buildServiceItem(
                AppLocalizations.of(context)!.bio_contact,
                Icons.call,
                context,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageViewItem(String imagePath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildPageIndicator(PageController controller, int itemCount) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            double selectedness = Curves.easeOut.transform(
              max(
                0.0,
                1.0 - (controller.page! - index).abs(),
              ),
            );
            double zoom = 1.0 + (selectedness * 0.5);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              width: 8.0 * zoom,
              height: 8.0 * zoom,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildServiceItem(String title, IconData icon, BuildContext context,
      {String? url, required Null Function() onTap}) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () async {
          // Handle navigation
          if (url != null) {
            bool? result = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(AppLocalizations.of(context)!.ar_pop),
                  content: Text(
                      AppLocalizations.of(context)!.pop_content),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text(AppLocalizations.of(context)!.cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text(AppLocalizations.of(context)!.ok),
                    ),
                  ],
                );
              },
            );
            if (result == true && await canLaunch(url)) {
              await launch(url);
            }
          } else {
            switch (title) {
              case 'Requirement Criteria':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RequirementPage(),
                  ),
                );

                break;
              case 'Monitor':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MonitorBiogasPage(),
                  ),
                );
                break;
              case 'Contact BioGas centers':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BiogasCenters(),
                  ),
                );
                // Implement navigation for Contact BioGas centers
                break;
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0), // Added padding
                child: Icon(
                  icon,
                  size: 50,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
