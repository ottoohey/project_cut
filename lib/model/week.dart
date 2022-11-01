class Week {
  final int id;
  final int week;
  final int calorieDeficit;
  final double weightLoss;
  final double weightGoal;
  final double bodyFatGoal;

  const Week({
    required this.id,
    required this.week,
    required this.calorieDeficit,
    required this.weightLoss,
    required this.weightGoal,
    required this.bodyFatGoal,
  });

  // Convert a Week into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'week': week,
      'calorieDeficit': calorieDeficit,
      'weightLoss': weightLoss,
      'weightGoal': weightGoal,
      'bodyFatGoal': bodyFatGoal,
    };
  }

  // Implement toString to make it easier to see information about
  // each biometric reading when using the print statement.
  @override
  String toString() {
    return 'Week{id: $id, week: $week, calorieDeficit: $calorieDeficit, weightLoss: $weightLoss, weightGoal: $weightGoal, bodyFatGoal: $bodyFatGoal}';
  }
}
