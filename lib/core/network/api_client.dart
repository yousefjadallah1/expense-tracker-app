import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';

class ApiClient {
  final Dio _dio;
  final FlutterSecureStorage _storage;
  bool _isRefreshing = false;

  ApiClient({required FlutterSecureStorage storage})
    : _storage = storage,
      _dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(seconds: 100),
          receiveTimeout: const Duration(seconds: 100),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      ) {
    _dio.interceptors.add(_authInterceptor());
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
      ),
    );
  }

  InterceptorsWrapper _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'auth_token');

        print('🔐 [${options.method}] ${options.path}');
        print(
          '🔑 Token: ${token != null ? "EXISTS (${token.substring(0, 20)}...)" : "NULL"}',
        );

        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        handler.next(options);
      },
      onResponse: (response, handler) {
        print(
          '✅ Response ${response.statusCode}: ${response.requestOptions.path}',
        );
        handler.next(response);
      },
      onError: (error, handler) async {
        print(
          '❌ Error ${error.response?.statusCode}: ${error.requestOptions.path}',
        );

        if (error.response?.statusCode == 401 && !_isRefreshing) {
          print('🔄 Token expired, attempting refresh...');

          final refreshed = await _refreshToken();

          if (refreshed) {
            print('✅ Token refreshed, retrying original request...');
            try {
              final token = await _storage.read(key: 'auth_token');
              final options = error.requestOptions;
              options.headers['Authorization'] = 'Bearer $token';

              final response = await Dio().fetch(options);
              return handler.resolve(response);
            } catch (e) {
              print('❌ Retry failed: $e');
            }
          } else {
            print('❌ Refresh failed, clearing token');
            await _storage.delete(key: 'auth_token');
          }
        }

        handler.next(error);
      },
    );
  }

  Future<bool> _refreshToken() async {
    _isRefreshing = true;
    try {
      final currentToken = await _storage.read(key: 'auth_token');

      if (currentToken == null || currentToken.isEmpty) {
        _isRefreshing = false;
        return false;
      }

      final response = await Dio().post(
        '${ApiConstants.baseUrl}${ApiConstants.refreshToken}',
        data: {'token': currentToken},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      // Structure: { success: true, data: { token: "..." } }
      if (response.statusCode == 200 && response.data['success'] == true) {
        final newToken = response.data['data']['token'];
        await _storage.write(key: 'auth_token', value: newToken);
        print('✅ New token saved from refresh');
        _isRefreshing = false;
        return true;
      }
    } catch (e) {
      print('❌ Refresh error: $e');
    }

    _isRefreshing = false;
    return false;
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) {
    return _dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) {
    return _dio.put(path, data: data);
  }

  Future<Response> delete(String path) {
    return _dio.delete(path);
  }
}
