import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/transactions_repository.dart';
import 'transactions_event.dart';
import 'transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  final TransactionsRepository _repository;

  TransactionsBloc(this._repository)
      : super(TransactionsState(
          month: DateTime.now().month,
          year: DateTime.now().year,
        )) {
    on<TransactionsRequested>(_onTransactionsRequested);
    on<TransactionDeleteRequested>(_onTransactionDeleteRequested);
    on<MonthChanged>(_onMonthChanged);
  }

  Future<void> _onTransactionsRequested(
    TransactionsRequested event,
    Emitter<TransactionsState> emit,
  ) async {
    emit(state.copyWith(status: TransactionsStatus.loading));

    final result = await _repository.getTransactions(event.month, event.year);

    if (result.isSuccess) {
      emit(state.copyWith(
        status: TransactionsStatus.success,
        transactions: result.data?.transactions ?? [],
        month: event.month,
        year: event.year,
      ));
    } else {
      emit(state.copyWith(
        status: TransactionsStatus.failure,
        errorMessage: result.errorMessage,
      ));
    }
  }

  Future<void> _onTransactionDeleteRequested(
    TransactionDeleteRequested event,
    Emitter<TransactionsState> emit,
  ) async {
    final result = await _repository.deleteTransaction(event.transactionId);

    if (result.isSuccess) {
      // Refresh transactions
      add(TransactionsRequested(month: state.month, year: state.year));
    } else {
      emit(state.copyWith(errorMessage: result.errorMessage));
    }
  }

  Future<void> _onMonthChanged(
    MonthChanged event,
    Emitter<TransactionsState> emit,
  ) async {
    emit(state.copyWith(month: event.month, year: event.year));
    add(TransactionsRequested(month: event.month, year: event.year));
  }
}
