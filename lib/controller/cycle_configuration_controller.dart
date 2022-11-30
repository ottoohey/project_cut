import 'package:flutter/material.dart';
import 'package:project_cut/database/db.dart';
import 'package:project_cut/extensions/double.dart';
import 'package:project_cut/model/biometric.dart';
import 'package:project_cut/model/cycle.dart';
import 'package:project_cut/model/week.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CycleConfigurationController with ChangeNotifier {
  String sex = 'MALE';
  double timeFrame = 0.0;
  double startingWeight = 0;
  double startingBodyFat = 0;
  double goalBodyFat = 0;
  int totalWeeks = 0;

  String get getSex {
    return sex;
  }

  void setSex(String value) {
    sex = value;
    notifyListeners();
  }

  double get getTimeFrame {
    return timeFrame;
  }

  void setTimeFrame(double value) {
    timeFrame = value.roundToDouble();
    notifyListeners();
  }

  void addWeekToTimeFrame() {
    timeFrame += 1;
    notifyListeners();
  }

  void removeWeekFromTimeFrame() {
    timeFrame -= 1;
    notifyListeners();
  }

  void setStartingWeight(double weight) {
    startingWeight = weight;
  }

  void setStartingBodyFat(double bodyFat) {
    startingBodyFat = bodyFat;
  }

  void setGoalBodyFat(double bodyFat) {
    goalBodyFat = bodyFat;
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
    timeFrame = 0;

    double currentBF = startingBodyFat;
    double currentWeight = startingWeight;

    while (currentBF > goalBodyFat) {
      double weightLossForWeek = getWeightLossForWeek(currentBF);
      currentWeight = (currentWeight - weightLossForWeek).toTwoDecimalPlaces();

      double equationWeight = currentWeight / startingWeight;
      currentBF = (equationWeight - 1 + (startingBodyFat / 100)) * 100;

      timeFrame += 1;
    }

    if (timeFrame > 16) {
      timeFrame = 16;
    } else if (timeFrame < 8) {
      timeFrame = 8;
    }

    notifyListeners();
  }

  Future<void> startCut(Cycle cycle) async {
    // insert cycle
    await AppDatabase.db.insertCycle(cycle);

    // get newly inserted cycle to retrieve ID
    List<Cycle> newCycle = await AppDatabase.db.getCycles();
    // int cycleId = 0;
    int cycleId = newCycle[0].id!;
    double currentBF = cycle.startBodyFat;
    double currentWeight = cycle.startWeight;

    int weekNum = 0;

    while (currentBF > goalBodyFat) {
      double weightLossForWeek = getWeightLossForWeek(currentBF);
      currentWeight = (currentWeight - weightLossForWeek).toTwoDecimalPlaces();

      double equationWeight = currentWeight / startingWeight;
      currentBF = (equationWeight - 1 + (startingBodyFat / 100)) * 100;
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
    // int weekId = 0;
    int weekId = newWeek.first.id!;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
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
}
