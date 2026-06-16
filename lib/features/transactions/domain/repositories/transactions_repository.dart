import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/transaction_model.dart';

abstract class TransactionsRepository {
  Future<Either<Failure, List<TransactionModel>>> loadTransactions(String uid);
}
