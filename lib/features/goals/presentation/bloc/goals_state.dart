part of 'goals_bloc.dart';

abstract class GoalsState extends Equatable {
  const GoalsState();

  @override
  List<Object> get props => [];
}

class GoalsInitial extends GoalsState {}

class GoalsLoading extends GoalsState {}

class GoalsLoaded extends GoalsState {
  final List<GoalEntity> goals;

  const GoalsLoaded(this.goals);

  @override
  List<Object> get props => [goals];
}

class GoalsFailure extends GoalsState {
  final String message;

  const GoalsFailure(this.message);

  @override
  List<Object> get props => [message];
}
