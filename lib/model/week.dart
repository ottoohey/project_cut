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

  @override
  String toString() {
    return 'Week{id: $id, week: $week, calorieDeficit: $calorieDeficit, weightLoss: $weightLoss, weightGoal: $weightGoal, bodyFatGoal: $bodyFatGoal}';
  }
}
