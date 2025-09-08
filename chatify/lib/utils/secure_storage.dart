import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async =>
      await _storage.write(key: 'token', value: token);

  static Future<void> saveUserId(String userId) async =>
      await _storage.write(key: 'userId', value: userId);

  static Future<String?> getToken() async =>
      await _storage.read(key: 'token');

  static Future<String?> getUserId() async =>
      await _storage.read(key: 'userId');

  static Future<void> clear() async => await _storage.deleteAll();
}
