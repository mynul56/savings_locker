import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/deposit_entity.dart';
import '../../domain/usecases/create_deposit_usecase.dart';
import '../../domain/usecases/load_deposits_usecase.dart';
import '../../domain/usecases/withdraw_deposit_usecase.dart';

part 'savings_event.dart';
part 'savings_state.dart';

@injectable
class SavingsBloc extends Bloc<SavingsEvent, SavingsState> {
  final LoadDepositsUseCase loadDepositsUseCase;
  final CreateDepositUseCase createDepositUseCase;
  final WithdrawDepositUseCase withdrawDepositUseCase;

  SavingsBloc({
    required this.loadDepositsUseCase,
    required this.createDepositUseCase,
    required this.withdrawDepositUseCase,
  }) : super(SavingsInitial()) {
    on<LoadDeposits>(_onLoadDeposits);
    on<CreateDeposit>(_onCreateDeposit);
    on<WithdrawDeposit>(_onWithdrawDeposit);
  }

  Future<void> _onLoadDeposits(LoadDeposits event, Emitter<SavingsState> emit) async {
    emit(SavingsLoading());
    final result = await loadDepositsUseCase(LoadDepositsParams(uid: event.uid));
    result.fold(
      (failure) => emit(SavingsFailure(failure.message)),
      (deposits) => emit(SavingsLoaded(deposits)),
    );
  }

  Future<void> _onCreateDeposit(CreateDeposit event, Emitter<SavingsState> emit) async {
    // If we have loaded deposits, we want to reload them after creation,
    // so we don't clear the list just to show loading.
    final currentState = state;
    if (currentState is! SavingsLoaded) {
      emit(SavingsLoading());
    }

    final result = await createDepositUseCase(CreateDepositParams(
      uid: event.uid,
      amount: event.amount,
      isLocked: event.isLocked,
      lockUntil: event.lockUntil,
    ));

    result.fold(
      (failure) => emit(SavingsFailure(failure.message)),
      (deposit) {
        // If we were loaded before, append the new deposit and emit updated list
        if (currentState is SavingsLoaded) {
          final updatedDeposits = List<DepositEntity>.from(currentState.deposits)..insert(0, deposit);
          emit(SavingsLoaded(updatedDeposits));
        } else {
          // Fallback, trigger load
          add(LoadDeposits(event.uid));
        }
      },
    );
  }

  Future<void> _onWithdrawDeposit(WithdrawDeposit event, Emitter<SavingsState> emit) async {
    final result = await withdrawDepositUseCase(WithdrawDepositParams(
      uid: event.uid,
      depositId: event.depositId,
    ));

    result.fold(
      (failure) => emit(SavingsFailure(failure.message)),
      (_) {
        // We successfully withdrew. Reload the deposits.
        add(LoadDeposits(event.uid));
      },
    );
  }
}
