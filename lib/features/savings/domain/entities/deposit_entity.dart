import 'package:equatable/equatable.dart';

class DepositEntity extends Equatable {
  final String depositId;
  final String ownerUid;
  final double amount;
  final bool isLocked;
  final DateTime? lockUntil;
  final String status;
  final DateTime createdAt;

  const DepositEntity({
    required this.depositId,
    required this.ownerUid,
    required this.amount,
    required this.isLocked,
    this.lockUntil,
    required this.status,
    required this.createdAt,
  });

  bool get canWithdraw {
    if (!isLocked) return true;
    if (lockUntil == null) return true;
    return DateTime.now().isAfter(lockUntil!);
  }

  @override
  List<Object?> get props => [
        depositId,
        ownerUid,
        amount,
        isLocked,
        lockUntil,
        status,
        createdAt,
      ];
}
