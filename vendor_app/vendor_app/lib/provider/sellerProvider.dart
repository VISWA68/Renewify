import 'package:flutter/material.dart';

class SellerProvider with ChangeNotifier {
  String? _sellerId;

  // Getter for sellerId
  String? get sellerId => _sellerId;

  // Setter for sellerId
  set sellerId(String? newId) {
    _sellerId = newId;
    notifyListeners();
  }
}
