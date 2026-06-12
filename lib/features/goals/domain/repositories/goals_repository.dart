import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/goal_entity.dart';

abstract class GoalsRepository {
  Future<Either<Failure, List<GoalEntity>>> loadGoals(String uid);
  Future<Either<Failure, GoalEntity>> createGoal({
    required String uid,
    required String title,
    required double targetAmount,
    required String goalType,
    required DateTime targetDate,
  });
  Future<Either<Failure, void>> updateGoal(GoalEntity goal);
  Future<Either<Failure, void>> deleteGoal(String goalId);
  Future<Either<Failure, void>> contributeGoal({
    required String uid,
    required String goalId,
    required double amount,
  });
}
