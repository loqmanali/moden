import 'storage.dart';

/// {@template storage_service}
/// Simple and easy-to-use storage service.
///
/// This is a simplified API that wraps LocalStorageRepository
/// for the most common use cases.
///
/// Usage:
/// ```dart
/// // Save data
/// await Storage.saveUserEmail('user@example.com');
/// await Storage.saveToken('my_token');
///
/// // Read data
/// final email = await Storage.getUserEmail();
/// final token = await Storage.getToken();
///
/// // Check login status
/// final isLoggedIn = await Storage.isLoggedIn();
///
/// // Logout
/// await Storage.logout();
/// ```
/// {@endtemplate}
class Storage {
  Storage._();

  /// Get the repository instance
  static LocalStorageRepository get _repo => StorageLocator.repository;

  // ==================== Quick Access Methods ====================

  /// Save user email
  static Future<bool> saveUserEmail(String email) => _repo.saveUserEmail(email);

  /// Get user email
  static Future<String?> getUserEmail() => _repo.getUserEmail();

  /// Save user ID
  static Future<bool> saveUserId(String userId) => _repo.saveUserId(userId);

  /// Get user ID
  static Future<String?> getUserId() => _repo.getUserId();

  /// Save authentication tokens
  static Future<bool> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) =>
      _repo.saveAuthTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

  /// Get access token
  static Future<String?> getToken() => _repo.getAccessToken();

  /// Get refresh token
  static Future<String?> getRefreshToken() => _repo.getRefreshToken();

  /// Check if user is logged in
  static Future<bool> isLoggedIn() => _repo.isLoggedIn();

  /// Logout (clear auth data)
  static Future<bool> logout() => _repo.clearAuthData();

  /// Complete logout (clear all user data)
  static Future<bool> completeLogout() => _repo.performLogout();

  // ==================== Onboarding ====================

  /// Mark onboarding as completed
  static Future<bool> completeOnboarding({int version = 1}) =>
      _repo.setOnboardingCompleted(version: version);

  /// Check if onboarding is completed
  static Future<bool> hasSeenOnboarding() => _repo.hasSeenOnboarding();

  // ==================== Settings ====================

  /// Save theme mode
  static Future<bool> saveTheme(String theme) => _repo.saveThemeMode(theme);

  /// Get theme mode
  static Future<String?> getTheme() => _repo.getThemeMode();

  /// Save language
  static Future<bool> saveLanguage(String languageCode) =>
      _repo.saveLocale(languageCode);

  /// Get language
  static Future<String?> getLanguage() => _repo.getLocale();

  /// Save settings
  static Future<bool> saveSettings(Map<String, dynamic> settings) =>
      _repo.saveSettings(settings);

  /// Get settings
  static Future<Map<String, dynamic>?> getSettings() => _repo.getSettings();

  // ==================== Preferences ====================

  /// Enable/disable notifications
  static Future<bool> setNotifications(bool enabled) =>
      _repo.setNotificationsEnabled(enabled);

  /// Check if notifications are enabled
  static Future<bool> areNotificationsEnabled() =>
      _repo.getNotificationsEnabled();

  /// Enable/disable biometrics
  static Future<bool> setBiometrics(bool enabled) =>
      _repo.setBiometricsEnabled(enabled);

  /// Check if biometrics are enabled
  static Future<bool> areBiometricsEnabled() => _repo.getBiometricsEnabled();

  // ==================== Generic Operations ====================

  /// Save any string value
  static Future<bool> saveString(String key, String value) =>
      StorageLocator.cacheHelper.setString(key, value);

  /// Get any string value
  static Future<String?> getString(String key) =>
      StorageLocator.cacheHelper.getString(key);

  /// Save any int value
  static Future<bool> saveInt(String key, int value) =>
      StorageLocator.cacheHelper.setInt(key, value);

  /// Get any int value
  static Future<int?> getInt(String key) =>
      StorageLocator.cacheHelper.getInt(key);

  /// Save any bool value
  static Future<bool> saveBool(String key, bool value) =>
      StorageLocator.cacheHelper.setBool(key, value);

  /// Get any bool value
  static Future<bool?> getBool(String key) =>
      StorageLocator.cacheHelper.getBool(key);

  /// Check if key exists
  static Future<bool> has(String key) =>
      StorageLocator.cacheHelper.containsKey(key);

  /// Remove a key
  static Future<bool> remove(String key) =>
      StorageLocator.cacheHelper.remove(key);

  /// Clear all data
  static Future<bool> clearAll() => _repo.clearAll();

  /// Reload data (useful for multi-isolate scenarios)
  static Future<void> reload() => _repo.reload();

  // ==================== Direct Repository Access ====================

  /// Get the repository instance for advanced operations
  static LocalStorageRepository get repository => _repo;
}
