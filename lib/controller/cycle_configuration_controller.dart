import 'package:flutter/material.dart';

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
}
