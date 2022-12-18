import 'package:flutter/material.dart';
import 'package:project_cut/database/db.dart';
import 'package:project_cut/model/biometric.dart';
import 'package:project_cut/model/cycle.dart';
import 'package:project_cut/model/week.dart';

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
  String _currentDateTime = DateTime.now().toString();
  double _sliderValue = -1;
  bool _newCut = true;

  List<Biometric> get biometrics => _biometrics;
  List<Week> get weeks => _weeks;
  Cycle get cycle => _cycle;

  double get currentWeight => _currentWeight;
  int get currentCalorieDeficit => _currentCalorieDeficit;
  double get currentWeightLoss => _currentWeightLoss;
  double get currentBodyFatGoal => _currentBodyFatGoal;
  double get currentWeightGoal => _currentWeightGoal;
  String get currentDateTime => _currentDateTime;
  double get sliderValue => _sliderValue;
  bool get newCut => _newCut;

  Future<void> setHomePageData() async {
    Biometric latestBiometric = await AppDatabase.db.getLatestBiometric();
    Week latestWeek = await AppDatabase.db.getWeekById(latestBiometric.weekId);
    _biometrics =
        await AppDatabase.db.getBiometricsForWeek(latestBiometric.weekId);
    _sliderValue = latestBiometric.weekId.toDouble();
    _weeks = await AppDatabase.db.getWeeks();
    _cycle = await AppDatabase.db.getCurrentCycle();
    _currentWeight = latestBiometric.currentWeight;
    _currentCalorieDeficit = latestWeek.calorieDeficit;
    _currentWeightLoss = latestWeek.weightLoss;
    _currentBodyFatGoal = latestWeek.bodyFatGoal;
    _currentWeightGoal = latestWeek.weightGoal;
    _currentDateTime = latestBiometric.dateTime;

    checkIfNewCut();

    notifyListeners();
  }

  Future<void> checkIfNewCut() async {
    Cycle latestCycle = await AppDatabase.db.getCurrentCycle();

    if (latestCycle.startWeight == 0) {
      _newCut = true;
    } else {
      _newCut = false;
    }

    notifyListeners();
  }

  Future<void> startNewCut() async {
    Cycle cycle = const Cycle(
      startWeight: 0,
      goalWeight: 0,
      startBodyFat: 0,
      goalBodyFat: 0,
      startDateTime: '2022-11-01 12:00:00.000000',
      endDateTime: '2022-11-10 12:00:00.000000',
    );
    await AppDatabase.db.insertCycle(cycle);
    _newCut = true;
    notifyListeners();
  }

  void setWeight(double weight) {
    _currentWeight = weight;
    notifyListeners();
  }

  Future<void> setSliderValue(double value) async {
    _sliderValue = value;
    _biometrics =
        await AppDatabase.db.getBiometricsForWeek(_sliderValue.toInt());
    notifyListeners();
  }

  Future<void> addWeight(double weight) async {
    await AppDatabase.db.addWeight(weight);
    Biometric latestBiometric = await AppDatabase.db.getLatestBiometric();
    _currentWeight = weight;
    _sliderValue = latestBiometric.weekId.toDouble();
    _biometrics =
        await AppDatabase.db.getBiometricsForWeek(latestBiometric.weekId);
    notifyListeners();
  }

  Future<void> testChangeWeight() async {
    Biometric bio = const Biometric(
        id: 3,
        weekId: 1,
        cycleId: 1,
        currentWeight: 85,
        bodyFat: 20,
        dateTime: '2022-11-30 00:00:00.000000',
        day: 3,
        estimated: 0);
    await AppDatabase.db.updateBiometric(bio);
    _currentWeight = 85;
    notifyListeners();
  }
}
