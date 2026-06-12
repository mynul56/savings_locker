import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/goals_repository.dart';

@injectable
class ContributeGoalUseCase implements UseCase<void, ContributeGoalParams> {
  final GoalsRepository repository;

  ContributeGoalUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ContributeGoalParams params) async {
    return await repository.contributeGoal(
      uid: params.uid,
      goalId: params.goalId,
      amount: params.amount,
    );
  }
}

class ContributeGoalParams extends Equatable {
  final String uid;
  final String goalId;
  final double amount;

  const ContributeGoalParams({
    required this.uid,
    required this.goalId,
    required this.amount,
  });

  @override
  List<Object> get props => [uid, goalId, amount];
}
