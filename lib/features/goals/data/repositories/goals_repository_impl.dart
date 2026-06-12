import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/goal_entity.dart';
import '../../domain/repositories/goals_repository.dart';
import '../datasources/goals_remote_data_source.dart';

@LazySingleton(as: GoalsRepository)
class GoalsRepositoryImpl implements GoalsRepository {
  final GoalsRemoteDataSource remoteDataSource;

  GoalsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<GoalEntity>>> loadGoals(String uid) async {
    try {
      final goals = await remoteDataSource.loadGoals(uid);
      return Right(goals);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GoalEntity>> createGoal({
    required String uid,
    required String title,
    required double targetAmount,
    required String goalType,
    required DateTime targetDate,
  }) async {
    try {
      final goal = await remoteDataSource.createGoal(
        uid: uid,
        title: title,
        targetAmount: targetAmount,
        goalType: goalType,
        targetDate: targetDate,
      );
      return Right(goal);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateGoal(GoalEntity goal) async {
    try {
      await remoteDataSource.updateGoal(goal);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteGoal(String goalId) async {
    try {
      await remoteDataSource.deleteGoal(goalId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> contributeGoal({
    required String uid,
    required String goalId,
    required double amount,
  }) async {
    try {
      await remoteDataSource.contributeGoal(uid: uid, goalId: goalId, amount: amount);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
