import 'package:flutter/material.dart';
import 'package:project_cut/database/db.dart';
import 'package:project_cut/model/cycle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CycleHistoryController with ChangeNotifier {
  List<Cycle> _cycleHistory = [];

  List<Cycle> get cycleHistory => _cycleHistory;

  Future<void> setCycleHistory() async {
    _cycleHistory = await AppDatabase.db.getCycles();
    notifyListeners();
  }

  Future<void> setCurrentCycleId(int cycleId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentCycleId', cycleId);
  }
}
