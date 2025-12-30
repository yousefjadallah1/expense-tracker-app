import 'package:equatable/equatable.dart';
import '../../../home/data/models/wallet_model.dart';

enum TransactionsStatus { initial, loading, success, failure }

class TransactionsState extends Equatable {
  final TransactionsStatus status;
  final List<TransactionModel> transactions;
  final int month;
  final int year;
  final String? errorMessage;

  const TransactionsState({
    this.status = TransactionsStatus.initial,
    this.transactions = const [],
    required this.month,
    required this.year,
    this.errorMessage,
  });

  TransactionsState copyWith({
    TransactionsStatus? status,
    List<TransactionModel>? transactions,
    int? month,
    int? year,
    String? errorMessage,
  }) {
    return TransactionsState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      month: month ?? this.month,
      year: year ?? this.year,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, transactions, month, year, errorMessage];
}
