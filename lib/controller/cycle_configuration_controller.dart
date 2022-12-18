import 'dart:math';

import 'package:flutter/material.dart';
import 'package:project_cut/database/db.dart';
import 'package:project_cut/extensions/double.dart';
import 'package:project_cut/model/biometric.dart';
import 'package:project_cut/model/cycle.dart';
import 'package:project_cut/model/week.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CycleConfigurationController with ChangeNotifier {
  String _sex = 'MALE';
  int _age = 0;
  double _timeFrame = 0.0;
  double _startingWeight = 0;
  double _startingBodyFat = 0;
  double _goalBodyFat = 0;
  double _height = 0;
  double _neck = 0;
  double _waist = 0;
  double _hips = 0;
  double _estimatedBodyFatPercentage = 0;
  bool _expanded = false;

  String get sex => _sex;
  int get age => _age;
  double get timeFrame => _timeFrame;
  double get startingWeight => _startingWeight;
  double get startingBodyFat => _startingBodyFat;
  double get goalBodyFat => _goalBodyFat;
  double get height => _height;
  double get neck => _neck;
  double get waist => _waist;
  double get hips => _hips;
  double get estimatedBodyFatPercentage => _estimatedBodyFatPercentage;
  bool get expanded => _expanded;

  void setSex(String sex) {
    _sex = sex;
    notifyListeners();
  }

  void setAge(String age) {
    _age = int.parse(age);
  }

  void setTimeFrame(double timeFrame) {
    _timeFrame = timeFrame.roundToDouble();
    notifyListeners();
  }

  void setHeight(String height) {
    _height = double.parse(height);
  }

  void setNeck(String neck) {
    _neck = double.parse(neck);
  }

  void setWaist(String waist) {
    _waist = double.parse(waist);
  }

  void setHips(String hips) {
    _hips = double.parse(hips);
  }

  void addWeekToTimeFrame() {
    _timeFrame += 1;
    notifyListeners();
  }

  void removeWeekFromTimeFrame() {
    _timeFrame -= 1;
    notifyListeners();
  }

  void setStartingWeight(String startingWeight) {
    _startingWeight = double.parse(startingWeight);
  }

  void setStartingBodyFat(String startingBodyFat) {
    _startingBodyFat = double.parse(startingBodyFat);
  }

  void setGoalBodyFat(String goalBodyFat) {
    _goalBodyFat = double.parse(goalBodyFat);
  }

  double getWeightLossForWeek(double currentBF) {
    if (currentBF > 19) {
      return 1.4;
    } else if (currentBF > 18 && currentBF <= 19) {
      return 1.2;
    } else if (currentBF > 15 && currentBF <= 18) {
      return 1;
    } else if (currentBF > 12 && currentBF <= 15) {
      return 0.8;
    } else if (currentBF > 9 && currentBF <= 12) {
      return 0.5;
    } else {
      return 0.3;
    }
  }

  Future<void> estimateTimeFrame() async {
    _timeFrame = 0;

    double currentBF = _startingBodyFat;
    double currentWeight = _startingWeight;

    while (currentBF > _goalBodyFat) {
      double weightLossForWeek = getWeightLossForWeek(currentBF);
      currentWeight = (currentWeight - weightLossForWeek).toTwoDecimalPlaces();

      double equationWeight = currentWeight / _startingWeight;
      currentBF = (equationWeight - 1 + (_startingBodyFat / 100)) * 100;

      _timeFrame += 1;
    }

    // if (_timeFrame > 16) {
    //   _timeFrame = 16;
    // } else if (_timeFrame < 8) {
    //   _timeFrame = 8;
    // }

    notifyListeners();
  }

  Future<void> startCut(Cycle cycle) async {
    // get newly inserted cycle to retrieve ID
    List<Cycle> newCycle = await AppDatabase.db.getCycles();
    int cycleId = 1;

    if (newCycle.isNotEmpty) {
      cycleId = newCycle.last.id!;

      Cycle updateCycle = Cycle(
        id: cycleId,
        startWeight: cycle.startWeight,
        goalWeight: cycle.goalWeight,
        startBodyFat: cycle.startBodyFat,
        goalBodyFat: cycle.goalBodyFat,
        startDateTime: cycle.startDateTime,
        endDateTime: cycle.endDateTime,
      );
      // insert cycle
      await AppDatabase.db.updateCycle(updateCycle);
    } else {
      await AppDatabase.db.insertCycle(cycle);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentCycleId', cycleId);

    double currentBF = cycle.startBodyFat;
    double currentWeight = cycle.startWeight;

    int weekNum = 0;

    while (currentBF > _goalBodyFat) {
      double weightLossForWeek = getWeightLossForWeek(currentBF);
      currentWeight = (currentWeight - weightLossForWeek).toTwoDecimalPlaces();

      double equationWeight = currentWeight / _startingWeight;
      currentBF = (equationWeight - 1 + (_startingBodyFat / 100)) * 100;
      double calorieDeficit = 1100 * weightLossForWeek;
      int weekday = DateTime.now().weekday;

      if (weekNum == 0 && weekday != 7) {
        weightLossForWeek = (weightLossForWeek / 7) * (7 - weekday);
        currentBF = cycle.startBodyFat -
            (cycle.startBodyFat - currentBF) / 7 * (7 - weekday);
        calorieDeficit = (calorieDeficit / 7) * (7 - weekday);
        currentWeight =
            (cycle.startWeight - weightLossForWeek).toTwoDecimalPlaces();
      }

      Week week = Week(
        cycleId: cycleId,
        week: weekNum,
        calorieDeficit: calorieDeficit.toInt(),
        weightLoss: weightLossForWeek.toTwoDecimalPlaces(),
        weightGoal: currentWeight,
        bodyFatGoal: currentBF.toTwoDecimalPlaces(),
      );

      await AppDatabase.db.insertWeek(week);

      weekNum += 1;
    }

    List<Week> newWeek = await AppDatabase.db.getWeekListFromCycleId(cycleId);
    int weekId = newWeek.first.id!;
    final DateTime dateTime = DateTime.now();

    Biometric biometric = Biometric(
      weekId: weekId,
      cycleId: cycleId,
      currentWeight: cycle.startWeight,
      bodyFat: cycle.startBodyFat,
      dateTime: dateTime.toLocal().toString(),
      day: dateTime.weekday,
      estimated: 0,
    );

    await AppDatabase.db.insertBiometric(biometric);
  }

  void setExpanded() {
    if (_expanded) {
      _expanded = false;
    } else {
      _expanded = true;
    }

    notifyListeners();
  }

  double logBase(double x, int base) => log(x) / log(base);

  void calculateBodyFatPercentage() {
    _estimatedBodyFatPercentage = (495 /
                (1.0324 -
                    0.19077 * logBase((_waist + _hips - _neck), 10) +
                    0.15456 * logBase(_height, 10)) -
            450)
        .toTwoDecimalPlaces();
    _startingBodyFat = _estimatedBodyFatPercentage;
    notifyListeners();
  }
}
