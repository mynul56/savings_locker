import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/deposit_entity.dart';

abstract class SavingsRepository {
  Future<Either<Failure, List<DepositEntity>>> loadDeposits(String uid);
  Future<Either<Failure, DepositEntity>> createDeposit({
    required String uid,
    required double amount,
    required bool isLocked,
    DateTime? lockUntil,
  });
  Future<Either<Failure, void>> withdrawDeposit({
    required String uid,
    required String depositId,
  });
}
