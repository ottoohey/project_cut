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

  var testValue = 0;

  List<Biometric> get getBiometrics {
    return biometrics;
  }

  List<Week> get getWeeks {
    return weeks;
  }

  Cycle get getCycle {
    return cycle;
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
    notifyListeners();
  }

  Future<void> updateGraphData() async {
    biometrics = await AppDatabase.db.getBiometrics();
    weeks = await AppDatabase.db.getWeeks();
    cycle = await AppDatabase.db.getCurrentCycle();

    notifyListeners();
  }

  Future<void> addTestBiometric() async {
    var bio = Biometric(
        id: 11,
        weekId: 1,
        cycleId: 1,
        currentWeight: 85,
        bodyFat: 1,
        dateTime: '2022-11-27 00:00:00.000',
        day: 7,
        estimated: 0);

    await AppDatabase.db.updateBiometric(bio);

    biometrics = await AppDatabase.db.getBiometricsForWeek(1);

    notifyListeners();
  }

  Future<void> updateTestValue() async {
    var pickUpLocation =
        await Future.delayed(Duration(seconds: 2)); // Request mock

    testValue += 1;

    notifyListeners();
  }

  get getTestValue {
    return testValue;
  }
}
