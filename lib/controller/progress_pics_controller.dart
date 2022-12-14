import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_cut/database/db.dart';
import 'package:project_cut/model/biometric.dart';
import 'package:project_cut/model/progress_pic.dart';

class ProgressPicsController with ChangeNotifier {
  String _imagePath = '';
  List<ProgressPicture> _progressPictures = [];
  Directory? _directory;
  List<Biometric> _biometrics = [];

  String get imagePath => _imagePath;
  List<ProgressPicture> get progressPictures => _progressPictures;
  Directory get directory => _directory!;
  List<Biometric> get biometrics => _biometrics;

  void setImagePath(String imagePath) {
    _imagePath = imagePath;
    notifyListeners();
  }

  Future<void> setProgressPictures() async {
    _progressPictures = await AppDatabase.db.getProgressPictures();
    _biometrics = await AppDatabase.db.progressPictureBiometrics;
    _directory = await getApplicationDocumentsDirectory();
    notifyListeners();
  }

  Future<void> addImagePathToDb(String tempImagePath) async {
    Biometric biometric = await AppDatabase.db.getLatestBiometric();
    int biometricId = biometric.id!;

    File image = File(tempImagePath);

    String imagePath = basename(tempImagePath);

    await image.copy('${directory.path}/$imagePath');

    ProgressPicture progressPicture = ProgressPicture(
        biometricId: biometricId,
        imagePath: imagePath,
        dateTime: DateTime.now().toLocal().toString());

    await AppDatabase.db.insertProgressPicture(progressPicture);

    _progressPictures.add(progressPicture);

    if (!_biometrics.contains(biometric)) {
      _biometrics.add(biometric);
    }

    notifyListeners();
  }

  Future<void> deleteProgressPicture(int id) async {
    await AppDatabase.db.deleteProgressPictureById(id);
    _progressPictures.removeWhere((element) => element.id == id);
    _biometrics = await AppDatabase.db.progressPictureBiometrics;

    notifyListeners();
  }
}
