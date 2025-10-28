# 🚀 دليل الإعداد - Setup Guide

## خطوات الإعداد السريع

### 1️⃣ التهيئة في main.dart

```dart
import 'package:flutter/material.dart';
import 'package:granzia_health_connect/core/storage/storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Storage مع SharedPreferences (الافتراضي)
  await StorageLocator.init();

  // أو استخدام Hive للأداء الأفضل
  // await StorageLocator.init(useHive: true);

  // أو استخدام Hive مع التشفير
  // await StorageLocator.init(
  //   useHive: true,
  //   hiveEncryptionKey: 'your-secret-key-32-chars-long',
  // );

  runApp(MyApp());
}
```

---

## 🎯 الاستخدام البسيط (موصى به)

### حفظ وقراءة البيانات

```dart
import 'package:granzia_health_connect/core/storage/storage.dart';

// === Authentication ===
// حفظ tokens
await Storage.saveTokens(
  accessToken: 'your_access_token',
  refreshToken: 'your_refresh_token',
);

// قراءة token
final token = await Storage.getToken();

// التحقق من تسجيل الدخول
final isLoggedIn = await Storage.isLoggedIn();

// تسجيل خروج
await Storage.logout();

// === User Info ===
await Storage.saveUserEmail('user@example.com');
await Storage.saveUserId('user_123');

final email = await Storage.getUserEmail();
final userId = await Storage.getUserId();

// === Onboarding ===
await Storage.completeOnboarding();
final hasSeen = await Storage.hasSeenOnboarding();

// === Settings ===
await Storage.saveTheme('dark');
await Storage.saveLanguage('ar');

final theme = await Storage.getTheme();
final language = await Storage.getLanguage();

// === Preferences ===
await Storage.setNotifications(true);
await Storage.setBiometrics(true);

final notificationsEnabled = await Storage.areNotificationsEnabled();
final biometricsEnabled = await Storage.areBiometricsEnabled();

// === Generic Operations ===
await Storage.saveString('custom_key', 'value');
await Storage.saveInt('age', 25);
await Storage.saveBool('is_premium', true);

final value = await Storage.getString('custom_key');
final age = await Storage.getInt('age');
final isPremium = await Storage.getBool('is_premium');
```

---

## 🎨 الاستخدام المتقدم

### استخدام Repository مباشرة

```dart
import 'package:granzia_health_connect/core/storage/storage.dart';

final repository = StorageLocator.repository;

// حفظ بيانات معقدة
await repository.saveSettings({
  'theme': 'dark',
  'language': 'ar',
  'notifications': true,
});

await repository.saveDevices([
  {'id': '1', 'name': 'Blood Pressure Monitor'},
  {'id': '2', 'name': 'Glucose Meter'},
]);

// قراءة البيانات
final settings = await repository.getSettings();
final devices = await repository.getDevices();
```

### استخدام CacheHelper مباشرة

```dart
import 'package:granzia_health_connect/core/storage/storage.dart';

final cacheHelper = StorageLocator.cacheHelper;

// عمليات متقدمة
await cacheHelper.setString(StorageKeys.accessToken, 'token');
final token = await cacheHelper.getString(StorageKeys.accessToken);

// الحصول على جميع المفاتيح
final allKeys = await cacheHelper.getKeys();

// مسح بيانات محددة
await cacheHelper.clear(allowList: StorageKeys.criticalKeys);
```

---

## 🔧 التكامل مع BLoC/Cubit

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:granzia_health_connect/core/storage/storage.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthEvent>(_onCheckAuth);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      
      // Call API
      final response = await authApi.login(event.email, event.password);
      
      // Save tokens
      await Storage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      
      // Save user info
      await Storage.saveUserEmail(event.email);
      await Storage.saveUserId(response.userId);
      
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await Storage.logout();
    emit(AuthInitial());
  }

  Future<void> _onCheckAuth(CheckAuthEvent event, Emitter<AuthState> emit) async {
    final isLoggedIn = await Storage.isLoggedIn();
    
    if (isLoggedIn) {
      emit(AuthSuccess());
    } else {
      emit(AuthInitial());
    }
  }
}
```

---

## 🎭 التكامل مع GetIt (Dependency Injection)

```dart
import 'package:get_it/get_it.dart';
import 'package:granzia_health_connect/core/storage/storage.dart';

final getIt = GetIt.instance;

void setupDependencies() async {
  // تهيئة Storage أولاً
  await StorageLocator.init();

  // تسجيل Services الأخرى
  getIt.registerSingleton<AuthService>(
    AuthService(repository: StorageLocator.repository),
  );
  
  getIt.registerSingleton<SettingsService>(
    SettingsService(repository: StorageLocator.repository),
  );
}

// في main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await setupDependencies();
  
  runApp(MyApp());
}
```

---

## 🔐 استخدام Hive مع التشفير

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // استخدام Hive مع تشفير
  await StorageLocator.init(
    useHive: true,
    hiveBoxName: 'secure_storage',
    hiveEncryptionKey: 'your-32-character-secret-key!',
  );

  runApp(MyApp());
}
```

---

## 📱 أمثلة عملية

### مثال 1: Splash Screen

