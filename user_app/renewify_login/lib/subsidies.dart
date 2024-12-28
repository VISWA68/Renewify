// import 'package:Renewify/complaint.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
// // import 'biogas_services.dart';
// import 'dashboard.dart';
// import 'main.dart';
// import 'monitoring.dart';
// import 'post_view_page.dart';
// import 'settings.dart';
// import 'shop.dart';
// import 'solarservices.dart';
// import 'package:Renewify/gen_l10n/app_localizations.dart';

// class subsidies extends StatelessWidget {
//   const subsidies({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green.shade300,
//         title: Text('Financial Options'),
//         actions: [
//           PopupMenuButton<String>(
//             icon: FaIcon(FontAwesomeIcons.globe),
//             onSelected: (String value) {
//               if (value == 'en') {
//                 MyApp.of(context)!.setLocale(const Locale('en'));
//               } else if (value == 'ta') {
//                 MyApp.of(context)!.setLocale(const Locale('ta'));
//               } else if (value == 'hi') {
//                 MyApp.of(context)!.setLocale(const Locale('hi'));
//               }
//             },
//             itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//               const PopupMenuItem<String>(
//                 value: 'en',
//                 child: Text('English'),
//               ),
//               const PopupMenuItem<String>(
//                 value: 'ta',
//                 child: Text('Tamil'),
//               ),
//               const PopupMenuItem<String>(
//                 value: 'hi',
//                 child: Text('Hindi'),
//               ),
//             ],
//           ),
//         ],
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(12.0),
//           child: Padding(
//             padding: const EdgeInsets.only(top: 2.0),
//           ),
//         ),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.green,
//               ),
//               child: Padding(
//                 padding:
//                     const EdgeInsets.only(top: 15.0), // Adjust top padding here
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(builder: (context) => Dashboard()),
//                         );
//                       },
//                       child: Image.asset(
//                         'assets/images/logo1.png', // Replace with your logo path
//                         height: 40, // Adjust the height of the image
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(builder: (context) => Dashboard()),
//                         );
//                       },
//                       child: Text(
//                         'RENEWIFY',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 20, // Adjust the font size if needed
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.home),
//               title: Text(AppLocalizations.of(context)!.home),
//               onTap: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => Dashboard()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.wb_sunny),
//               title: Text(AppLocalizations.of(context)!.solar),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const SolarServices(),
//                   ),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.attach_money),
//               title: Text(AppLocalizations.of(context)!.subl),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const subsidies(),
//                   ),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.warning_rounded),
//               title: Text(AppLocalizations.of(context)!.complaint),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ComplaintPage(),
//                   ),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.electric_bolt),
//               title: Text(AppLocalizations.of(context)!.ele),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => SolarElectricityMonitoringPage()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.podcasts),
//               title: Text(AppLocalizations.of(context)!.green),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => PostViewPage(),
//                   ),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.shopping_cart),
//               title: Text(AppLocalizations.of(context)!.energy),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ShopPage()),
//                 );
//               },
//             ),
//             Divider(),
//             ListTile(
//               leading: Icon(Icons.settings),
//               title: Text(AppLocalizations.of(context)!.set),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => AccountSettingsPage()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.logout),
//               title: Text(AppLocalizations.of(context)!.logout),
//               onTap: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => HomeScreen()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(8.0),
//         children: [
//           const Padding(
//             padding: EdgeInsets.symmetric(vertical: 8.0),
//             child: Text(
//               'Solar',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           _buildSubsidyContainer(
//               context,
//               AppLocalizations.of(context)!.pm_surya,
//               AppLocalizations.of(context)!.sub,
//               'https://www.pmsuryaghar.gov.in/',
//               'assets/images/pradhan.png'),
//           _buildSubsidyContainer(
//               context,
//               AppLocalizations.of(context)!.urts,
//               AppLocalizations.of(context)!.solar_loan,
//               'https://www.unionbankofindia.co.in/english/urts.aspx',
//               'assets/images/union.png'),
//           _buildSubsidyContainer(
//               context,
//               AppLocalizations.of(context)!.sbi,
//               AppLocalizations.of(context)!.top_loan,
//               'https://sbi.co.in/web/personal-banking/loans/pm-surya-ghar-loan-for-solar-roof-top',
//               'assets/images/sbi.webp'),
//           _buildSubsidyContainer(
//               context,
//               AppLocalizations.of(context)!.cbi,
//               AppLocalizations.of(context)!.loan_amt,
//               'https://www.centralbankofindia.co.in/en/Roof-Top-Solar-Loan-Scheme',
//               'assets/images/central.jpg'),
        
//          ],
//       ),
//     );
//   }

//   Widget _buildSubsidyContainer(BuildContext context, String title,
//       String subtitle, String url, String logoPath) {
//     return Card(
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundImage: AssetImage(logoPath),
//           radius: 24,
//         ),
//         title: Text(title),
//         subtitle: Text(subtitle),
//         trailing: ElevatedButton(
//           onPressed: () async {
//             final Uri uri = Uri.parse(url);
//             if (await canLaunchUrl(uri)) {
//               await launchUrl(uri);
//             } else {
//               throw 'Could not launch $url';
//             }
//           },
//           style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//           child: const Text('View'),
//         ),
//       ),
//     );
//   }
// }


