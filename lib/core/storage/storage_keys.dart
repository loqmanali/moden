/// {@template storage_keys}
/// Centralized storage keys management.
/// All storage keys should be defined here to avoid typos and conflicts.
/// {@endtemplate}
class StorageKeys {
  StorageKeys._();

  // ==================== Authentication ====================
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String isLoggedIn = 'is_logged_in';

  // ==================== Onboarding ====================
  static const String hasSeenOnboarding = 'has_seen_onboarding';
  static const String onboardingVersion = 'onboarding_version';

  // ==================== Settings ====================
  static const String settings = 'settings';
  static const String themeMode = 'theme_mode';
  static const String locale = 'locale';
  static const String languageCode = 'language_code';

  // ==================== Health Devices ====================
  static const String savedDevices = 'saved_devices';
  static const String savedDevicesV2 = 'saved_devices_v2';
  static const String deviceReadings = 'device_readings';
  static const String lastSyncTime = 'last_sync_time';
  static const String devicesSelectedCategory = 'devices_selected_category';
  static const String selectedDeviceFilter = 'selected_device_filter';

  // ==================== User Preferences ====================
  static const String notificationsEnabled = 'notifications_enabled';
  static const String biometricsEnabled = 'biometrics_enabled';
  static const String autoSyncEnabled = 'auto_sync_enabled';

  // ==================== App State ====================
  static const String appVersion = 'app_version';
  static const String lastUpdateCheck = 'last_update_check';
  static const String crashReportingEnabled = 'crash_reporting_enabled';

  /// Get all keys as a set (useful for allowList in SharedPreferencesWithCache)
  static Set<String> get allKeys => {
        // Authentication
        accessToken,
        refreshToken,
        userId,
        userEmail,
        isLoggedIn,
        // Onboarding
        hasSeenOnboarding,
        onboardingVersion,
        // Settings
        settings,
        themeMode,
        locale,
        languageCode,
        // Health Devices
        savedDevices,
        savedDevicesV2,
        deviceReadings,
        lastSyncTime,
        devicesSelectedCategory,
        selectedDeviceFilter,
        // User Preferences
        notificationsEnabled,
        biometricsEnabled,
        autoSyncEnabled,
        // App State
        appVersion,
        lastUpdateCheck,
        crashReportingEnabled,
      };

  /// Get critical keys that should never be cleared accidentally
  static Set<String> get criticalKeys => {
        accessToken,
        refreshToken,
        userId,
        isLoggedIn,
      };

  /// Get keys that are safe to clear on logout
  static Set<String> get clearableOnLogout => {
        accessToken,
        refreshToken,
        userId,
        userEmail,
        isLoggedIn,
        savedDevices,
        deviceReadings,
        lastSyncTime,
      };
}
