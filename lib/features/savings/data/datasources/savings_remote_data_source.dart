import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/deposit_model.dart';

abstract class SavingsRemoteDataSource {
  Future<List<DepositModel>> loadDeposits(String uid);
  Future<DepositModel> createDeposit({
    required String uid,
    required double amount,
    required bool isLocked,
    DateTime? lockUntil,
  });
  Future<void> withdrawDeposit({
    required String uid,
    required String depositId,
  });
}

@LazySingleton(as: SavingsRemoteDataSource)
class SavingsRemoteDataSourceImpl implements SavingsRemoteDataSource {
  final FirebaseFirestore firestore;

  SavingsRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<DepositModel>> loadDeposits(String uid) async {
    try {
      final snapshot = await firestore
          .collection('deposits')
          .where('ownerUid', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => DepositModel.fromJson(doc.data())).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<DepositModel> createDeposit({
    required String uid,
    required double amount,
    required bool isLocked,
    DateTime? lockUntil,
  }) async {
    try {
      final docRef = firestore.collection('deposits').doc();
      final now = DateTime.now();

      final deposit = DepositModel(
        depositId: docRef.id,
        ownerUid: uid,
        amount: amount,
        isLocked: isLocked,
        lockUntil: lockUntil,
        status: 'active',
        createdAt: now,
      );

      await docRef.set(deposit.toJson());

      // Also record a transaction
      final transactionRef = firestore.collection('transactions').doc();
      await transactionRef.set({
        'transactionId': transactionRef.id,
        'ownerUid': uid,
        'type': 'deposit',
        'amount': amount,
        'description': isLocked ? 'Locked Deposit' : 'Flexible Deposit',
        'createdAt': now.toIso8601String(),
      });

      return deposit;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> withdrawDeposit({
    required String uid,
    required String depositId,
  }) async {
    try {
      final docRef = firestore.collection('deposits').doc(depositId);
      final doc = await docRef.get();

      if (!doc.exists || doc.data() == null) {
        throw const ServerException('Deposit not found.');
      }

      final deposit = DepositModel.fromJson(doc.data()!);

      if (deposit.ownerUid != uid) {
        throw const ServerException('Unauthorized.');
      }

      if (!deposit.canWithdraw) {
        throw const ServerException('Deposit is locked and cannot be withdrawn yet.');
      }

      if (deposit.status == 'withdrawn') {
        throw const ServerException('Deposit already withdrawn.');
      }

      await docRef.update({'status': 'withdrawn'});

      // Also record a transaction
      final transactionRef = firestore.collection('transactions').doc();
      await transactionRef.set({
        'transactionId': transactionRef.id,
        'ownerUid': uid,
        'type': 'withdrawal',
        'amount': deposit.amount,
        'description': 'Withdrawal from ${deposit.isLocked ? "Locked" : "Flexible"} Savings',
        'createdAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }
}
