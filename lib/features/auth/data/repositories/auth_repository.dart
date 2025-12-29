import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/secure_storage.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _storageService;

  AuthRepository(this._remoteDataSource, this._storageService);

  Future<AuthResult> login(String email, String password) async {
    try {
      final response = await _remoteDataSource.login(email, password);

      if (response.token.isNotEmpty) {
        await _storageService.saveToken(response.token);
        print('✅ Token saved after login');

        // Verify
        final saved = await _storageService.getToken();
        print('🔍 Verified token saved: ${saved != null && saved.isNotEmpty}');
      } else {
        print('❌ No token received from login');
        return AuthResult.failure('No token received');
      }

      return AuthResult.success(response.user);
    } on ServerException catch (e) {
      return AuthResult.failure(e.message);
    } catch (e) {
      print('❌ Login error: $e');
      return AuthResult.failure('An unexpected error occurred');
    }
  }

  Future<AuthResult> register(
    String email,
    String password,
    String? name,
  ) async {
    try {
      final response = await _remoteDataSource.register(email, password, name);

      if (response.token.isNotEmpty) {
        await _storageService.saveToken(response.token);
        print('✅ Token saved after register');
      }

      return AuthResult.success(response.user, message: response.message);
    } on ServerException catch (e) {
      return AuthResult.failure(e.message);
    } catch (e) {
      print('❌ Register error: $e');
      return AuthResult.failure('An unexpected error occurred');
    }
  }

  Future<void> logout() async {
    await _storageService.deleteToken();
  }

  Future<bool> isLoggedIn() async {
    return await _storageService.hasToken();
  }
}

class AuthResult {
  final bool isSuccess;
  final UserModel? user;
  final String? errorMessage;
  final String? successMessage;

  AuthResult._({
    required this.isSuccess,
    this.user,
    this.errorMessage,
    this.successMessage,
  });

  factory AuthResult.success(UserModel? user, {String? message}) {
    return AuthResult._(isSuccess: true, user: user, successMessage: message);
  }

  factory AuthResult.failure(String message) {
    return AuthResult._(isSuccess: false, errorMessage: message);
  }
}
