import 'package:Renewify/complaint.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'biogas_services.dart';
import 'dashboard.dart';
import 'main.dart';
import 'monitoring.dart';
import 'post_view_page.dart';
import 'settings.dart';
import 'shop.dart';
import 'dart:math';
import 'solarservices.dart';
import 'subsidies.dart';
import 'package:Renewify/gen_l10n/app_localizations.dart';

class DashBoard extends StatefulWidget {
  final String name;
  const DashBoard({Key? key, required this.name}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController _controller;
  late List<String>
    tutorialTexts = [
      AppLocalizations.of(context)!.tut1,
      AppLocalizations.of(context)!.tut2,
      AppLocalizations.of(context)!.tut3,
      AppLocalizations.of(context)!.tut4,
      AppLocalizations.of(context)!.tut5,
      AppLocalizations.of(context)!.tut6,
      AppLocalizations.of(context)!.tut7,
    ];
  final List<GlobalKey> containerKeys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];
  int currentTutorialIndex = 0;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    );
    _controller.repeat();

    animation = Tween<double>(begin: -400, end: 0).animate(_controller);
    animation.addListener(() {
      setState(() {});
    });

    // // In
    // //itialize the tutorialTexts inside initState
    // void didChangeDependencies() {
    // super.didChangeDependencies();
    // tutorialTexts = [
    //   AppLocalizations.of(context)!.tut1,
    //   AppLocalizations.of(context)!.tut2,
    //   AppLocalizations.of(context)!.tut3,
    //   AppLocalizations.of(context)!.tut4,
    //   AppLocalizations.of(context)!.tut5,
    //   AppLocalizations.of(context)!.tut6,
    //   AppLocalizations.of(context)!.tut7,
    // ];
    // }

    // Show the first tutorial alert when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showTutorialOverlay();
    });
  }


  void _showTutorialOverlay() {
    if (currentTutorialIndex >= tutorialTexts.length) return;

    RenderBox? renderBox = containerKeys[currentTutorialIndex]
        .currentContext
        ?.findRenderObject() as RenderBox?;
    Offset? containerPosition = renderBox?.localToGlobal(Offset.zero);
    Size screenSize = MediaQuery.of(context).size;

    if (containerPosition != null) {
      _removeExistingOverlay();

      _overlayEntry = OverlayEntry(
        builder: (context) {
          final double maxWidth = screenSize.width * 0.8; // 80% of screen width
          final double maxHeight =
              screenSize.height * 0.6; // 60% of screen height

          final double overlayWidth = maxWidth;
          final double overlayHeight = min(
            maxHeight,
            MediaQuery.of(context).size.height - containerPosition.dy - 50,
          );

          final double leftPosition =
              (containerPosition.dx + (renderBox?.size.width ?? 0) / 2) -
                  (overlayWidth / 2);
          final double topPosition = containerPosition.dy + 50;

          return Positioned(
            top: topPosition.clamp(0.0, screenSize.height - overlayHeight),
            left: leftPosition.clamp(0.0, screenSize.width - overlayWidth),
            width: overlayWidth,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 10)],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize:
                        MainAxisSize.min, // Minimize size to fit content
                    children: [
                      Text(AppLocalizations.of(context)!.tutorial,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text(
                        tutorialTexts[currentTutorialIndex],
                        style: TextStyle(
                            fontSize: 14), // Adjust text size to fit content
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            child: Text(AppLocalizations.of(context)!.ok),
                            onPressed: () {
                              setState(() {
                                currentTutorialIndex++;
                              });
                              _removeExistingOverlay();
                              _showTutorialOverlay();
                            },
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            child: Text(AppLocalizations.of(context)!.skip),
                            onPressed: () {
                              setState(() {
                                currentTutorialIndex++;
                              });
                              _removeExistingOverlay();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );

      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  void _removeExistingOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _controller.dispose();
    _removeExistingOverlay(); // Remove overlay when disposing
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        AppLocalizations.of(context)!.renew,
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
                    builder: (context) =>  ComplaintPage(),
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
      appBar: AppBar(
        backgroundColor: Colors.green.shade300,
        elevation: 0,
        title: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.name, // Use the passed name here
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.power,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
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
      body: Stack(
        children: [
          // Animated wave background
          Positioned(
            bottom: 0,
            right: animation.value,
            child: ClipPath(
              clipper: MyWaveClipper(),
              child: Opacity(
                opacity: 0.5,
                child: Container(
                  color: Colors.green.shade200,
                  width: 700,
                  height: 200,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: animation.value,
            child: ClipPath(
              clipper: MyWaveClipper(),
              child: Opacity(
                opacity: 0.5,
                child: Container(
                  color: Colors.green.shade200,
                  width: 700,
                  height: 200,
                ),
              ),
            ),
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.only(top: 58.0, left: 18.0, right: 18.0, bottom:18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: <Widget>[
                      DashboardItem(
                        key: containerKeys[0],
                        title: AppLocalizations.of(context)!.solar,
                        icon: Icons.wb_sunny,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SolarServices(),
                            ),
                          );
                        },
                      ),
                      DashboardItem(
                        key: containerKeys[1],
                        title: AppLocalizations.of(context)!.subl,
                        icon: Icons.attach_money,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SubsidiesPage(),
                            ),
                          );
                        },
                      ),
                      DashboardItem(
                        key: containerKeys[2],
                        title: AppLocalizations.of(context)!.complaint,
                        icon: Icons.warning_rounded,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  ComplaintPage(),
                            ),
                          );
                        },
                      ),
                      DashboardItem(
                        key: containerKeys[3],
                        title: AppLocalizations.of(context)!.ele,
                        icon: Icons.electric_bolt,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SolarElectricityMonitoringPage()),
                          );
                        },
                      ),
                      DashboardItem(
                        key: containerKeys[4],
                        title: AppLocalizations.of(context)!.green,
                        icon: Icons.podcasts,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PostViewPage()),
                          );
                        },
                      ),
                      DashboardItem(
                        key: containerKeys[5],
                        title: AppLocalizations.of(context)!.energy,
                        icon: Icons.shopping_cart,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ShopPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const DashboardItem({
    Key? key,
    required this.title,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.green,
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Clipper for the wave
class MyWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, 40.0);
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 40.0);

    // Create Bezier Curve waves
    for (int i = 0; i < 10; i++) {
      if (i % 2 == 0) {
        path.quadraticBezierTo(
            size.width - (size.width / 16) - (i * size.width / 8),
            0.0,
            size.width - ((i + 1) * size.width / 8),
            size.height - 160);
      } else {
        path.quadraticBezierTo(
            size.width - (size.width / 16) - (i * size.width / 8),
            size.height - 120,
            size.width - ((i + 1) * size.width / 8),
            size.height - 160);
      }
    }

    path.lineTo(0.0, 40.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