```dart
class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    
    final hasSeen = await Storage.hasSeenOnboarding();
    final isLoggedIn = await Storage.isLoggedIn();
    
    if (!mounted) return;
    
    if (!hasSeen) {
      context.go('/onboarding');
    } else if (isLoggedIn) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
```

### مثال 2: Login Screen

```dart
class LoginScreen extends StatelessWidget {
  Future<void> _login(String email, String password) async {
    try {
      // Call API
      final response = await authApi.login(email, password);
      
      // Save data
      await Storage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      
      await Storage.saveUserEmail(email);
      await Storage.saveUserId(response.userId);
      
      // Navigate
      context.go('/home');
    } catch (e) {
      // Handle error
      showError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginForm(
        onSubmit: _login,
      ),
    );
  }
}
```

### مثال 3: Settings Screen

```dart
class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _biometricsEnabled = false;
  String _theme = 'light';
  String _language = 'en';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final notifications = await Storage.areNotificationsEnabled();
    final biometrics = await Storage.areBiometricsEnabled();
    final theme = await Storage.getTheme() ?? 'light';
    final language = await Storage.getLanguage() ?? 'en';
    
    setState(() {
      _notificationsEnabled = notifications;
      _biometricsEnabled = biometrics;
      _theme = theme;
      _language = language;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    await Storage.setNotifications(value);
    setState(() => _notificationsEnabled = value);
  }

  Future<void> _changeTheme(String theme) async {
    await Storage.saveTheme(theme);
    setState(() => _theme = theme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Notifications'),
            value: _notificationsEnabled,
            onChanged: _toggleNotifications,
          ),
          ListTile(
            title: Text('Theme'),
            subtitle: Text(_theme),
            onTap: () => _showThemeDialog(),
          ),
          // ... more settings
        ],
      ),
    );
  }
}
```

---

## 🔄 التبديل بين Strategies

### من SharedPreferences إلى Hive

```dart
// في main.dart

// قبل (SharedPreferences)
await StorageLocator.init();

// بعد (Hive)
await StorageLocator.init(useHive: true);

// لا حاجة لتغيير أي كود آخر!
// جميع استدعاءات Storage.xxx ستعمل بنفس الطريقة
```

---

## 🧪 الاختبار (Testing)

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:granzia_health_connect/core/storage/storage.dart';

void main() {
  setUp(() async {
    // تهيئة Storage للاختبار
    await StorageLocator.init();
  });

  tearDown(() async {
    // تنظيف بعد كل اختبار
    await Storage.clearAll();
    await StorageLocator.reset();
  });

  test('should save and retrieve user email', () async {
    await Storage.saveUserEmail('test@example.com');
    final email = await Storage.getUserEmail();
    
    expect(email, 'test@example.com');
  });

  test('should check login status', () async {
    // Initially not logged in
    expect(await Storage.isLoggedIn(), false);
    
    // Save tokens
    await Storage.saveTokens(
      accessToken: 'token',
      refreshToken: 'refresh',
    );
    
    // Now logged in
    expect(await Storage.isLoggedIn(), true);
  });
}
```

---

## ⚙️ التكوين المتقدم

### استخدام Hive boxes متعددة

```dart
// في StorageLocator
await StorageLocator.init(
  useHive: true,
  hiveBoxName: 'user_data',
);

// إنشاء box إضافي للـ cache
final cacheHelper = await CacheHelperFactory.createWithHive(
  boxName: 'app_cache',
);
```

### استخدام استراتيجيات مختلفة

```dart
// Hive للبيانات الكبيرة
final hiveHelper = await CacheHelperFactory.createWithHive();

// SharedPreferences للبيانات الصغيرة
final prefsHelper = CacheHelperFactory.createAsync();

// استخدام كل واحد حسب الحاجة
await hiveHelper.setString('large_data', jsonEncode(bigObject));
await prefsHelper.setBool('simple_flag', true);
```

---

## 📊 مقارنة الأداء

| Feature | SharedPreferences | Hive |
|---------|------------------|------|
| السرعة | متوسط | سريع جداً |
| حجم البيانات | محدود (~10MB) | غير محدود |
| التشفير | ❌ | ✅ |
| الأنواع المعقدة | ❌ | ✅ |
| الاستخدام | بسيط | بسيط |

---

## ✅ Best Practices

1. **استخدم Storage للعمليات البسيطة**
   ```dart
   await Storage.saveUserEmail('user@example.com');
   ```

2. **استخدم Repository للعمليات المعقدة**
   ```dart
   await StorageLocator.repository.saveSettings({...});
   ```

3. **استخدم Hive للبيانات الكبيرة**
   ```dart
   await StorageLocator.init(useHive: true);
   ```

4. **استخدم التشفير للبيانات الحساسة**
   ```dart
   await StorageLocator.init(
     useHive: true,
     hiveEncryptionKey: 'secret-key',
   );
   ```

---

## 🎉 الخلاصة

الآن لديك نظام تخزين:
- ✅ **سهل الاستخدام** - API بسيط مع `Storage.xxx`
- ✅ **مرن** - تبديل سهل بين Strategies
- ✅ **سريع** - دعم Hive للأداء الأفضل
- ✅ **آمن** - دعم التشفير
- ✅ **قابل للاختبار** - GetIt integration

**ابدأ الآن بخطوة واحدة:**
```dart
await StorageLocator.init();
await Storage.saveUserEmail('user@example.com');
```
