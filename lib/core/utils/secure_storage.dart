import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService(this._storage);

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
    print('💾 Token saved (${token.length} chars)');
  }

  Future<String?> getToken() async {
    final token = await _storage.read(key: 'auth_token');
    print('📖 Token read: ${token != null ? "Found" : "Not found"}');
    return token;
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
    print('🗑️ Token deleted');
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
