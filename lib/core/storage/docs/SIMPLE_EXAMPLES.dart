// ignore_for_file: unused_local_variable, unused_element

import '../storage.dart';

/// أمثلة بسيطة لاستخدام نظام التخزين الجديد
///
/// هذا الملف يوضح أسهل طريقة لاستخدام Storage

// ============================================================
// مثال 1: الاستخدام الأساسي (الأسهل!)
// ============================================================

class Example1_BasicUsage {
  Future<void> demonstrate() async {
    // === حفظ البيانات ===
    await Storage.saveUserEmail('user@example.com');
    await Storage.saveUserId('user_123');

    // === قراءة البيانات ===
    final email = await Storage.getUserEmail();
    final userId = await Storage.getUserId();

    print('Email: $email');
    print('User ID: $userId');
  }
}

// ============================================================
// مثال 2: Authentication
// ============================================================

class Example2_Authentication {
  Future<void> login(String email, String password) async {
    // محاكاة استدعاء API
    const accessToken = 'mock_access_token';
    const refreshToken = 'mock_refresh_token';

    // حفظ tokens
    await Storage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );

    // حفظ معلومات المستخدم
    await Storage.saveUserEmail(email);
    await Storage.saveUserId('user_123');

    print('✅ تم تسجيل الدخول بنجاح');
  }

  Future<bool> checkIfLoggedIn() async {
    return await Storage.isLoggedIn();
  }

  Future<void> logout() async {
    await Storage.logout();
    print('✅ تم تسجيل الخروج');
  }
}

// ============================================================
// مثال 3: Onboarding
// ============================================================

class Example3_Onboarding {
  Future<bool> shouldShowOnboarding() async {
    final hasSeen = await Storage.hasSeenOnboarding();
    return !hasSeen;
  }

  Future<void> completeOnboarding() async {
    await Storage.completeOnboarding();
    print('✅ تم إكمال Onboarding');
  }
}

// ============================================================
// مثال 4: Settings
// ============================================================

class Example4_Settings {
  Future<void> saveUserPreferences() async {
    // حفظ الإعدادات
    await Storage.saveTheme('dark');
    await Storage.saveLanguage('ar');
    await Storage.setNotifications(true);
    await Storage.setBiometrics(true);

    print('✅ تم حفظ الإعدادات');
  }

  Future<void> loadUserPreferences() async {
    // قراءة الإعدادات
    final theme = await Storage.getTheme();
    final language = await Storage.getLanguage();
    final notificationsEnabled = await Storage.areNotificationsEnabled();
    final biometricsEnabled = await Storage.areBiometricsEnabled();

    print('Theme: $theme');
    print('Language: $language');
    print('Notifications: $notificationsEnabled');
    print('Biometrics: $biometricsEnabled');
  }
}

// ============================================================
// مثال 5: حفظ بيانات مخصصة
// ============================================================

class Example5_CustomData {
  Future<void> saveCustomData() async {
    // حفظ أنواع مختلفة من البيانات
    await Storage.saveString('user_name', 'أحمد محمد');
    await Storage.saveInt('user_age', 25);
    await Storage.saveBool('is_premium', true);

    print('✅ تم حفظ البيانات المخصصة');
  }

  Future<void> readCustomData() async {
    // قراءة البيانات
    final name = await Storage.getString('user_name');
    final age = await Storage.getInt('user_age');
    final isPremium = await Storage.getBool('is_premium');

    print('Name: $name');
    print('Age: $age');
    print('Premium: $isPremium');
  }

  Future<void> checkIfExists() async {
    // التحقق من وجود مفتاح
    final exists = await Storage.has('user_name');
    print('User name exists: $exists');
  }

  Future<void> removeData() async {
    // حذف بيانات
    await Storage.remove('user_name');
    print('✅ تم حذف البيانات');
  }
}

// ============================================================
// مثال 6: استخدام في Splash Screen
// ============================================================

class Example6_SplashScreen {
  Future<String> determineInitialRoute() async {
    // التحقق من Onboarding
    final hasSeen = await Storage.hasSeenOnboarding();
    if (!hasSeen) {
      return '/onboarding';
    }

    // التحقق من تسجيل الدخول
    final isLoggedIn = await Storage.isLoggedIn();
    if (isLoggedIn) {
      return '/home';
    }

    return '/login';
  }
}

// ============================================================
// مثال 7: استخدام في Login Screen
// ============================================================

class Example7_LoginScreen {
  Future<void> handleLogin(String email, String password) async {
    try {
      // محاكاة استدعاء API
      print('Logging in...');
      await Future.delayed(const Duration(seconds: 1));

      // حفظ البيانات
      await Storage.saveTokens(
        accessToken: 'access_token_here',
        refreshToken: 'refresh_token_here',
      );

      await Storage.saveUserEmail(email);
      await Storage.saveUserId('user_123');

      print('✅ تم تسجيل الدخول بنجاح');

      // الانتقال للصفحة الرئيسية
      // context.go('/home');
    } catch (e) {
      print('❌ خطأ في تسجيل الدخول: $e');
    }
  }

