import '../../domain/entities/deposit_entity.dart';

class DepositModel extends DepositEntity {
  const DepositModel({
    required super.depositId,
    required super.ownerUid,
    required super.amount,
    required super.isLocked,
    super.lockUntil,
    required super.status,
    required super.createdAt,
  });

  factory DepositModel.fromJson(Map<String, dynamic> json) {
    return DepositModel(
      depositId: json['depositId'] as String,
      ownerUid: json['ownerUid'] as String,
      amount: (json['amount'] as num).toDouble(),
      isLocked: json['isLocked'] as bool,
      lockUntil: json['lockUntil'] != null
          ? DateTime.parse(json['lockUntil'] as String)
          : null,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'depositId': depositId,
      'ownerUid': ownerUid,
      'amount': amount,
      'isLocked': isLocked,
      'lockUntil': lockUntil?.toIso8601String(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory DepositModel.fromEntity(DepositEntity entity) {
    return DepositModel(
      depositId: entity.depositId,
      ownerUid: entity.ownerUid,
      amount: entity.amount,
      isLocked: entity.isLocked,
      lockUntil: entity.lockUntil,
      status: entity.status,
      createdAt: entity.createdAt,
    );
  }
}
