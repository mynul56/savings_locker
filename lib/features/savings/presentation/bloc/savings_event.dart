part of 'savings_bloc.dart';

abstract class SavingsEvent extends Equatable {
  const SavingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadDeposits extends SavingsEvent {
  final String uid;

  const LoadDeposits(this.uid);

  @override
  List<Object> get props => [uid];
}

class CreateDeposit extends SavingsEvent {
  final String uid;
  final double amount;
  final bool isLocked;
  final DateTime? lockUntil;

  const CreateDeposit({
    required this.uid,
    required this.amount,
    required this.isLocked,
    this.lockUntil,
  });

  @override
  List<Object?> get props => [uid, amount, isLocked, lockUntil];
}

class WithdrawDeposit extends SavingsEvent {
  final String uid;
  final String depositId;

  const WithdrawDeposit({required this.uid, required this.depositId});

  @override
  List<Object> get props => [uid, depositId];
}
