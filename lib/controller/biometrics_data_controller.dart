import 'package:flutter/material.dart';
import 'package:project_cut/database/db.dart';
import 'package:project_cut/model/biometric.dart';
import 'package:project_cut/model/cycle.dart';
import 'package:project_cut/model/week.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricsDataController with ChangeNotifier {
  List<Biometric> _biometrics = [];
  List<Week> _weeks = [];
  Cycle _cycle = const Cycle(
      startWeight: 0,
      goalWeight: 0,
      startBodyFat: 0,
      goalBodyFat: 0,
      startDateTime: '0',
      endDateTime: '0');
  double _currentWeight = 0;
  int _currentCalorieDeficit = 0;
  double _currentWeightLoss = 0;
  double _currentBodyFatGoal = 0;
  double _currentWeightGoal = 0;

  double sliderValue = -1;

  List<Biometric> get biometrics => _biometrics;

  List<Week> get weeks => _weeks;

  Cycle get cycle => _cycle;

  double get currentWeight => _currentWeight;
  int get currentCalorieDeficit => _currentCalorieDeficit;
  double get currentWeightLoss => _currentWeightLoss;
  double get currentBodyFatGoal => _currentBodyFatGoal;
  double get currentWeightGoal => _currentWeightGoal;

  Future<void> setHomePageData() async {
    Biometric latestBiometric = await AppDatabase.db.getLatestBiometric();
    Week latestWeek = await AppDatabase.db.getWeekById(latestBiometric.weekId);
    _currentWeight = latestBiometric.currentWeight;
    _currentCalorieDeficit = latestWeek.calorieDeficit;
    _currentWeightLoss = latestWeek.weightLoss;
    _currentBodyFatGoal = latestWeek.bodyFatGoal;
    _currentWeightGoal = latestWeek.weightGoal;
    notifyListeners();
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
    _currentWeight = weight;
    notifyListeners();
  }

  Future<void> updateGraphData() async {
    _biometrics = await AppDatabase.db.getBiometrics();
    _weeks = await AppDatabase.db.getWeeks();
    _cycle = await AppDatabase.db.getCurrentCycle();

    notifyListeners();
  }
}
