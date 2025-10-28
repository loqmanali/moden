import 'package:shared_preferences/shared_preferences.dart';
import '../storage_strategy.dart';

/// {@template shared_preferences_async_strategy}
/// Implementation of [StorageStrategy] using SharedPreferencesAsync.
/// This is the recommended approach for new code as it:
/// - Always provides the latest data from platform storage
/// - Works correctly with multiple isolates
/// - No cache synchronization issues
/// {@endtemplate}
class SharedPreferencesAsyncStrategy implements StorageStrategy {
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();
  
  @override
  Future<void> init() async {
    // SharedPreferencesAsync doesn't require initialization
    // but we keep this method for interface consistency
  }

  @override
  Future<bool> setString(String key, String value) async {
    try {
      await _prefs.setString(key, value);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String?> getString(String key) async {
    try {
      return await _prefs.getString(key);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> setInt(String key, int value) async {
    try {
      await _prefs.setInt(key, value);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<int?> getInt(String key) async {
    try {
      return await _prefs.getInt(key);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> setDouble(String key, double value) async {
    try {
      await _prefs.setDouble(key, value);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<double?> getDouble(String key) async {
    try {
      return await _prefs.getDouble(key);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    try {
      await _prefs.setBool(key, value);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool?> getBool(String key) async {
    try {
      return await _prefs.getBool(key);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> setStringList(String key, List<String> value) async {
    try {
      await _prefs.setStringList(key, value);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<String>?> getStringList(String key) async {
    try {
      return await _prefs.getStringList(key);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> containsKey(String key) async {
    try {
      final keys = await _prefs.getKeys();
      return keys.contains(key);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> remove(String key) async {
    try {
      await _prefs.remove(key);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> clear({Set<String>? allowList}) async {
    try {
      await _prefs.clear(
        allowList: allowList,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Set<String>> getKeys() async {
    try {
      return await _prefs.getKeys();
    } catch (e) {
      return {};
    }
  }

  @override
  Future<void> reload() async {
    // SharedPreferencesAsync always reads from platform storage
    // so no reload is needed
  }
}
