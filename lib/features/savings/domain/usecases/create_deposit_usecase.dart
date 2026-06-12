import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/deposit_entity.dart';
import '../repositories/savings_repository.dart';

@injectable
class CreateDepositUseCase implements UseCase<DepositEntity, CreateDepositParams> {
  final SavingsRepository repository;

  CreateDepositUseCase(this.repository);

  @override
  Future<Either<Failure, DepositEntity>> call(CreateDepositParams params) async {
    return await repository.createDeposit(
      uid: params.uid,
      amount: params.amount,
      isLocked: params.isLocked,
      lockUntil: params.lockUntil,
    );
  }
}

class CreateDepositParams extends Equatable {
  final String uid;
  final double amount;
  final bool isLocked;
  final DateTime? lockUntil;

  const CreateDepositParams({
    required this.uid,
    required this.amount,
    required this.isLocked,
    this.lockUntil,
  });

  @override
  List<Object?> get props => [uid, amount, isLocked, lockUntil];
}
