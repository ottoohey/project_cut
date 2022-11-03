import 'package:flutter/material.dart';

class CycleConfigurationController with ChangeNotifier {
  String height = '';
  String age = '';
  String startingWeight = '';
  String goalWeight = '';
  String startingBodyfat = '';
  String goalBodyfat = '';

  String get getHeight {
    return height;
  }

  void setHeight(String value) {
    height = value;
    notifyListeners();
  }

  String get getAge {
    return age;
  }

  void setAge(String value) {
    age = value;
    notifyListeners();
  }

  String get getStartingWeight {
    return startingWeight;
  }

  void setStartingWeight(String value) {
    startingWeight = value;
    notifyListeners();
  }

  String get getGoalWeight {
    return goalWeight;
  }

  void setGoalWeight(String value) {
    goalWeight = value;
    notifyListeners();
  }

  String get getStartingBodyfat {
    return startingBodyfat;
  }

  void setStartingBodyfat(String value) {
    startingBodyfat = value;
    notifyListeners();
  }

  String get getGoalBodyfat {
    return goalBodyfat;
  }

  void setGoalBodyFat(String value) {
    goalBodyfat = value;
    notifyListeners();
  }
}
