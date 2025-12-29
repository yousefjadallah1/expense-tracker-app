import 'package:equatable/equatable.dart';
import '../../data/models/wallet_model.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeDataRequested extends HomeEvent {}

class BudgetUpdated extends HomeEvent {
  final double budget;
  BudgetUpdated(this.budget);

  @override
  List<Object?> get props => [budget];
}

class TransactionAdded extends HomeEvent {
  final TransactionModel transaction;
  TransactionAdded(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class TransactionDeleted extends HomeEvent {
  final String transactionId;
  TransactionDeleted(this.transactionId);

  @override
  List<Object?> get props => [transactionId];
}
