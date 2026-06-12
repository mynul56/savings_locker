part of 'savings_bloc.dart';

abstract class SavingsState extends Equatable {
  const SavingsState();

  @override
  List<Object> get props => [];
}

class SavingsInitial extends SavingsState {}

class SavingsLoading extends SavingsState {}

class SavingsLoaded extends SavingsState {
  final List<DepositEntity> deposits;

  const SavingsLoaded(this.deposits);

  @override
  List<Object> get props => [deposits];
}

class SavingsFailure extends SavingsState {
  final String message;

  const SavingsFailure(this.message);

  @override
  List<Object> get props => [message];
}
