import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:project_cut/database/db.dart';
import 'package:project_cut/model/biometric.dart';
import 'package:project_cut/model/week.dart';

class CycleConfigurationController with ChangeNotifier {
  String sex = 'MALE';
  double timeFrame = 0.0;
  int startDay = DateTime.now().weekday;
  int startWeek = ((int.parse(DateFormat('D').format(DateTime.now())) -
              DateTime.now().weekday +
              10) /
          7)
      .floor();

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

  Future<void> startCut(
      double currentWeight, int bodyFat, String dateTime, int day) async {
    Biometric biometric = Biometric(
        id: 0,
        currentWeight: currentWeight,
        bodyFat: bodyFat,
        dateTime: dateTime,
        day: day,
        weekId: 0);
    BiometricsDatabase.biometricsDatabase.insertBiometric(biometric);

    Week week = const Week(
        id: 0,
        week: 0,
        calorieDeficit: 0,
        weightLoss: 0,
        weightGoal: 0,
        bodyFatGoal: 0);
    BiometricsDatabase.biometricsDatabase.insertWeek(week);
  }
}
