import 'package:flutter/material.dart';

class thingstoknow extends StatelessWidget {
  const thingstoknow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double containerHeight = 220.0;
    final double containerMargin = 16.0;
    final double iconSize = 32.0;
    final double iconRadius = 40.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade100,
        elevation: 0,
        title: const Text(
          'THINGS TO KNOW',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.green),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.green),
            onPressed: () {
              // Handle profile action
            },
          ),
        ],
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
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.wb_sunny),
              title: const Text('Solar'),
              onTap: () {
                // Handle Solar navigation
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('Subsidies/Loans'),
              onTap: () {
                // Handle Subsidies/Loans navigation
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_gas_station),
              title: const Text('Biogas'),
              onTap: () {
                // Handle Biogas navigation
              },
            ),
            ListTile(
              leading: const Icon(Icons.electric_bolt),
              title: const Text('Electricity'),
              onTap: () {
                // Handle Electricity navigation
              },
            ),
            ListTile(
              leading: const Icon(Icons.update),
              title: const Text('Updates'),
              onTap: () {
                // Handle Updates navigation
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Energy Market'),
              onTap: () {
                // Handle Energy Market navigation
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Handle Settings navigation
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // Handle Logout navigation
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
              color: const Color.fromARGB(255, 193, 255, 114),
              icon: Icons.info,
              title: 'Cost of Solar Installation',
              text: 'The average cost of a solar installation today is between Rs.15,000 to Rs.20,000 per kilowatt, depending on the size of the system and other factors.',
              containerHeight: containerHeight,
              iconSize: iconSize,
              iconRadius: iconRadius,
              containerMargin: containerMargin,
            ),
            _buildContainer(
              color: Color.fromARGB(235, 156, 252, 115),
              icon: Icons.warning,
              title: 'Subsidies for Solar Installations',
              text: 'Subsidies for solar installations can cover up to 30% of the total cost, depending on the state and the specific program.',
              containerHeight: containerHeight,
              iconSize: iconSize,
              iconRadius: iconRadius,
              containerMargin: containerMargin,
            ),
            _buildContainer(
              color: const Color.fromARGB(255, 193, 255, 114),
              icon: Icons.help,
              title: 'Payback Period',
              text: 'The payback period for a solar installation can range from 3 to 7 years, depending on the cost of electricity and the amount of sunlight your location receives.',
              containerHeight: containerHeight,
              iconSize: iconSize,
              iconRadius: iconRadius,
              containerMargin: containerMargin,
            ),
            _buildContainer(
              color: const Color.fromARGB(255, 162, 241, 129),
              icon: Icons.check_circle,
              title: 'Financing Options',
              text: 'Financing options for solar installations include loans, leases, and power purchase agreements (PPAs), which can help reduce the upfront cost.',
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
