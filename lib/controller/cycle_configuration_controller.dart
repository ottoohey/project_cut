import 'package:flutter/material.dart';
import 'package:project_cut/database/db.dart';
import 'package:project_cut/model/biometric.dart';
import 'package:project_cut/model/cycle.dart';
import 'package:project_cut/model/week.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CycleConfigurationController with ChangeNotifier {
  String sex = 'MALE';
  double timeFrame = 0.0;

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

  double toTwoDecimalPlaces(double value) {
    return double.parse(value.toStringAsFixed(2));
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
        weightLoss: toTwoDecimalPlaces(weightLoss),
        weightGoal: toTwoDecimalPlaces(weightGoal),
        bodyFatGoal: toTwoDecimalPlaces(cycle.startBodyFat - bodyFatGoal),
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
  }
}