import 'package:Renewify/complaint.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dashboard.dart';
import 'main.dart';
import 'monitoring.dart';
import 'post_view_page.dart';
import 'settings.dart';
import 'shop.dart';
import 'solarservices.dart';
import 'package:Renewify/gen_l10n/app_localizations.dart';

class SubsidiesPage extends StatefulWidget {
  const SubsidiesPage({Key? key}) : super(key: key);

  @override
  _SubsidiesPageState createState() => _SubsidiesPageState();
}

class _SubsidiesPageState extends State<SubsidiesPage> {
  String selectedState = 'All States';

  @override
  Widget build(BuildContext context) {
  final Map<String, List<Map<String, String>>> statePolicies = {
    'All States': [
      {
        'title': 'PM Surya Ghar Yojana',
        'subtitle': 'Subsidy for rooftop solar panels',
        'url': 'https://www.pmsuryaghar.gov.in/',
        'logoPath': 'assets/images/pradhan.png',
      },
      {
        'title': 'Union Bank Solar Loan',
        'subtitle': 'Loan for solar installations',
        'url': 'https://www.unionbankofindia.co.in/english/urts.aspx',
        'logoPath': 'assets/images/union.png',
      },
      {
        'title': 'SBI Solar Loan',
        'subtitle': 'Top-up loan for solar energy',
        'url': 'https://sbi.co.in/web/personal-banking/loans/pm-surya-ghar-loan-for-solar-roof-top',
        'logoPath': 'assets/images/sbi.webp',
      },
      {
        'title': 'Central Bank Solar Loan',
        'subtitle': 'Loan amount for rooftop solar',
        'url': 'https://www.centralbankofindia.co.in/en/Roof-Top-Solar-Loan-Scheme',
        'logoPath': 'assets/images/central.jpg',
      },
    ],
    'Tamil Nadu': [
      {
        'title': 'PM Surya Ghar Yojana',
        'subtitle': 'Subsidy for rooftop solar panels',
        'url': 'https://www.pmsuryaghar.gov.in/',
        'logoPath': 'assets/images/pradhan.png',
      },
      {
        'title': 'Tamil Nadu Solar Energy Scheme',
        'subtitle': 'promotes both utility-scale and rooftop solar installations.',
        'url': 'https://tidco.com/wp-content/uploads/2020/04/tamil-nadu-solar-policy-2019-min.pdf',
        'logoPath': 'assets/images/tneb.jpg',
      },
      {
        'title': 'TANGEDCO Solar Scheme',
        'subtitle': 'Support for residential solar power',
        'url': 'https://www.tnebltd.gov.in/usrp/',
        'logoPath': 'assets/images/tneb.jpg',
      },
       
    ],
    'Gujarat': [
       {
        'title': 'PM Surya Ghar Yojana',
        'subtitle': 'Subsidy for rooftop solar panels',
        'url': 'https://www.pmsuryaghar.gov.in/',
        'logoPath': 'assets/images/pradhan.png',
      },

      {
        'title': 'Gujarat Solar Power Subsidy',
        'subtitle': 'State subsidy for solar projects',
        'url': 'https://suryagujarat.guvnl.in/',
        'logoPath': 'assets/images/gujarat.jpg',
      },
      {
        'title': 'Surya Urja Gujarat Scheme',
        'subtitle': 'Promotion of renewable energy',
        'url': 'https://guj-epd.gujarat.gov.in/Home/gujaratsolarpowerpolicy',
        'logoPath': 'assets/images/gujarat.jpg',
      },
    ],
    'Karnataka': [
       {
        'title': 'PM Surya Ghar Yojana',
        'subtitle': 'Subsidy for rooftop solar panels',
        'url': 'https://www.pmsuryaghar.gov.in/',
        'logoPath': 'assets/images/pradhan.png',
      },
      {
        'title': 'Karnataka Solar Rooftop Scheme',
        'subtitle': 'Support for rooftop solar power',
        'url': 'https://kredl.karnataka.gov.in/storage/pdf-files/Policies/KarnatakaRenewableEnergyPolicy2022-27-NEW.pdf',
        'logoPath': 'assets/images/kredl.jpg',
      },
      {
        'title': 'BESCOM Solar Initiative',
        'subtitle': 'Subsidy for grid-connected solar',
        'url': 'https://kredl.karnataka.gov.in/page/General+Information/Policies/en',
        'logoPath': 'assets/images/kredl.jpg',
      },
    ],
  };

  
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade300,
        title: Text('Financial Options'),
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
              leading: Icon(Icons.warning_rounded),
              title: Text(AppLocalizations.of(context)!.complaint),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedState,
              isExpanded: true,
              items: statePolicies.keys.map((String state) {
                return DropdownMenuItem<String>(
                  value: state,
                  child: Text(state),
                );
              }).toList(),
              onChanged: (String? newState) {
                setState(() {
                  selectedState = newState!;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: statePolicies[selectedState]!.length,
              itemBuilder: (context, index) {
                final policy = statePolicies[selectedState]![index];
                return _buildSubsidyContainer(
                  context,
                  policy['title']!,
                  policy['subtitle']!,
                  policy['url']!,
                  policy['logoPath']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  

  Widget _buildSubsidyContainer(BuildContext context, String title,
      String subtitle, String url, String logoPath) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(logoPath),
          radius: 24,
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: ElevatedButton(
          onPressed: () async {
            final Uri uri = Uri.parse(url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            } else {
              throw 'Could not launch $url';
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: const Text('View'),
        ),
      ),
    );
  }
}
