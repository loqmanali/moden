/// {@template storage_strategy}
/// Abstract interface for storage strategies.
/// This allows switching between different storage implementations
/// (SharedPreferences, Hive, Remote Backend, etc.)
/// {@endtemplate}
abstract class StorageStrategy {
  /// Initializes the storage
  Future<void> init();

  /// Stores a string value
  Future<bool> setString(String key, String value);

  /// Retrieves a string value
  Future<String?> getString(String key);

  /// Stores an integer value
  Future<bool> setInt(String key, int value);

  /// Retrieves an integer value
  Future<int?> getInt(String key);

  /// Stores a double value
  Future<bool> setDouble(String key, double value);

  /// Retrieves a double value
  Future<double?> getDouble(String key);

  /// Stores a boolean value
  Future<bool> setBool(String key, bool value);

  /// Retrieves a boolean value
  Future<bool?> getBool(String key);

  /// Stores a list of strings
  Future<bool> setStringList(String key, List<String> value);

  /// Retrieves a list of strings
  Future<List<String>?> getStringList(String key);

  /// Checks if a key exists
  Future<bool> containsKey(String key);

  /// Removes a value by key
  Future<bool> remove(String key);

  /// Clears all values (with optional allowList for safety)
  Future<bool> clear({Set<String>? allowList});

  /// Gets all keys
  Future<Set<String>> getKeys();

  /// Reloads data from storage (useful for multi-isolate scenarios)
  Future<void> reload();
}
