import '../../../../core/errors/exceptions.dart';
import '../datasources/transactions_remote_datasource.dart';

class TransactionsRepository {
  final TransactionsRemoteDataSource _remoteDataSource;

  TransactionsRepository(this._remoteDataSource);

  Future<TransactionsResult<TransactionsDataModel>> getTransactions(
    int month,
    int year,
  ) async {
    try {
      final data = await _remoteDataSource.getTransactions(month, year);
      return TransactionsResult.success(data);
    } on ServerException catch (e) {
      return TransactionsResult.failure(e.message);
    } catch (e) {
      return TransactionsResult.failure('An unexpected error occurred');
    }
  }

  Future<TransactionsResult<void>> deleteTransaction(String id) async {
    try {
      await _remoteDataSource.deleteTransaction(id);
      return TransactionsResult.success(null);
    } on ServerException catch (e) {
      return TransactionsResult.failure(e.message);
    } catch (e) {
      return TransactionsResult.failure('An unexpected error occurred');
    }
  }
}

class TransactionsResult<T> {
  final bool isSuccess;
  final T? data;
  final String? errorMessage;

  TransactionsResult._({required this.isSuccess, this.data, this.errorMessage});

  factory TransactionsResult.success(T? data) {
    return TransactionsResult._(isSuccess: true, data: data);
  }

  factory TransactionsResult.failure(String message) {
    return TransactionsResult._(isSuccess: false, errorMessage: message);
  }
}
