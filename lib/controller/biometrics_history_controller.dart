import 'package:flutter/material.dart';
import 'package:project_cut/database/db.dart';
import 'package:project_cut/model/biometric.dart';

class BiometricsHistoryController with ChangeNotifier {
  List<Biometric> biometrics = [];

  Future<List<Biometric>> get getBiometrics async {
    biometrics = await AppDatabase.db.getBiometricsForWeek(1);
    return biometrics;
  }

  Future<void> setBiometrics() async {
    notifyListeners();
  }
}
