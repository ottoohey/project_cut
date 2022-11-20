class Biometric {
  final int? id;
  final int weekId;
  final int cycleId;
  final double currentWeight;
  final double bodyFat;
  final String dateTime;
  final int day;
  final int estimated;

  const Biometric({
    this.id,
    required this.weekId,
    required this.cycleId,
    required this.currentWeight,
    required this.bodyFat,
    required this.dateTime,
    required this.day,
    required this.estimated,
  });

  // Convert a Biometric into a Map. The keys must correspond to the names of the
  // columns in the db.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'weekId': weekId,
      'cycleId': cycleId,
      'currentWeight': currentWeight,
      'bodyFat': bodyFat,
      'dateTime': dateTime,
      'day': day,
      'estimated': estimated,
    };
  }

  // Implement toString to make it easier to see information about
  // each biometric reading when using the print statement.
  @override
  String toString() {
    return 'Biometric{id: $id, weekId: $weekId, cycleId: $cycleId, currentWeight: $currentWeight, bodyFat: $bodyFat, dateTime: $dateTime, day: $day, estimated: $estimated}';
  }
}
