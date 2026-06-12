import 'package:equatable/equatable.dart';

class GoalEntity extends Equatable {
  final String goalId;
  final String ownerUid;
  final String title;
  final double targetAmount;
  final double currentAmount;
  final String goalType;
  final DateTime targetDate;
  final DateTime createdAt;

  const GoalEntity({
    required this.goalId,
    required this.ownerUid,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    required this.goalType,
    required this.targetDate,
    required this.createdAt,
  });

  double get completionPercentage {
    if (targetAmount == 0) return 0;
    return (currentAmount / targetAmount).clamp(0.0, 1.0);
  }

  int get daysRemaining {
    final now = DateTime.now();
    if (now.isAfter(targetDate)) return 0;
    return targetDate.difference(now).inDays;
  }

  @override
  List<Object?> get props => [
        goalId,
        ownerUid,
        title,
        targetAmount,
        currentAmount,
        goalType,
        targetDate,
        createdAt,
      ];
}
