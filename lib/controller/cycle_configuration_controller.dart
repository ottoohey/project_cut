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

  Future<void> startCut(Cycle cycle) async {
    await AppDatabase.db.insertCycle(cycle);

    List<Cycle> newCycle = await AppDatabase.db.getCycles();
    print(newCycle);
    int cycleId = newCycle[0].id!;

    Week week = Week(
      cycleId: cycleId,
      week: 0,
      calorieDeficit: 0,
      weightLoss: 0,
      weightGoal: 0,
      bodyFatGoal: 0,
    );

    await AppDatabase.db.insertWeek(week);

    List<Week> newWeek = await AppDatabase.db.getWeekListFromCycleId(cycleId);
    int weekId = newWeek[0].id!;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final DateTime dateTime = DateTime.now();

    Biometric biometric = Biometric(
      weekId: weekId,
      cycleId: cycleId,
      currentWeight: prefs.getDouble('startingWeight')!,
      bodyFat: prefs.getInt('startingBodyfat')!,
      dateTime: dateTime.toLocal().toString(),
      day: dateTime.weekday,
    );

    await AppDatabase.db.insertBiometric(biometric);
  }
}
