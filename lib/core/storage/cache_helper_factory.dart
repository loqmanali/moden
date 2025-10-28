import 'cache_helper.dart';
import 'storage_keys.dart';
import 'strategies/hive_strategy.dart';
import 'strategies/shared_preferences_async_strategy.dart';
import 'strategies/shared_preferences_with_cache_strategy.dart';

/// {@template cache_helper_factory}
/// Factory class for creating CacheHelper instances with different strategies.
/// {@endtemplate}
class CacheHelperFactory {
  CacheHelperFactory._();

  /// Creates a CacheHelper using SharedPreferencesAsync strategy.
  ///
  /// This is the **recommended** approach for most use cases:
  /// - Always provides latest data from platform storage
  /// - Works correctly with multiple isolates
  /// - No cache synchronization issues
  ///
  /// Use this when:
  /// - You need reliable data across isolates
  /// - You're using background services (like firebase_messaging)
  /// - You want to avoid cache-related bugs
  static CacheHelper createAsync() {
    return CacheHelper(SharedPreferencesAsyncStrategy());
  }

  /// Creates a CacheHelper using SharedPreferencesWithCache strategy.
  ///
  /// This approach uses a local cache for better read performance:
  /// - Faster synchronous-like reads after initialization
  /// - Good for frequent read operations
  /// - Requires careful management in multi-isolate scenarios
  ///
  /// Use this when:
  /// - You have frequent read operations
  /// - You're not using multiple isolates
  /// - Performance is critical
  ///
  /// [allowList] - Optional set of keys to restrict access to.
  /// If provided, only these keys can be accessed.
  /// Consider using [StorageKeys.allKeys] for a complete list.
  static Future<CacheHelper> createWithCache({
    Set<String>? allowList,
  }) async {
    final strategy = SharedPreferencesWithCacheStrategy(
      allowList: allowList,
    );
    await strategy.init();
    return CacheHelper(strategy);
  }

  /// Creates a CacheHelper using Hive strategy.
  ///
  /// Hive is a lightweight and blazing fast key-value database:
  /// - Much faster than SharedPreferences
  /// - No size limitations
  /// - Supports complex data types
  /// - Optional encryption support
  ///
  /// Use this when:
  /// - You need better performance
  /// - You're storing large amounts of data
  /// - You need encryption
  ///
  /// [boxName] - Name of the Hive box (default: 'app_storage')
  /// [encryptionKey] - Optional encryption key for secure storage
  static Future<CacheHelper> createWithHive({
    String boxName = 'app_storage',
    String? encryptionKey,
  }) async {
    final strategy = HiveStrategy(
      boxName: boxName,
      encryptionKey: encryptionKey,
    );
    await strategy.init();
    return CacheHelper(strategy);
  }

  /// Creates a default CacheHelper instance.
  /// Currently uses SharedPreferencesAsync as the default.
  static CacheHelper createDefault() => createAsync();

  /// Singleton instance for global access (uses Async strategy)
  static CacheHelper? _instance;

  /// Gets or creates a singleton CacheHelper instance.
  ///
  /// **Important**: This uses SharedPreferencesAsync strategy.
  /// If you need WithCache strategy, create your own instance.
  static CacheHelper get instance {
    _instance ??= createAsync();
    return _instance!;
  }

  /// Initializes the singleton instance.
  /// Call this at app startup for better performance.
  static Future<void> initializeSingleton() async {
    _instance = createAsync();
    await _instance!.init();
  }

  /// Resets the singleton instance (useful for testing)
  static void resetSingleton() {
    _instance = null;
  }
}
