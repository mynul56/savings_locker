import 'package:equatable/equatable.dart';

class TransactionModel extends Equatable {
  final String transactionId;
  final String ownerUid;
  final String type; // 'deposit' or 'withdrawal'
  final double amount;
  final String description;
  final DateTime createdAt;

  const TransactionModel({
    required this.transactionId,
    required this.ownerUid,
    required this.type,
    required this.amount,
    required this.description,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      transactionId: json['transactionId'] as String,
      ownerUid: json['ownerUid'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'ownerUid': ownerUid,
      'type': type,
      'amount': amount,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        transactionId,
        ownerUid,
        type,
        amount,
        description,
        createdAt,
      ];
}
