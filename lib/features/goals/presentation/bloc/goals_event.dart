part of 'goals_bloc.dart';

abstract class GoalsEvent extends Equatable {
  const GoalsEvent();

  @override
  List<Object?> get props => [];
}

class LoadGoals extends GoalsEvent {
  final String uid;

  const LoadGoals(this.uid);

  @override
  List<Object> get props => [uid];
}

class CreateGoal extends GoalsEvent {
  final String uid;
  final String title;
  final double targetAmount;
  final String goalType;
  final DateTime targetDate;

  const CreateGoal({
    required this.uid,
    required this.title,
    required this.targetAmount,
    required this.goalType,
    required this.targetDate,
  });

  @override
  List<Object?> get props => [uid, title, targetAmount, goalType, targetDate];
}

class ContributeGoal extends GoalsEvent {
  final String uid;
  final String goalId;
  final double amount;

  const ContributeGoal({
    required this.uid,
    required this.goalId,
    required this.amount,
  });

  @override
  List<Object> get props => [uid, goalId, amount];
}
