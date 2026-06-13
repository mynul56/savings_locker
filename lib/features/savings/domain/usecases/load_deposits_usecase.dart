import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/deposit_entity.dart';
import '../repositories/savings_repository.dart';

@injectable
class LoadDepositsUseCase
    implements UseCase<List<DepositEntity>, LoadDepositsParams> {
  final SavingsRepository repository;

  LoadDepositsUseCase(this.repository);

  @override
  Future<Either<Failure, List<DepositEntity>>> call(
    LoadDepositsParams params,
  ) async {
    return await repository.loadDeposits(params.uid);
  }
}

class LoadDepositsParams extends Equatable {
  final String uid;

  const LoadDepositsParams({required this.uid});

  @override
  List<Object> get props => [uid];
}
