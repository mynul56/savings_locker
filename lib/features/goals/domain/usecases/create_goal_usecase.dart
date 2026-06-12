import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/goal_entity.dart';
import '../repositories/goals_repository.dart';

@injectable
class CreateGoalUseCase implements UseCase<GoalEntity, CreateGoalParams> {
  final GoalsRepository repository;

  CreateGoalUseCase(this.repository);

  @override
  Future<Either<Failure, GoalEntity>> call(CreateGoalParams params) async {
    return await repository.createGoal(
      uid: params.uid,
      title: params.title,
      targetAmount: params.targetAmount,
      goalType: params.goalType,
      targetDate: params.targetDate,
    );
  }
}

class CreateGoalParams extends Equatable {
  final String uid;
  final String title;
  final double targetAmount;
  final String goalType;
  final DateTime targetDate;

  const CreateGoalParams({
    required this.uid,
    required this.title,
    required this.targetAmount,
    required this.goalType,
    required this.targetDate,
  });

  @override
  List<Object> get props => [uid, title, targetAmount, goalType, targetDate];
}
