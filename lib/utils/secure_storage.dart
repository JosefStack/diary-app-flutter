import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// A [LocalStorage] implementation that uses [FlutterSecureStorage] to
/// securely persist the Supabase session.
class SecureLocalStorage extends LocalStorage {
  final _storage = const FlutterSecureStorage();
  static const _key = 'supabase_session';

  @override
  Future<void> initialize() async {}

  @override
  Future<String?> accessToken() async {
    return await _storage.read(key: _key);
  }

  @override
  Future<void> removePersistedSession() async {
    await _storage.delete(key: _key);
  }

  @override
  Future<void> persistSession(String persistSessionString) async {
    await _storage.write(key: _key, value: persistSessionString);
  }

  @override
  Future<bool> hasAccessToken() async {
    return await _storage.containsKey(key: _key);
  }
}
