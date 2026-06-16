import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/transaction_model.dart';
import '../repositories/transactions_repository.dart';

@lazySingleton
class LoadTransactionsUseCase implements UseCase<List<TransactionModel>, String> {
  final TransactionsRepository repository;

  LoadTransactionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<TransactionModel>>> call(String uid) async {
    return await repository.loadTransactions(uid);
  }
}
