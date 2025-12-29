import '../../../../core/errors/exceptions.dart';
import '../datasources/home_remote_datasource.dart';
import '../models/wallet_model.dart';

class HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepository(this._remoteDataSource);

  Future<HomeResult<HomeDataModel>> getHomeData() async {
    try {
      final data = await _remoteDataSource.getHomeData();
      return HomeResult.success(data);
    } on ServerException catch (e) {
      return HomeResult.failure(e.message);
    } catch (e) {
      return HomeResult.failure('An unexpected error occurred');
    }
  }

  Future<HomeResult<void>> updateBudget(double budget) async {
    try {
      await _remoteDataSource.updateBudget(budget);
      return HomeResult.success(null);
    } on ServerException catch (e) {
      return HomeResult.failure(e.message);
    } catch (e) {
      return HomeResult.failure('An unexpected error occurred');
    }
  }

  Future<HomeResult<TransactionModel>> addTransaction(
    TransactionModel transaction,
  ) async {
    try {
      final result = await _remoteDataSource.addTransaction(transaction);
      return HomeResult.success(result);
    } on ServerException catch (e) {
      return HomeResult.failure(e.message);
    } catch (e) {
      return HomeResult.failure('An unexpected error occurred');
    }
  }

  Future<HomeResult<void>> deleteTransaction(String id) async {
    try {
      await _remoteDataSource.deleteTransaction(id);
      return HomeResult.success(null);
    } on ServerException catch (e) {
      return HomeResult.failure(e.message);
    } catch (e) {
      return HomeResult.failure('An unexpected error occurred');
    }
  }
}

class HomeResult<T> {
  final bool isSuccess;
  final T? data;
  final String? errorMessage;

  HomeResult._({required this.isSuccess, this.data, this.errorMessage});

  factory HomeResult.success(T? data) {
    return HomeResult._(isSuccess: true, data: data);
  }

  factory HomeResult.failure(String message) {
    return HomeResult._(isSuccess: false, errorMessage: message);
  }
}
