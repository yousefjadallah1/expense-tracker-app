import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/wallet_model.dart';

abstract class HomeRemoteDataSource {
  Future<HomeDataModel> getHomeData();
  Future<void> updateBudget(double budget);
  Future<TransactionModel> addTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient _apiClient;

  HomeRemoteDataSourceImpl(this._apiClient);

  @override
  Future<HomeDataModel> getHomeData() async {
    try {
      final response = await _apiClient.get(ApiConstants.wallet);
      if (response.data['success'] == true) {
        return HomeDataModel.fromJson(response.data['data']);
      }
      throw ServerException(
        message: response.data['message'] ?? 'Failed to fetch home data',
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to fetch home data',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> updateBudget(double budget) async {
    try {
      final response = await _apiClient.put(
        ApiConstants.walletBudget,
        data: {'budget': budget},
      );
      if (response.data['success'] != true) {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to update budget',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to update budget',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<TransactionModel> addTransaction(TransactionModel transaction) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.transactions,
        data: transaction.toJson(),
      );
      if (response.data['success'] == true) {
        return TransactionModel.fromJson(response.data['data']['transaction']);
      }
      throw ServerException(
        message: response.data['message'] ?? 'Failed to add transaction',
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to add transaction',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    try {
      final response = await _apiClient.delete(
        '${ApiConstants.transactions}/$id',
      );
      if (response.data['success'] != true) {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to delete transaction',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to delete transaction',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
