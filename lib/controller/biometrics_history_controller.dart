import 'package:flutter/material.dart';
import 'package:project_cut/database/db.dart';
import 'package:project_cut/model/biometric.dart';
import 'package:project_cut/model/cycle.dart';
import 'package:project_cut/model/week.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  double currentWeight = 0;

  List<Biometric> get getBiometrics {
    return biometrics;
  }

  List<Week> get getWeeks {
    return weeks;
  }

  Cycle get getCycle {
    return cycle;
  }

  double get getCurrentWeight {
    return currentWeight;
  }

  void setCurrentWeight() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    currentWeight = sharedPreferences.getDouble('currentWeight')!;
  }

  void setSliderValue(double value) {
    sliderValue = value;
    notifyListeners();
  }

  double get getSliderValue {
    return sliderValue;
  }

  Future<void> addWeight(double weight) async {
    await AppDatabase.db.addWeight(weight);
    biometrics = await AppDatabase.db.getBiometrics();
    currentWeight = weight;
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setDouble('currentWeight', weight);
    notifyListeners();
  }

  Future<void> updateGraphData() async {
    biometrics = await AppDatabase.db.getBiometrics();
    weeks = await AppDatabase.db.getWeeks();
    cycle = await AppDatabase.db.getCurrentCycle();

    notifyListeners();
  }
}
