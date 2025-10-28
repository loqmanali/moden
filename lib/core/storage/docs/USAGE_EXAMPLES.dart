// ignore_for_file: unused_local_variable, unused_element

/// ملف أمثلة لاستخدام نظام التخزين الجديد
/// هذا الملف للتوضيح فقط ولا يتم استخدامه في التطبيق
library;

import '../storage.dart';

// ============================================================
// مثال 1: استخدام LocalStorageRepository (الطريقة الموصى بها)
// ============================================================

class Example1_UsingRepository {
  Future<void> demonstrateUsage() async {
    // إنشاء repository instance
    final repository = LocalStorageRepository(
      CacheHelperFactory.instance,
    );

    // === Authentication ===
    // حفظ tokens
    await repository.saveAuthTokens(
      accessToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
      refreshToken: 'refresh_token_here',
    );

    // قراءة tokens
    final accessToken = await repository.getAccessToken();
    final refreshToken = await repository.getRefreshToken();
    final isLoggedIn = await repository.isLoggedIn();

    // حفظ معلومات المستخدم
    await repository.saveUserId('user_123');
    await repository.saveUserEmail('user@example.com');

    // تسجيل الخروج
    await repository.clearAuthData();

    // === Onboarding ===
    // تعيين onboarding كمكتمل
    await repository.setOnboardingCompleted(version: 2);

    // التحقق من الإكمال
    final hasSeen = await repository.hasSeenOnboarding();
    final version = await repository.getOnboardingVersion();

    // === Settings ===
    // حفظ الإعدادات
    await repository.saveSettings({
      'theme': 'dark',
      'language': 'ar',
      'notifications': true,
    });

    // قراءة الإعدادات
    final settings = await repository.getSettings();

    // حفظ theme mode
    await repository.saveThemeMode('dark');
    final theme = await repository.getThemeMode();

    // حفظ اللغة
    await repository.saveLocale('ar');
    final locale = await repository.getLocale();

    // === Health Devices ===
    // حفظ الأجهزة
    await repository.saveDevices([
      {
        'id': 'device_1',
        'name': 'Blood Pressure Monitor',
        'type': 'blood_pressure',
      },
      {
        'id': 'device_2',
        'name': 'Glucose Meter',
        'type': 'glucose',
      },
    ]);

    // قراءة الأجهزة
    final devices = await repository.getDevices();

    // حفظ القراءات
    await repository.saveDeviceReadings({
      'device_1': {
        'systolic': 120,
        'diastolic': 80,
        'pulse': 72,
        'timestamp': DateTime.now().toIso8601String(),
      },
    });

    // قراءة القراءات
    final readings = await repository.getDeviceReadings();

    // حفظ آخر وقت مزامنة
    await repository.saveLastSyncTime(DateTime.now());
    final lastSync = await repository.getLastSyncTime();

    // === User Preferences ===
    // الإشعارات
    await repository.setNotificationsEnabled(true);
    final notificationsEnabled = await repository.getNotificationsEnabled();

    // البصمة
    await repository.setBiometricsEnabled(true);
    final biometricsEnabled = await repository.getBiometricsEnabled();

    // المزامنة التلقائية
    await repository.setAutoSyncEnabled(true);
    final autoSyncEnabled = await repository.getAutoSyncEnabled();

    // === App State ===
    // حفظ إصدار التطبيق
    await repository.saveAppVersion('1.0.0');
    final appVersion = await repository.getAppVersion();

    // حفظ آخر فحص للتحديثات
    await repository.saveLastUpdateCheck(DateTime.now());
    final lastUpdateCheck = await repository.getLastUpdateCheck();

    // === Utility Methods ===
    // التحقق من وجود مفتاح
    final exists = await repository.containsKey(StorageKeys.accessToken);

    // الحصول على جميع المفاتيح
    final allKeys = await repository.getAllKeys();

    // إعادة تحميل البيانات (مفيد مع multiple isolates)
    await repository.reload();

    // مسح كل البيانات ماعدا الحساسة
    await repository.clearAllExceptCritical();

    // تسجيل خروج كامل
    await repository.performLogout();
  }
}

// ============================================================
// مثال 2: استخدام CacheHelper مباشرة
// ============================================================

