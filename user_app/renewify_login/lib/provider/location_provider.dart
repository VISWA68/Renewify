import 'package:flutter/foundation.dart';
import 'package:location/location.dart';

class LocationProvider extends ChangeNotifier {
  double? _latitude;
  double? _longitude;

  double? get latitude => _latitude;
  double? get longitude => _longitude;

  void updateLocation(double latitude, double longitude) {
    _latitude = latitude;
    _longitude = longitude;
    notifyListeners();
  }

  Future<void> fetchAndUpdateLocation() async {
    try {
      Location location = Location();

      // Check if location services are enabled
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          throw 'Location services are disabled.';
        }
      }

      // Check for location permissions
      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          throw 'Location permissions are denied.';
        }
      }

      // Get the current location
      LocationData locationData = await location.getLocation();
      _latitude = locationData.latitude;
      _longitude = locationData.longitude;

      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching location: $e');
    }
  }
}
