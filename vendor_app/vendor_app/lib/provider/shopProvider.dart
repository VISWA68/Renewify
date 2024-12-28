import 'package:flutter/material.dart';

class ShopProvider with ChangeNotifier {
  String? _shopId;

  // Getter for sellerId
  String? get shopId => _shopId;

  // Setter for sellerId
  set shopId(String? newId) {
    _shopId = newId;
    notifyListeners();
  }
}
