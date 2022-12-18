class ProgressPicture {
  final int? id;
  final int biometricId;
  final int cycleId;
  final String imagePath;
  final String dateTime;

  const ProgressPicture({
    this.id,
    required this.biometricId,
    required this.cycleId,
    required this.imagePath,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'biometricId': biometricId,
      'cycleId': cycleId,
      'imagePath': imagePath,
      'dateTime': dateTime,
    };
  }

  @override
  String toString() {
    return 'ProgressPicture{id: $id, biometricId: $biometricId, cycleId: $cycleId, imagePath: $imagePath, dateTime: $dateTime}';
  }
}
