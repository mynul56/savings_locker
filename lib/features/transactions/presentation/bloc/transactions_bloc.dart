import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/load_transactions_usecase.dart';
import 'transactions_event.dart';
import 'transactions_state.dart';

@injectable
class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  final LoadTransactionsUseCase loadTransactionsUseCase;

  TransactionsBloc({required this.loadTransactionsUseCase})
      : super(TransactionsInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
  }

  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<TransactionsState> emit,
  ) async {
    emit(TransactionsLoading());
    final result = await loadTransactionsUseCase(event.uid);
    result.fold(
      (failure) => emit(TransactionsError(failure.message)),
      (transactions) => emit(TransactionsLoaded(transactions)),
    );
  }
}
