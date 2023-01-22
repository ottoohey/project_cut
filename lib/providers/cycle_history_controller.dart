import 'package:flutter/material.dart';
import 'package:project_cut/database/db.dart';
import 'package:project_cut/model/cycle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CycleHistoryController with ChangeNotifier {
  List<Cycle> _cycleHistory = [];
  int _currentCycleId = 1;

  List<Cycle> get cycleHistory => _cycleHistory;
  int get currentCycleId => _currentCycleId;

  Future<void> setCycleHistory() async {
    _cycleHistory = await AppDatabase.db.getCycles();
    final prefs = await SharedPreferences.getInstance();
    _currentCycleId = prefs.getInt('currentCycleId')!;
    notifyListeners();
  }

  Future<void> setCurrentCycleId(int cycleId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentCycleId', cycleId);
  }

  Future<void> deleteCut(int id) async {
    final prefs = await SharedPreferences.getInstance();
    int currentCycleId = prefs.getInt('currentCycleId')!;

    cycleHistory.removeWhere((element) => element.id == id);
    await AppDatabase.db.deleteCycleData(id);

    if (currentCycleId == id) {
      List<Cycle> cycles = await AppDatabase.db.getCycles();
      cycles.isNotEmpty ? currentCycleId = cycles.last.id! : currentCycleId = 0;
      await prefs.setInt('currentCycleId', currentCycleId);
    }

    notifyListeners();
  }
}
