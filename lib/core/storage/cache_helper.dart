import 'storage_strategy.dart';

/// {@template cache_helper}
/// A unified interface for cache storage operations.
/// This class uses the Strategy Pattern to allow switching between
/// different storage implementations (SharedPreferences, Hive, Remote, etc.)
/// {@endtemplate}
class CacheHelper {
  final StorageStrategy _strategy;

  /// Creates a CacheHelper with the specified storage strategy
  CacheHelper(this._strategy);

  /// Initializes the storage
  Future<void> init() => _strategy.init();

  // ==================== String Operations ====================

  /// Stores a string value
  Future<bool> setString(String key, String value) =>
      _strategy.setString(key, value);

  /// Retrieves a string value
  Future<String?> getString(String key) => _strategy.getString(key);

  // ==================== Integer Operations ====================

  /// Stores an integer value
  Future<bool> setInt(String key, int value) => _strategy.setInt(key, value);

  /// Retrieves an integer value
  Future<int?> getInt(String key) => _strategy.getInt(key);

  // ==================== Double Operations ====================

  /// Stores a double value
  Future<bool> setDouble(String key, double value) =>
      _strategy.setDouble(key, value);

  /// Retrieves a double value
  Future<double?> getDouble(String key) => _strategy.getDouble(key);

  // ==================== Boolean Operations ====================

  /// Stores a boolean value
  Future<bool> setBool(String key, bool value) => _strategy.setBool(key, value);

  /// Retrieves a boolean value
  Future<bool?> getBool(String key) => _strategy.getBool(key);

  // ==================== String List Operations ====================

  /// Stores a list of strings
  Future<bool> setStringList(String key, List<String> value) =>
      _strategy.setStringList(key, value);

  /// Retrieves a list of strings
  Future<List<String>?> getStringList(String key) =>
      _strategy.getStringList(key);

  // ==================== Generic Operations ====================

  /// Checks if a key exists in storage
  Future<bool> containsKey(String key) => _strategy.containsKey(key);

  /// Removes a value by key
  Future<bool> remove(String key) => _strategy.remove(key);

  /// Clears all stored values
  ///
  /// [allowList] - Optional set of keys to preserve during clear
  Future<bool> clear({Set<String>? allowList}) =>
      _strategy.clear(allowList: allowList);

  /// Gets all keys in storage
  Future<Set<String>> getKeys() => _strategy.getKeys();

  /// Reloads data from storage (useful for multi-isolate scenarios)
  Future<void> reload() => _strategy.reload();

  // ==================== Legacy Support (Deprecated) ====================

  /// @deprecated Use type-specific methods instead (setString, setInt, etc.)
  @Deprecated('Use type-specific methods like setString, setInt, etc.')
  Future<bool> setValue<T>({required String key, required T value}) async {
    if (value is String) return setString(key, value);
    if (value is int) return setInt(key, value);
    if (value is double) return setDouble(key, value);
    if (value is bool) return setBool(key, value);
    if (value is List<String>) return setStringList(key, value);
    throw UnsupportedError('Type ${T.toString()} is not supported');
  }

  /// @deprecated Use type-specific methods instead (getString, getInt, etc.)
  @Deprecated('Use type-specific methods like getString, getInt, etc.')
  Future<T?> getValue<T>({required String key, T? defaultValue}) async {
    if (T == String) return (await getString(key) ?? defaultValue) as T?;
    if (T == int) return (await getInt(key) ?? defaultValue) as T?;
    if (T == double) return (await getDouble(key) ?? defaultValue) as T?;
    if (T == bool) return (await getBool(key) ?? defaultValue) as T?;
    if (T == List<String>) {
      return (await getStringList(key) ?? defaultValue) as T?;
    }
    return defaultValue;
  }

  /// @deprecated Use containsKey instead
  @Deprecated('Use containsKey instead')
  Future<bool> hasKey(String key) => containsKey(key);

  /// @deprecated Use remove instead
  @Deprecated('Use remove instead')
  Future<bool> removeValue(String key) => remove(key);
}
