import 'package:flutter/material.dart';
import 'package:project_cut/database/db.dart';
import 'package:project_cut/model/biometric.dart';

class EditBiometricsHistoryController with ChangeNotifier {
  List<Biometric> _allBiometrics = [];
  bool _expanded = false;
  int _biometricIdToEdit = 0;
  double _initialWeightToEdit = 0;
  double _weight = 0;
  Biometric? _biometric;

  List<Biometric> get allBiometrics => _allBiometrics;
  bool get expanded => _expanded;
  int get biometricIdToEdit => _biometricIdToEdit;
  double get initialWeightToEdit => _initialWeightToEdit;

  Future<void> setAllBiometrics() async {
    _allBiometrics = await AppDatabase.db.getBiometrics();
    notifyListeners();
  }

  void setExpanded() {
    if (_expanded) {
      _expanded = false;
    } else {
      _expanded = true;
    }
    notifyListeners();
  }

  void setBiometricIdToEdit(int id) {
    _biometricIdToEdit = id;
    _biometric = _allBiometrics.where((element) => element.id == id).first;
    _initialWeightToEdit = _biometric!.currentWeight;
    notifyListeners();
  }

  void setWeight(double weight) {
    _weight = weight;
  }

  Future<void> editWeight() async {
    Biometric updatedBiometric = Biometric(
      id: _biometric!.id,
      weekId: _biometric!.weekId,
      cycleId: _biometric!.cycleId,
      currentWeight: _weight,
      bodyFat: _biometric!.bodyFat,
      dateTime: _biometric!.dateTime,
      day: _biometric!.day,
      estimated: 0,
    );

    await AppDatabase.db.updateBiometric(updatedBiometric);

    int indexToUpdate = _allBiometrics.indexOf(_biometric!);

    _allBiometrics.removeAt(indexToUpdate);
    _allBiometrics.insert(indexToUpdate, updatedBiometric);

    notifyListeners();
  }
}
