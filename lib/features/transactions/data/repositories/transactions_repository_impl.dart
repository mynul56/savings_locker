import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/transactions_repository.dart';
import '../datasources/transactions_remote_data_source.dart';
import '../models/transaction_model.dart';

@LazySingleton(as: TransactionsRepository)
class TransactionsRepositoryImpl implements TransactionsRepository {
  final TransactionsRemoteDataSource remoteDataSource;

  TransactionsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<TransactionModel>>> loadTransactions(
    String uid,
  ) async {
    try {
      final transactions = await remoteDataSource.loadTransactions(uid);
      return Right(transactions);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
