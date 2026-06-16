import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/transaction_model.dart';

abstract class TransactionsRemoteDataSource {
  Future<List<TransactionModel>> loadTransactions(String uid);
}

@LazySingleton(as: TransactionsRemoteDataSource)
class TransactionsRemoteDataSourceImpl implements TransactionsRemoteDataSource {
  final FirebaseFirestore firestore;

  TransactionsRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<TransactionModel>> loadTransactions(String uid) async {
    try {
      final snapshot = await firestore
          .collection('transactions')
          .where('ownerUid', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => TransactionModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
