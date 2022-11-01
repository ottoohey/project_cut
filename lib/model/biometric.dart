class Biometric {
  final int id;
  final double currentWeight;
  final int bodyFat;
  final String dateTime;
  final int weekId;

  const Biometric({
    required this.id,
    required this.currentWeight,
    required this.bodyFat,
    required this.dateTime,
    required this.weekId,
  });

  // Convert a Biometric into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'currentWeight': currentWeight,
      'bodyFat': bodyFat,
      'dateTime': dateTime,
      'weekId': weekId,
    };
  }

  // Implement toString to make it easier to see information about
  // each biometric reading when using the print statement.
  @override
  String toString() {
    return 'Biometric{id: $id, currentWeight: $currentWeight, bodyFat: $bodyFat, dateTime: $dateTime, weekId: $weekId}';
  }
}
