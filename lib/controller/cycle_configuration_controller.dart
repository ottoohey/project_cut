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

  void newStartCut() {
    // insert cycle
    // await AppDatabase.db.insertCycle(cycle);

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
    int cycleId = newCycle[0].id!;
    DateTime startDateTime = DateTime.parse(cycle.startDateTime);
    DateTime endDateTime = DateTime.parse(cycle.endDateTime);

    int totalDays = endDateTime.difference(startDateTime).inDays;

    double bodyFatLossTotal = cycle.startBodyFat - cycle.goalBodyFat;
    double bodyFatLossDaily = bodyFatLossTotal / totalDays;

    double bodyFatGoal = 0;
    double previousWeight = cycle.startWeight;
    double leanWeight =
        previousWeight - (previousWeight * (cycle.startBodyFat / 100));

    // for each week, calculate:
    // bodyFatGoal --> % of bodyfat to lose that week
    // weightGoal --> weight goal for that week
    // weightLoss --> how much weight to aim to lose that week
    // calorieDeficit --> how many calories to be in deficit per day
    for (var weekNum = 0; weekNum < totalDays / 7; weekNum++) {
      if (weekNum == 0) {
        bodyFatGoal += bodyFatLossDaily * (totalDays % 7);
      } else {
        bodyFatGoal += bodyFatLossDaily * 7;
      }
      double weightGoal =
          leanWeight / (1 - ((cycle.startBodyFat / 100) - (bodyFatGoal / 100)));
      double weightLoss = previousWeight - weightGoal;

      int calorieDeficit = (weightLoss * 1000).toInt();

      Week week = Week(
        cycleId: cycleId,
        week: weekNum,
        calorieDeficit: calorieDeficit,
        weightLoss: weightLoss.toTwoDecimalPlaces(),
        weightGoal: weightGoal.toTwoDecimalPlaces(),
        bodyFatGoal: (cycle.startBodyFat - bodyFatGoal).toTwoDecimalPlaces(),
      );

      previousWeight = weightGoal;

      await AppDatabase.db.insertWeek(week);
    }

    List<Week> newWeek = await AppDatabase.db.getWeekListFromCycleId(cycleId);
    int weekId = newWeek.first.id!;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final DateTime dateTime = DateTime.now();

    Biometric biometric = Biometric(
      weekId: weekId,
      cycleId: cycleId,
      currentWeight: prefs.getDouble('startingWeight')!,
      bodyFat: prefs.getDouble('startingBodyfat')!,
      dateTime: dateTime.toLocal().toString(),
      day: dateTime.weekday,
      estimated: 0,
    );

    await AppDatabase.db.insertBiometric(biometric);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt('currentWeekId', 1);
  }
}
