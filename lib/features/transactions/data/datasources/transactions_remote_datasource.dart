import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../home/data/models/wallet_model.dart';

abstract class TransactionsRemoteDataSource {
  Future<TransactionsDataModel> getTransactions(int month, int year);
  Future<void> deleteTransaction(String id);
}

class TransactionsRemoteDataSourceImpl implements TransactionsRemoteDataSource {
  final ApiClient _apiClient;

  TransactionsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<TransactionsDataModel> getTransactions(int month, int year) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.transactions}?month=$month&year=$year',
      );
      if (response.data['success'] == true) {
        return TransactionsDataModel.fromJson(response.data['data']);
      }
      throw ServerException(
        message: response.data['message'] ?? 'Failed to fetch transactions',
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to fetch transactions',
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

class TransactionsDataModel {
  final List<TransactionModel> transactions;
  final int month;
  final int year;

  TransactionsDataModel({
    required this.transactions,
    required this.month,
    required this.year,
  });

  factory TransactionsDataModel.fromJson(Map<String, dynamic> json) {
    return TransactionsDataModel(
      transactions: (json['transactions'] as List?)
              ?.map((t) => TransactionModel.fromJson(t))
              .toList() ??
          [],
      month: json['month'] ?? 1,
      year: json['year'] ?? 2025,
    );
  }
}
