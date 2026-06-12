import '../../domain/entities/goal_entity.dart';

class GoalModel extends GoalEntity {
  const GoalModel({
    required super.goalId,
    required super.ownerUid,
    required super.title,
    required super.targetAmount,
    required super.currentAmount,
    required super.goalType,
    required super.targetDate,
    required super.createdAt,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      goalId: json['goalId'] as String,
      ownerUid: json['ownerUid'] as String,
      title: json['title'] as String,
      targetAmount: (json['targetAmount'] as num).toDouble(),
      currentAmount: (json['currentAmount'] as num).toDouble(),
      goalType: json['goalType'] as String,
      targetDate: DateTime.parse(json['targetDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'goalId': goalId,
      'ownerUid': ownerUid,
      'title': title,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'goalType': goalType,
      'targetDate': targetDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory GoalModel.fromEntity(GoalEntity entity) {
    return GoalModel(
      goalId: entity.goalId,
      ownerUid: entity.ownerUid,
      title: entity.title,
      targetAmount: entity.targetAmount,
      currentAmount: entity.currentAmount,
      goalType: entity.goalType,
      targetDate: entity.targetDate,
      createdAt: entity.createdAt,
    );
  }
}
