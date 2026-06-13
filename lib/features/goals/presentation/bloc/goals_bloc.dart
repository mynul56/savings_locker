import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/goal_entity.dart';
import '../../domain/usecases/contribute_goal_usecase.dart';
import '../../domain/usecases/create_goal_usecase.dart';
import '../../domain/usecases/load_goals_usecase.dart';

part 'goals_event.dart';
part 'goals_state.dart';

@injectable
class GoalsBloc extends Bloc<GoalsEvent, GoalsState> {
  final LoadGoalsUseCase loadGoalsUseCase;
  final CreateGoalUseCase createGoalUseCase;
  final ContributeGoalUseCase contributeGoalUseCase;

  GoalsBloc({
    required this.loadGoalsUseCase,
    required this.createGoalUseCase,
    required this.contributeGoalUseCase,
  }) : super(GoalsInitial()) {
    on<LoadGoals>(_onLoadGoals);
    on<CreateGoal>(_onCreateGoal);
    on<ContributeGoal>(_onContributeGoal);
  }

  Future<void> _onLoadGoals(LoadGoals event, Emitter<GoalsState> emit) async {
    emit(GoalsLoading());
    final result = await loadGoalsUseCase(LoadGoalsParams(uid: event.uid));
    result.fold(
      (failure) => emit(GoalsFailure(failure.message)),
      (goals) => emit(GoalsLoaded(goals)),
    );
  }

  Future<void> _onCreateGoal(CreateGoal event, Emitter<GoalsState> emit) async {
    final currentState = state;
    if (currentState is! GoalsLoaded) {
      emit(GoalsLoading());
    }

    final result = await createGoalUseCase(
      CreateGoalParams(
        uid: event.uid,
        title: event.title,
        targetAmount: event.targetAmount,
        goalType: event.goalType,
        targetDate: event.targetDate,
      ),
    );

    result.fold((failure) => emit(GoalsFailure(failure.message)), (goal) {
      if (currentState is GoalsLoaded) {
        final updatedGoals = List<GoalEntity>.from(currentState.goals)
          ..insert(0, goal);
        emit(GoalsLoaded(updatedGoals));
      } else {
        add(LoadGoals(event.uid));
      }
    });
  }

  Future<void> _onContributeGoal(
    ContributeGoal event,
    Emitter<GoalsState> emit,
  ) async {
    final result = await contributeGoalUseCase(
      ContributeGoalParams(
        uid: event.uid,
        goalId: event.goalId,
        amount: event.amount,
      ),
    );

    result.fold((failure) => emit(GoalsFailure(failure.message)), (_) {
      // Successfully contributed, reload the goals
      add(LoadGoals(event.uid));
    });
  }
}
