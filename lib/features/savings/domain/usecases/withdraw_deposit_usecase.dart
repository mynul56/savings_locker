import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/savings_repository.dart';

@injectable
class WithdrawDepositUseCase implements UseCase<void, WithdrawDepositParams> {
  final SavingsRepository repository;

  WithdrawDepositUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(WithdrawDepositParams params) async {
    return await repository.withdrawDeposit(
      uid: params.uid,
      depositId: params.depositId,
    );
  }
}

class WithdrawDepositParams extends Equatable {
  final String uid;
  final String depositId;

  const WithdrawDepositParams({required this.uid, required this.depositId});

  @override
  List<Object> get props => [uid, depositId];
}
