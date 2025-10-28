import 'dart:convert';

import 'cache_helper.dart';
import 'storage_keys.dart';

/// {@template local_storage_repository}
/// Repository for managing local storage operations.
/// Provides high-level methods for common storage patterns.
/// {@endtemplate}
class LocalStorageRepository {
  final CacheHelper _cacheHelper;

  LocalStorageRepository(this._cacheHelper);

  // ==================== Authentication ====================

  /// Saves authentication tokens
  Future<bool> saveAuthTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final results = await Future.wait([
      _cacheHelper.setString(StorageKeys.accessToken, accessToken),
      _cacheHelper.setString(StorageKeys.refreshToken, refreshToken),
      _cacheHelper.setBool(StorageKeys.isLoggedIn, true),
    ]);
    return results.every((result) => result);
  }

  /// Gets the access token
  Future<String?> getAccessToken() =>
      _cacheHelper.getString(StorageKeys.accessToken);

  /// Gets the refresh token
  Future<String?> getRefreshToken() =>
      _cacheHelper.getString(StorageKeys.refreshToken);

  /// Checks if user is logged in
  Future<bool> isLoggedIn() async {
    final isLoggedIn = await _cacheHelper.getBool(StorageKeys.isLoggedIn);
    return isLoggedIn ?? false;
  }

  /// Saves user ID
  Future<bool> saveUserId(String userId) =>
      _cacheHelper.setString(StorageKeys.userId, userId);

  /// Gets user ID
  Future<String?> getUserId() => _cacheHelper.getString(StorageKeys.userId);

  /// Saves user email
  Future<bool> saveUserEmail(String email) =>
      _cacheHelper.setString(StorageKeys.userEmail, email);

  /// Gets user email
  Future<String?> getUserEmail() =>
      _cacheHelper.getString(StorageKeys.userEmail);

  /// Clears authentication data (logout)
  Future<bool> clearAuthData() async {
    final results = await Future.wait([
      _cacheHelper.remove(StorageKeys.accessToken),
      _cacheHelper.remove(StorageKeys.refreshToken),
      _cacheHelper.remove(StorageKeys.userId),
      _cacheHelper.remove(StorageKeys.userEmail),
      _cacheHelper.setBool(StorageKeys.isLoggedIn, false),
      _cacheHelper.remove(StorageKeys.onboardingVersion),
      _cacheHelper.remove(StorageKeys.hasSeenOnboarding),
    ]);
    return results.every((result) => result);
  }

  // ==================== Onboarding ====================

  /// Marks onboarding as completed
  Future<bool> setOnboardingCompleted({int version = 1}) async {
    final results = await Future.wait([
      _cacheHelper.setBool(StorageKeys.hasSeenOnboarding, true),
      _cacheHelper.setInt(StorageKeys.onboardingVersion, version),
    ]);
    return results.every((result) => result);
  }

  /// Checks if onboarding has been completed
  Future<bool> hasSeenOnboarding() async {
    final hasSeen = await _cacheHelper.getBool(StorageKeys.hasSeenOnboarding);
    return hasSeen ?? false;
  }

  /// Gets onboarding version
  Future<int> getOnboardingVersion() async {
    final version = await _cacheHelper.getInt(StorageKeys.onboardingVersion);
    return version ?? 0;
  }

  // ==================== Settings ====================

  /// Saves settings as JSON
  Future<bool> saveSettings(Map<String, dynamic> settings) {
    final json = jsonEncode(settings);
    return _cacheHelper.setString(StorageKeys.settings, json);
  }

  /// Gets settings as JSON
  Future<Map<String, dynamic>?> getSettings() async {
    final json = await _cacheHelper.getString(StorageKeys.settings);
    if (json == null) return null;
    try {
      return jsonDecode(json) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Saves theme mode
  Future<bool> saveThemeMode(String themeMode) =>
      _cacheHelper.setString(StorageKeys.themeMode, themeMode);

  /// Gets theme mode
  Future<String?> getThemeMode() =>
      _cacheHelper.getString(StorageKeys.themeMode);

  /// Saves locale/language code
  Future<bool> saveLocale(String languageCode) =>
      _cacheHelper.setString(StorageKeys.languageCode, languageCode);

  /// Gets locale/language code
  Future<String?> getLocale() =>
      _cacheHelper.getString(StorageKeys.languageCode);

  // ==================== Health Devices ====================

  /// Saves devices list as JSON
  Future<bool> saveDevices(List<Map<String, dynamic>> devices) {
    final json = jsonEncode(devices);
    return _cacheHelper.setString(StorageKeys.savedDevices, json);
  }

  /// Gets devices list
  Future<List<Map<String, dynamic>>?> getDevices() async {
    final json = await _cacheHelper.getString(StorageKeys.savedDevices);
    if (json == null) return null;
    try {
      final list = jsonDecode(json) as List;
      return list.cast<Map<String, dynamic>>();
    } catch (e) {
      return null;
    }
  }

  /// Saves device readings as JSON
  Future<bool> saveDeviceReadings(Map<String, dynamic> readings) {
    final json = jsonEncode(readings);
    return _cacheHelper.setString(StorageKeys.deviceReadings, json);
  }

  /// Gets device readings
  Future<Map<String, dynamic>?> getDeviceReadings() async {
    final json = await _cacheHelper.getString(StorageKeys.deviceReadings);
    if (json == null) return null;
    try {
      return jsonDecode(json) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Saves last sync timestamp
  Future<bool> saveLastSyncTime(DateTime dateTime) => _cacheHelper.setString(
        StorageKeys.lastSyncTime,
        dateTime.toIso8601String(),
      );

  /// Gets last sync timestamp
  Future<DateTime?> getLastSyncTime() async {
    final timeString = await _cacheHelper.getString(StorageKeys.lastSyncTime);
    if (timeString == null) return null;
    try {
      return DateTime.parse(timeString);
    } catch (e) {
      return null;
    }
  }

  // ==================== User Preferences ====================

  /// Saves notification preference
  Future<bool> setNotificationsEnabled(bool enabled) =>
      _cacheHelper.setBool(StorageKeys.notificationsEnabled, enabled);

  /// Gets notification preference
  Future<bool> getNotificationsEnabled() async {
    final enabled =
        await _cacheHelper.getBool(StorageKeys.notificationsEnabled);
    return enabled ?? true; // Default to enabled
  }

  /// Saves biometrics preference
  Future<bool> setBiometricsEnabled(bool enabled) =>
      _cacheHelper.setBool(StorageKeys.biometricsEnabled, enabled);

  /// Gets biometrics preference
  Future<bool> getBiometricsEnabled() async {
    final enabled = await _cacheHelper.getBool(StorageKeys.biometricsEnabled);
    return enabled ?? false; // Default to disabled
  }

  /// Saves auto-sync preference
  Future<bool> setAutoSyncEnabled(bool enabled) =>
      _cacheHelper.setBool(StorageKeys.autoSyncEnabled, enabled);

  /// Gets auto-sync preference
  Future<bool> getAutoSyncEnabled() async {
    final enabled = await _cacheHelper.getBool(StorageKeys.autoSyncEnabled);
    return enabled ?? true; // Default to enabled
  }

  // ==================== App State ====================

  /// Saves app version
  Future<bool> saveAppVersion(String version) =>
      _cacheHelper.setString(StorageKeys.appVersion, version);

  /// Gets app version
  Future<String?> getAppVersion() =>
      _cacheHelper.getString(StorageKeys.appVersion);

  /// Saves last update check timestamp
  Future<bool> saveLastUpdateCheck(DateTime dateTime) => _cacheHelper.setString(
        StorageKeys.lastUpdateCheck,
        dateTime.toIso8601String(),
      );

  /// Gets last update check timestamp
  Future<DateTime?> getLastUpdateCheck() async {
    final timeString =
        await _cacheHelper.getString(StorageKeys.lastUpdateCheck);
    if (timeString == null) return null;
    try {
      return DateTime.parse(timeString);
    } catch (e) {
      return null;
    }
  }

  /// Saves crash reporting preference
  Future<bool> setCrashReportingEnabled(bool enabled) =>
      _cacheHelper.setBool(StorageKeys.crashReportingEnabled, enabled);

  /// Gets crash reporting preference
  Future<bool> getCrashReportingEnabled() async {
    final enabled =
        await _cacheHelper.getBool(StorageKeys.crashReportingEnabled);
    return enabled ?? true; // Default to enabled
  }

  // ==================== Utility Methods ====================

  /// Clears all data (use with caution!)
  Future<bool> clearAll() => _cacheHelper.clear();

  /// Clears all data except critical keys
  Future<bool> clearAllExceptCritical() =>
      _cacheHelper.clear(allowList: StorageKeys.criticalKeys);

  /// Performs a full logout (clears specific keys)
  Future<bool> performLogout() async {
    // Clear auth data and device data
    final keysToRemove = StorageKeys.clearableOnLogout;
    final results = await Future.wait(
      keysToRemove.map((key) => _cacheHelper.remove(key)),
    );
    return results.every((result) => result);
  }

  /// Checks if a key exists
  Future<bool> containsKey(String key) => _cacheHelper.containsKey(key);

  /// Gets all stored keys
  Future<Set<String>> getAllKeys() => _cacheHelper.getKeys();

  /// Reloads data from storage (useful for multi-isolate scenarios)
  Future<void> reload() => _cacheHelper.reload();
}
