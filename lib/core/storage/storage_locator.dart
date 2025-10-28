import 'package:get_it/get_it.dart';

import '../storage/cache_helper.dart';
import '../storage/cache_helper_factory.dart';
import '../storage/local_storage_repository.dart';

/// {@template storage_locator}
/// Service Locator for Storage dependencies using GetIt.
///
/// This provides easy access to storage services throughout the app.
/// {@endtemplate}
///

final GetIt di = GetIt.instance;

class StorageLocator {
  StorageLocator._();

  static final GetIt _getIt = di;

  /// Initialize storage dependencies
  ///
  /// [useHive] - Use Hive instead of SharedPreferences (default: false)
  /// [hiveBoxName] - Name of Hive box if using Hive
  /// [hiveEncryptionKey] - Encryption key for Hive if needed
  static Future<void> init({
    bool useHive = false,
    String hiveBoxName = 'app_storage',
    String? hiveEncryptionKey,
  }) async {
    // Create CacheHelper based on strategy
    late final CacheHelper cacheHelper;

    if (useHive) {
      cacheHelper = await CacheHelperFactory.createWithHive(
        boxName: hiveBoxName,
        encryptionKey: hiveEncryptionKey,
      );
    } else {
      cacheHelper = CacheHelperFactory.createAsync();
      await cacheHelper.init();
    }

    // Register CacheHelper as singleton
    _getIt.registerSingleton<CacheHelper>(cacheHelper);

    // Register LocalStorageRepository as singleton
    _getIt.registerSingleton<LocalStorageRepository>(
      LocalStorageRepository(cacheHelper),
    );
  }

  /// Get CacheHelper instance
  static CacheHelper get cacheHelper => _getIt<CacheHelper>();

  /// Get LocalStorageRepository instance
  static LocalStorageRepository get repository =>
      _getIt<LocalStorageRepository>();

  /// Reset all registrations (useful for testing)
  static Future<void> reset() async {
    await _getIt.reset();
  }
}