  Future<void> handleLogout() async {
    await Storage.logout();
    print('✅ تم تسجيل الخروج');

    // الانتقال لصفحة تسجيل الدخول
    // context.go('/login');
  }
}

// ============================================================
// مثال 8: استخدام في Settings Screen
// ============================================================

class Example8_SettingsScreen {
  // State
  bool notificationsEnabled = true;
  bool biometricsEnabled = false;
  String theme = 'light';
  String language = 'en';

  Future<void> loadSettings() async {
    notificationsEnabled = await Storage.areNotificationsEnabled();
    biometricsEnabled = await Storage.areBiometricsEnabled();
    theme = await Storage.getTheme() ?? 'light';
    language = await Storage.getLanguage() ?? 'en';

    print('✅ تم تحميل الإعدادات');
  }

  Future<void> toggleNotifications(bool value) async {
    await Storage.setNotifications(value);
    notificationsEnabled = value;
    print('Notifications: $value');
  }

  Future<void> changeTheme(String newTheme) async {
    await Storage.saveTheme(newTheme);
    theme = newTheme;
    print('Theme changed to: $newTheme');
  }

  Future<void> changeLanguage(String newLanguage) async {
    await Storage.saveLanguage(newLanguage);
    language = newLanguage;
    print('Language changed to: $newLanguage');
  }
}

// ============================================================
// مثال 9: استخدام Repository للعمليات المعقدة
// ============================================================

class Example9_AdvancedUsage {
  Future<void> saveComplexData() async {
    final repository = Storage.repository;

    // حفظ إعدادات معقدة
    await repository.saveSettings({
      'theme': 'dark',
      'language': 'ar',
      'notifications': true,
      'fontSize': 16,
    });

    // حفظ أجهزة
    await repository.saveDevices([
      {'id': '1', 'name': 'Blood Pressure Monitor', 'type': 'bp'},
      {'id': '2', 'name': 'Glucose Meter', 'type': 'glucose'},
    ]);

    print('✅ تم حفظ البيانات المعقدة');
  }

  Future<void> readComplexData() async {
    final repository = Storage.repository;

    // قراءة الإعدادات
    final settings = await repository.getSettings();
    print('Settings: $settings');

    // قراءة الأجهزة
    final devices = await repository.getDevices();
    print('Devices: $devices');
  }
}

// ============================================================
// مثال 10: الاستخدام الكامل في تطبيق حقيقي
// ============================================================

class Example10_RealWorldApp {
  // === في main.dart ===
  Future<void> initializeApp() async {
    // تهيئة Storage
    await StorageLocator.init();

    // أو استخدام Hive للأداء الأفضل
    // await StorageLocator.init(useHive: true);

    print('✅ تم تهيئة التطبيق');
  }

  // === في Splash Screen ===
  Future<String> checkInitialRoute() async {
    final hasSeen = await Storage.hasSeenOnboarding();
    if (!hasSeen) return '/onboarding';

    final isLoggedIn = await Storage.isLoggedIn();
    if (isLoggedIn) return '/home';

    return '/login';
  }

  // === في Login ===
  Future<void> login(String email, String password) async {
    // Call API
    final response = await _mockApiCall(email, password);

    // Save data
    await Storage.saveTokens(
      accessToken: response['accessToken'],
      refreshToken: response['refreshToken'],
    );

    await Storage.saveUserEmail(email);
    await Storage.saveUserId(response['userId']);
  }

  // === في Profile ===
  Future<Map<String, dynamic>> getUserProfile() async {
    return {
      'email': await Storage.getUserEmail(),
      'userId': await Storage.getUserId(),
      'theme': await Storage.getTheme(),
      'language': await Storage.getLanguage(),
    };
  }

  // === في Settings ===
  Future<void> updateSettings({
    String? theme,
    String? language,
    bool? notifications,
  }) async {
    if (theme != null) await Storage.saveTheme(theme);
    if (language != null) await Storage.saveLanguage(language);
    if (notifications != null) await Storage.setNotifications(notifications);
  }

  // === في Logout ===
  Future<void> logout() async {
    await Storage.logout();
    // Navigate to login
  }

  // Mock API call
  Future<Map<String, dynamic>> _mockApiCall(
      String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      'accessToken': 'mock_access_token',
      'refreshToken': 'mock_refresh_token',
      'userId': 'user_123',
    };
  }
}

// ============================================================
// كيفية الاستخدام في main.dart
// ============================================================

/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Storage
  await StorageLocator.init();

  // أو استخدام Hive
  // await StorageLocator.init(useHive: true);

  runApp(MyApp());
}
*/

// ============================================================
// الخلاصة: أسهل طريقة للاستخدام
// ============================================================

/*
// 1. في main.dart
await StorageLocator.init();

// 2. في أي مكان في التطبيق
await Storage.saveUserEmail('user@example.com');
final email = await Storage.getUserEmail();

// 3. للعمليات المعقدة
final repository = Storage.repository;
await repository.saveSettings({...});

// هذا كل شيء! 🎉
*/
