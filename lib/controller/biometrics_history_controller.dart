import 'package:flutter/material.dart';
import 'package:project_cut/database/db.dart';
import 'package:project_cut/model/biometric.dart';
import 'package:project_cut/model/cycle.dart';
import 'package:project_cut/model/week.dart';

class BiometricsHistoryController with ChangeNotifier {
  List<Biometric> biometrics = [];
  List<Week> weeks = [];
  List<Cycle> cycles = [];

  double sliderValue = 0;

  Future<List<Biometric>> get getBiometrics async {
    biometrics = await AppDatabase.db.getBiometrics();
    return biometrics;
  }

  Future<List<Week>> get getWeeks async {
    weeks = await AppDatabase.db.getWeeks();
    return weeks;
  }

  Future<Cycle> get getCycle async {
    cycles = await AppDatabase.db.getCurrentCycle();
    return cycles[0];
  }

  Future<void> setSliderValue(double value) async {
    sliderValue = value;
    notifyListeners();
  }

  double get getSliderValue {
    return sliderValue;
  }

  List<Biometric> get getGraphData {
    biometrics = biometrics
        .where((element) => element.weekId == sliderValue + 1)
        .toList();

    biometrics.sort((a, b) => a.day.compareTo(b.day));

    return biometrics;
  }
}
