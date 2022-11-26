import 'package:flutter/material.dart';
import 'package:project_cut/database/db.dart';
import 'package:project_cut/model/biometric.dart';
import 'package:project_cut/model/cycle.dart';
import 'package:project_cut/model/week.dart';

class BiometricsHistoryController with ChangeNotifier {
  List<Biometric> biometrics = [];
  List<Week> weeks = [];
  Cycle cycle = const Cycle(
      startWeight: 0,
      goalWeight: 0,
      startBodyFat: 0,
      goalBodyFat: 0,
      startDateTime: '0',
      endDateTime: '0');

  double sliderValue = -1;

  Future<List<Biometric>> get getBiometrics async {
    biometrics = await AppDatabase.db.getBiometrics();
    return biometrics;
  }

  Future<List<Week>> get getWeeks async {
    weeks = await AppDatabase.db.getWeeks();
    return weeks;
  }

  Future<Cycle> get getCycle async {
    cycle = await AppDatabase.db.getCurrentCycle();
    return cycle;
  }

  void setSliderValue(double value) {
    sliderValue = value;
    notifyListeners();
  }

  double get getSliderValue {
    return sliderValue;
  }
}