class Example2_UsingCacheHelper {
  Future<void> demonstrateUsage() async {
    final cacheHelper = CacheHelperFactory.instance;

    // === String Operations ===
    await cacheHelper.setString(StorageKeys.userEmail, 'user@example.com');
    final email = await cacheHelper.getString(StorageKeys.userEmail);

    // === Integer Operations ===
    await cacheHelper.setInt(StorageKeys.onboardingVersion, 2);
    final version = await cacheHelper.getInt(StorageKeys.onboardingVersion);

    // === Boolean Operations ===
    await cacheHelper.setBool(StorageKeys.hasSeenOnboarding, true);
    final hasSeen = await cacheHelper.getBool(StorageKeys.hasSeenOnboarding);

    // === Double Operations ===
    await cacheHelper.setDouble('user_weight', 75.5);
    final weight = await cacheHelper.getDouble('user_weight');

    // === String List Operations ===
    await cacheHelper.setStringList('favorite_devices', [
      'device_1',
      'device_2',
      'device_3',
    ]);
    final favorites = await cacheHelper.getStringList('favorite_devices');

    // === Generic Operations ===
    // التحقق من وجود مفتاح
    final exists = await cacheHelper.containsKey(StorageKeys.accessToken);

    // حذف مفتاح
    await cacheHelper.remove(StorageKeys.accessToken);

    // الحصول على جميع المفاتيح
    final allKeys = await cacheHelper.getKeys();

    // مسح كل البيانات
    await cacheHelper.clear();

    // مسح كل البيانات ماعدا المحددة
    await cacheHelper.clear(
      allowList: StorageKeys.criticalKeys,
    );

    // إعادة تحميل البيانات
    await cacheHelper.reload();
  }
}

// ============================================================
// مثال 3: استخدام WithCache للأداء الأفضل
// ============================================================

class Example3_UsingWithCache {
  Future<void> demonstrateUsage() async {
    // إنشاء instance مع cache
    final cacheHelper = await CacheHelperFactory.createWithCache(
      allowList: StorageKeys.allKeys,
    );

    final repository = LocalStorageRepository(cacheHelper);

    // استخدام عادي
    await repository.saveUserEmail('user@example.com');
    final email = await repository.getUserEmail();

    // الأداء أفضل للقراءات المتكررة
    for (int i = 0; i < 100; i++) {
      final email = await repository.getUserEmail(); // سريع جداً
    }
  }
}

// ============================================================
// مثال 4: استخدام في BLoC/Cubit
// ============================================================

class Example4_UsingInBloc {
  final LocalStorageRepository _repository;

  Example4_UsingInBloc({LocalStorageRepository? repository})
      : _repository =
            repository ?? LocalStorageRepository(CacheHelperFactory.instance);

  Future<void> login(String email, String password) async {
    // ... login logic

    // حفظ tokens بعد تسجيل الدخول الناجح
    await _repository.saveAuthTokens(
      accessToken: 'access_token',
      refreshToken: 'refresh_token',
    );

    await _repository.saveUserEmail(email);
  }

  Future<void> logout() async {
    // مسح بيانات المصادقة
    await _repository.clearAuthData();

    // أو استخدام performLogout لمسح كل البيانات المتعلقة بالمستخدم
    await _repository.performLogout();
  }

  Future<bool> checkAuthStatus() async {
    return await _repository.isLoggedIn();
  }
}

// ============================================================
// مثال 5: استخدام في ViewModel (MVVM)
// ============================================================

class Example5_UsingInViewModel {
  final LocalStorageRepository _repository;

  Example5_UsingInViewModel({LocalStorageRepository? repository})
      : _repository =
            repository ?? LocalStorageRepository(CacheHelperFactory.instance);

  // Settings
  Future<Map<String, dynamic>?> loadSettings() async {
    return await _repository.getSettings();
  }

  Future<void> saveSettings(Map<String, dynamic> settings) async {
    await _repository.saveSettings(settings);
  }

  Future<void> updateTheme(String theme) async {
    await _repository.saveThemeMode(theme);
  }

  Future<void> updateLanguage(String languageCode) async {
    await _repository.saveLocale(languageCode);
  }

  // Preferences
  Future<void> toggleNotifications(bool enabled) async {
    await _repository.setNotificationsEnabled(enabled);
  }

