import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> login(String email, String password);
  Future<AuthResponse> register(String email, String password, String? name);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      final json = response.data;
      print('📥 Login response: $json');

      // Structure: { success: true, message: "...", data: { token: "..." } }
      final data = json['data'] as Map<String, dynamic>?;
      final token = data?['token'] ?? '';

      print(
        '🔑 Extracted token: ${token.isNotEmpty ? "Found (${token.length} chars)" : "NOT FOUND"}',
      );

      return AuthResponse(
        token: token,
        user: null, // Login doesn't return user data
        message: json['message'],
      );
    } on DioException catch (e) {
      print('❌ Login error: ${e.response?.data}');
      throw ServerException(
        message: e.response?.data['message'] ?? 'Login failed',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<AuthResponse> register(
    String email,
    String password,
    String? name,
  ) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.register,
        data: {
          'email': email,
          'password': password,
          if (name != null) 'name': name,
        },
      );

      final json = response.data;
      print('📥 Register response: $json');

      // Structure: { success: true, message: "...", data: { id: "...", email: "...", token: "..." } }
      final data = json['data'] as Map<String, dynamic>?;
      final token = data?['token'] ?? '';

      print(
        '🔑 Extracted token: ${token.isNotEmpty ? "Found (${token.length} chars)" : "NOT FOUND"}',
      );

      UserModel? user;
      if (data != null && data['id'] != null) {
        user = UserModel(
          id: data['id'] ?? '',
          email: data['email'] ?? '',
          name: data['name'],
        );
      }

      return AuthResponse(token: token, user: user, message: json['message']);
    } on DioException catch (e) {
      print('❌ Register error: ${e.response?.data}');
      throw ServerException(
        message: e.response?.data['message'] ?? 'Registration failed',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
