import 'package:flutter/material.dart';

class PredictionProvider with ChangeNotifier {
  double? _predictedEnergyOutput;

  // Getter for predicted energy output
  double? get predictedEnergyOutput => _predictedEnergyOutput;

  // Setter for predicted energy output
  void setPredictedEnergyOutput(double value) {
    _predictedEnergyOutput = value;
    notifyListeners();
  }
}