  Future<bool> getNotificationsStatus() async {
    return await _repository.getNotificationsEnabled();
  }
}

// ============================================================
// مثال 6: استخدام في Service Layer
// ============================================================

class Example6_AuthService {
  final LocalStorageRepository _repository;

  Example6_AuthService({LocalStorageRepository? repository})
      : _repository =
            repository ?? LocalStorageRepository(CacheHelperFactory.instance);

  Future<void> saveAuthData({
    required String accessToken,
    required String refreshToken,
    required String userId,
    required String email,
  }) async {
    await _repository.saveAuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
    await _repository.saveUserId(userId);
    await _repository.saveUserEmail(email);
  }

  Future<String?> getAccessToken() async {
    return await _repository.getAccessToken();
  }

  Future<bool> isAuthenticated() async {
    final isLoggedIn = await _repository.isLoggedIn();
    final token = await _repository.getAccessToken();
    return isLoggedIn && token != null;
  }

  Future<void> clearAuthData() async {
    await _repository.clearAuthData();
  }
}

// ============================================================
// مثال 7: استخدام StorageKeys
// ============================================================

class Example7_UsingStorageKeys {
  Future<void> demonstrateUsage() async {
    final cacheHelper = CacheHelperFactory.instance;

    // استخدام المفاتيح المعرفة
    await cacheHelper.setString(
      StorageKeys.accessToken,
      'token',
    );

    await cacheHelper.setBool(
      StorageKeys.hasSeenOnboarding,
      true,
    );

    await cacheHelper.setInt(
      StorageKeys.onboardingVersion,
      2,
    );

    // الحصول على جميع المفاتيح
    final allKeys = StorageKeys.allKeys;
    print('Total keys: ${allKeys.length}');

    // المفاتيح الحساسة
    final criticalKeys = StorageKeys.criticalKeys;
    print('Critical keys: $criticalKeys');

    // المفاتيح القابلة للحذف عند Logout
    final clearableKeys = StorageKeys.clearableOnLogout;
    print('Clearable keys: $clearableKeys');
  }
}

// ============================================================
// مثال 8: Testing
// ============================================================

class Example8_Testing {
  // في ملف الاختبار
  void demonstrateTesting() {
    // يمكنك إنشاء mock للـ StorageStrategy
    // أو استخدام in-memory implementation للاختبار

    /*
    class MockStorageStrategy extends Mock implements StorageStrategy {}

    void main() {
      late CacheHelper cacheHelper;
      late MockStorageStrategy mockStrategy;

      setUp(() {
        mockStrategy = MockStorageStrategy();
        cacheHelper = CacheHelper(mockStrategy);
      });

      test('should save string value', () async {
        when(mockStrategy.setString('key', 'value'))
            .thenAnswer((_) async => true);

        final result = await cacheHelper.setString('key', 'value');

        expect(result, true);
        verify(mockStrategy.setString('key', 'value')).called(1);
      });
    }
    */
  }
}

// ============================================================
// مثال 9: التهيئة في main.dart
// ============================================================

class Example9_Initialization {
  /*
  void main() async {
    WidgetsFlutterBinding.ensureInitialized();

    // تهيئة CacheHelper
    await CacheHelperFactory.initializeSingleton();

    // أو استخدام WithCache
    // final cacheHelper = await CacheHelperFactory.createWithCache(
    //   allowList: StorageKeys.allKeys,
    // );

    runApp(MyApp());
  }
  */
}

// ============================================================
// مثال 10: Migration من الكود القديم
// ============================================================

class Example10_Migration {
  // === قبل ===
  Future<void> oldWay() async {
    /*
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', 'test@example.com');
    final email = prefs.getString('user_email');
    await prefs.setBool('has_seen_onboarding', true);
    final hasSeen = prefs.getBool('has_seen_onboarding') ?? false;
    */
  }

  // === بعد ===
  Future<void> newWay() async {
    final repository = LocalStorageRepository(
      CacheHelperFactory.instance,
    );

    await repository.saveUserEmail('test@example.com');
    final email = await repository.getUserEmail();

    await repository.setOnboardingCompleted();
    final hasSeen = await repository.hasSeenOnboarding();
  }
}
