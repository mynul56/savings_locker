import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/goal_entity.dart';
import '../repositories/goals_repository.dart';

@injectable
class LoadGoalsUseCase implements UseCase<List<GoalEntity>, LoadGoalsParams> {
  final GoalsRepository repository;

  LoadGoalsUseCase(this.repository);

  @override
  Future<Either<Failure, List<GoalEntity>>> call(LoadGoalsParams params) async {
    return await repository.loadGoals(params.uid);
  }
}

class LoadGoalsParams extends Equatable {
  final String uid;

  const LoadGoalsParams({required this.uid});

  @override
  List<Object> get props => [uid];
}
