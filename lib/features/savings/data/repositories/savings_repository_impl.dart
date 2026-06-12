import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/deposit_entity.dart';
import '../../domain/repositories/savings_repository.dart';
import '../datasources/savings_remote_data_source.dart';

@LazySingleton(as: SavingsRepository)
class SavingsRepositoryImpl implements SavingsRepository {
  final SavingsRemoteDataSource remoteDataSource;

  SavingsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<DepositEntity>>> loadDeposits(String uid) async {
    try {
      final deposits = await remoteDataSource.loadDeposits(uid);
      return Right(deposits);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DepositEntity>> createDeposit({
    required String uid,
    required double amount,
    required bool isLocked,
    DateTime? lockUntil,
  }) async {
    try {
      final deposit = await remoteDataSource.createDeposit(
        uid: uid,
        amount: amount,
        isLocked: isLocked,
        lockUntil: lockUntil,
      );
      return Right(deposit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> withdrawDeposit({
    required String uid,
    required String depositId,
  }) async {
    try {
      await remoteDataSource.withdrawDeposit(uid: uid, depositId: depositId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
