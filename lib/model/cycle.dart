class Cycle {
  final int? id;
  final double startWeight;
  final double goalWeight;
  final double startBodyFat;
  final double goalBodyFat;
  final String startDateTime;
  final String endDateTime;

  const Cycle({
    this.id,
    required this.startWeight,
    required this.goalWeight,
    required this.startBodyFat,
    required this.goalBodyFat,
    required this.startDateTime,
    required this.endDateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startWeight': startWeight,
      'goalWeight': goalWeight,
      'startBodyFat': startBodyFat,
      'goalBodyFat': goalBodyFat,
      'startDateTime': startDateTime,
      'endDateTime': endDateTime,
    };
  }

  @override
  String toString() {
    return 'Cycle{id: $id, startWeight: $startWeight, goalWeight: $goalWeight, startBodyFat: $startBodyFat, goalBodyFat: $goalBodyFat, startDateTime: $startDateTime, endDateTime: $endDateTime}';
  }
}
