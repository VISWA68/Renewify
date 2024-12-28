import 'package:flutter/material.dart';

class Screen extends StatefulWidget {
  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Home Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTemperatureAndEnergyRow(),
              const SizedBox(height: 20),
              _buildQuickAccessRow(),
              const SizedBox(height: 20),
              _buildDeviceGrid(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTemperatureAndEnergyRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildInfoCard('30°C', 'Today', Icons.thermostat),
        _buildInfoCard('50 KWh', 'This Week', Icons.flash_on),
      ],
    );
  }

  Widget _buildInfoCard(String value, String label, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.green),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontSize: 24)),
                Text(label),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildQuickAccessIcon(Icons.wifi, 'WiFi'),
        _buildQuickAccessIcon(Icons.bolt, 'Usage'),
        _buildQuickAccessIcon(Icons.electric_car, 'Electric'),
        _buildQuickAccessIcon(Icons.music_note, 'Music'),
        _buildQuickAccessIcon(Icons.more_horiz, 'More'),
      ],
    );
  }

  Widget _buildQuickAccessIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 30, color: Colors.green),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }

  Widget _buildDeviceGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildDeviceCard('Living Room', 'Smart Lamp', 'Smart LED', true),
        _buildDeviceCard(
            'Bedroom', 'Air Conditioner', 'Smart Conditioner', false),
        _buildDeviceCard('Living Room', 'Router', 'Smart Router', true),
        _buildDeviceCard(
            'Main Door', 'Smart Key', 'Security Online Key', false),
        _buildDeviceCard('Bedroom', 'Air Purifier', 'Smart Purifier', true),
        _buildDeviceCard('Bedroom', 'Smart Fan', 'Smart Fan', false),
      ],
    );
  }

  Widget _buildDeviceCard(String room, String name, String type, bool isOn) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(room),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(type),
                  ],
                ),
                Switch(
                  value: isOn,
                  onChanged: (value) {
                    setState(() {
                      isOn = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}