class Week {
  final int? id;
  final int cycleId;
  final int week;
  final int calorieDeficit;
  final double weightLoss;
  final double weightGoal;
  final double bodyFatGoal;

  const Week({
    this.id,
    required this.cycleId,
    required this.week,
    required this.calorieDeficit,
    required this.weightLoss,
    required this.weightGoal,
    required this.bodyFatGoal,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cycleId': cycleId,
      'week': week,
      'calorieDeficit': calorieDeficit,
      'weightLoss': weightLoss,
      'weightGoal': weightGoal,
      'bodyFatGoal': bodyFatGoal,
    };
  }

  @override
  String toString() {
    return 'Week{id: $id, cycleId: $cycleId, week: $week, calorieDeficit: $calorieDeficit, weightLoss: $weightLoss, weightGoal: $weightGoal, bodyFatGoal: $bodyFatGoal}';
  }
}
