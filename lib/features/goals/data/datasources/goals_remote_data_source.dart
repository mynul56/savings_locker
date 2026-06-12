import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/goal_model.dart';
import '../../domain/entities/goal_entity.dart';

abstract class GoalsRemoteDataSource {
  Future<List<GoalModel>> loadGoals(String uid);
  Future<GoalModel> createGoal({
    required String uid,
    required String title,
    required double targetAmount,
    required String goalType,
    required DateTime targetDate,
  });
  Future<void> updateGoal(GoalEntity goal);
  Future<void> deleteGoal(String goalId);
  Future<void> contributeGoal({
    required String uid,
    required String goalId,
    required double amount,
  });
}

@LazySingleton(as: GoalsRemoteDataSource)
class GoalsRemoteDataSourceImpl implements GoalsRemoteDataSource {
  final FirebaseFirestore firestore;

  GoalsRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<GoalModel>> loadGoals(String uid) async {
    try {
      final snapshot = await firestore
          .collection('goals')
          .where('ownerUid', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => GoalModel.fromJson(doc.data())).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<GoalModel> createGoal({
    required String uid,
    required String title,
    required double targetAmount,
    required String goalType,
    required DateTime targetDate,
  }) async {
    try {
      final docRef = firestore.collection('goals').doc();
      final now = DateTime.now();

      final goal = GoalModel(
        goalId: docRef.id,
        ownerUid: uid,
        title: title,
        targetAmount: targetAmount,
        currentAmount: 0,
        goalType: goalType,
        targetDate: targetDate,
        createdAt: now,
      );

      await docRef.set(goal.toJson());
      return goal;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateGoal(GoalEntity goal) async {
    try {
      final docRef = firestore.collection('goals').doc(goal.goalId);
      final model = GoalModel.fromEntity(goal);
      await docRef.update(model.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteGoal(String goalId) async {
    try {
      await firestore.collection('goals').doc(goalId).delete();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> contributeGoal({
    required String uid,
    required String goalId,
    required double amount,
  }) async {
    try {
      final docRef = firestore.collection('goals').doc(goalId);
      final doc = await docRef.get();

      if (!doc.exists || doc.data() == null) {
        throw const ServerException('Goal not found.');
      }

      final goal = GoalModel.fromJson(doc.data()!);

      if (goal.ownerUid != uid) {
        throw const ServerException('Unauthorized.');
      }

      final newAmount = goal.currentAmount + amount;
      await docRef.update({'currentAmount': newAmount});

      // Also record a transaction
      final transactionRef = firestore.collection('transactions').doc();
      await transactionRef.set({
        'transactionId': transactionRef.id,
        'ownerUid': uid,
        'type': 'goal_contribution',
        'amount': amount,
        'description': 'Contribution to ${goal.title}',
        'createdAt': DateTime.now().toIso8601String(),
      });
      
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }
}
