import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/home_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;

  HomeBloc(this._homeRepository) : super(const HomeState()) {
    on<HomeDataRequested>(_onHomeDataRequested);
    on<BudgetUpdated>(_onBudgetUpdated);
    on<TransactionAdded>(_onTransactionAdded);
    on<TransactionDeleted>(_onTransactionDeleted);
  }

  Future<void> _onHomeDataRequested(
    HomeDataRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));

    final result = await _homeRepository.getHomeData();

    if (result.isSuccess) {
      emit(state.copyWith(status: HomeStatus.success, homeData: result.data));
    } else {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage: result.errorMessage,
        ),
      );
    }
  }

  Future<void> _onBudgetUpdated(
    BudgetUpdated event,
    Emitter<HomeState> emit,
  ) async {
    final result = await _homeRepository.updateBudget(event.budget);

    if (result.isSuccess) {
      // Refresh home data
      add(HomeDataRequested());
    } else {
      emit(state.copyWith(errorMessage: result.errorMessage));
    }
  }

  Future<void> _onTransactionAdded(
    TransactionAdded event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isAddingTransaction: true));

    final result = await _homeRepository.addTransaction(event.transaction);

    if (result.isSuccess) {
      emit(state.copyWith(isAddingTransaction: false));
      // Refresh home data
      add(HomeDataRequested());
    } else {
      emit(
        state.copyWith(
          isAddingTransaction: false,
          errorMessage: result.errorMessage,
        ),
      );
    }
  }

  Future<void> _onTransactionDeleted(
    TransactionDeleted event,
    Emitter<HomeState> emit,
  ) async {
    final result = await _homeRepository.deleteTransaction(event.transactionId);

    if (result.isSuccess) {
      // Refresh home data
      add(HomeDataRequested());
    } else {
      emit(state.copyWith(errorMessage: result.errorMessage));
    }
  }
}
