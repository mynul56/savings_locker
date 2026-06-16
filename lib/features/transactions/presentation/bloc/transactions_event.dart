import 'package:equatable/equatable.dart';

abstract class TransactionsEvent extends Equatable {
  const TransactionsEvent();

  @override
  List<Object> get props => [];
}

class LoadTransactions extends TransactionsEvent {
  final String uid;

  const LoadTransactions(this.uid);

  @override
  List<Object> get props => [uid];
}
