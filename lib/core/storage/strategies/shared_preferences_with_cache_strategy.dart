import 'package:shared_preferences/shared_preferences.dart';
import '../storage_strategy.dart';

/// {@template shared_preferences_with_cache_strategy}
/// Implementation of [StorageStrategy] using SharedPreferencesWithCache.
/// This strategy:
/// - Uses a local cache for synchronous get operations
/// - Better performance for frequent reads
/// - Requires careful management in multi-isolate scenarios
/// {@endtemplate}
class SharedPreferencesWithCacheStrategy implements StorageStrategy {
  SharedPreferencesWithCache? _prefs;
  final Set<String>? _allowList;

  SharedPreferencesWithCacheStrategy({Set<String>? allowList})
      : _allowList = allowList;

  @override
  Future<void> init() async {
    if (_prefs != null) return;

    _prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(
        allowList: _allowList,
      ),
    );
  }

  Future<void> _ensureInitialized() async {
    if (_prefs == null) {
      await init();
    }
  }

  @override
  Future<bool> setString(String key, String value) async {
    try {
      await _ensureInitialized();
      await _prefs!.setString(key, value);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String?> getString(String key) async {
    try {
      await _ensureInitialized();
      return _prefs!.getString(key);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> setInt(String key, int value) async {
    try {
      await _ensureInitialized();
      await _prefs!.setInt(key, value);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<int?> getInt(String key) async {
    try {
      await _ensureInitialized();
      return _prefs!.getInt(key);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> setDouble(String key, double value) async {
    try {
      await _ensureInitialized();
      await _prefs!.setDouble(key, value);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<double?> getDouble(String key) async {
    try {
      await _ensureInitialized();
      return _prefs!.getDouble(key);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    try {
      await _ensureInitialized();
      await _prefs!.setBool(key, value);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool?> getBool(String key) async {
    try {
      await _ensureInitialized();
      return _prefs!.getBool(key);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> setStringList(String key, List<String> value) async {
    try {
      await _ensureInitialized();
      await _prefs!.setStringList(key, value);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<String>?> getStringList(String key) async {
    try {
      await _ensureInitialized();
      return _prefs!.getStringList(key);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> containsKey(String key) async {
    try {
      await _ensureInitialized();
      return _prefs!.containsKey(key);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> remove(String key) async {
    try {
      await _ensureInitialized();
      await _prefs!.remove(key);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> clear({Set<String>? allowList}) async {
    try {
      await _ensureInitialized();
      // Note: allowList is set at creation time for WithCache
      await _prefs!.clear();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Set<String>> getKeys() async {
    try {
      await _ensureInitialized();
      return _prefs!.keys;
    } catch (e) {
      return {};
    }
  }

  @override
  Future<void> reload() async {
    try {
      await _ensureInitialized();
      await _prefs!.reloadCache();
    } catch (e) {
      // Ignore reload errors
    }
  }
}
