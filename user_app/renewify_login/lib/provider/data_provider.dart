import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';

class SolarBatteryProvider extends ChangeNotifier {
  // Data fields
  double batteryCurrent = 0.0;
  double batteryPercentage = 0.0;
  double batteryVoltage = 0.0;

  double solarPanel1Current = 0.0;
  double solarPanel1Voltage = 0.0;

  double solarPanel2Current = 0.0;
  double solarPanel2Voltage = 0.0;

  // Fetch data from Firebase
  void fetchData() {
    final databaseRef = FirebaseDatabase.instance.ref();

    databaseRef.child('solar_battery_data').onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;

      // Update battery data
      batteryCurrent = double.parse(data['battery']['current'].toString());
      batteryPercentage = double.parse(data['battery']['percentage'].toString());
      batteryVoltage = double.parse(data['battery']['voltage'].toString());

      // Update solar panel 1 data
      solarPanel1Current = double.parse(data['solar_panel_1']['current'].toString());
      solarPanel1Voltage = double.parse(data['solar_panel_1']['voltage'].toString());

      // Update solar panel 2 data
      solarPanel2Current = double.parse(data['solar_panel_2']['current'].toString());
      solarPanel2Voltage = double.parse(data['solar_panel_2']['voltage'].toString());

      // Notify listeners to update UI
      notifyListeners();
    });
  }
}
