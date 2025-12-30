import 'package:equatable/equatable.dart';

abstract class TransactionsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TransactionsRequested extends TransactionsEvent {
  final int month;
  final int year;

  TransactionsRequested({required this.month, required this.year});

  @override
  List<Object?> get props => [month, year];
}

class TransactionDeleteRequested extends TransactionsEvent {
  final String transactionId;

  TransactionDeleteRequested(this.transactionId);

  @override
  List<Object?> get props => [transactionId];
}

class MonthChanged extends TransactionsEvent {
  final int month;
  final int year;

  MonthChanged({required this.month, required this.year});

  @override
  List<Object?> get props => [month, year];
}
