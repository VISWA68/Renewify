import 'package:flutter/material.dart';

class PredictionProvider with ChangeNotifier {
  double? _predictedEnergyOutput;

  double? get predictedEnergyOutput => _predictedEnergyOutput;

  void setPredictedEnergyOutput(double value) {
    _predictedEnergyOutput = value;
    notifyListeners();
  }
}
