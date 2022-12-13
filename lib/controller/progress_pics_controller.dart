import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_cut/database/db.dart';
import 'package:project_cut/model/biometric.dart';
import 'package:project_cut/model/progress_pic.dart';

class ProgressPicsController with ChangeNotifier {
  String _imagePath = '';
  List<ProgressPicture> _progressPictures = [];
  Directory? _directory;

  String get imagePath => _imagePath;
  List<ProgressPicture> get progressPictures => _progressPictures;
  Directory get directory => _directory!;

  void setImagePath(String imagePath) {
    _imagePath = imagePath;
    notifyListeners();
  }

  Future<void> setProgressPictures() async {
    _progressPictures = await AppDatabase.db.getProgressPictures();
    _directory = await getApplicationDocumentsDirectory();
    notifyListeners();
  }

  Future<void> addImagePathToDb(String imagePath) async {
    Biometric biometric = await AppDatabase.db.getLatestBiometric();
    int biometricId = biometric.id!;

    ProgressPicture progressPicture = ProgressPicture(
        biometricId: biometricId,
        imagePath: imagePath,
        dateTime: DateTime.now().toLocal().toString());

    await AppDatabase.db.insertProgressPicture(progressPicture);

    _progressPictures.add(progressPicture);

    notifyListeners();
  }
}
