# Storage System Documentation

## نظرة عامة

تم إعادة هيكلة نظام التخزين المحلي باستخدام **Strategy Pattern** و **Repository Pattern** لتوفير:

- ✅ مرونة في التبديل بين أنظمة التخزين المختلفة (SharedPreferences, Hive, Backend)
- ✅ كود نظيف وقابل للصيانة
- ✅ دعم SharedPreferencesAsync/WithCache حسب التوصيات الرسمية
- ✅ إدارة مركزية للمفاتيح
- ✅ سهولة الاختبار (Testability)

---

## الهيكلة

```
lib/core/
├── storage/
│   ├── storage_strategy.dart           # Interface للاستراتيجيات
│   ├── storage_keys.dart               # إدارة مركزية للمفاتيح
│   ├── local_storage_repository.dart   # Repository للعمليات الشائعة
│   ├── strategies/
│   │   ├── shared_preferences_async_strategy.dart
│   │   └── shared_preferences_with_cache_strategy.dart
│   └── README.md
└── services/
    ├── cache_helper.dart               # Wrapper موحد
    └── cache_helper_factory.dart       # Factory لإنشاء الـ instances
```

---

## الاستخدام

### 1️⃣ الطريقة الموصى بها (SharedPreferencesAsync)

```dart
import 'package:granzia_health_connect/core/services/cache_helper_factory.dart';
import 'package:granzia_health_connect/core/storage/local_storage_repository.dart';
import 'package:granzia_health_connect/core/storage/storage_keys.dart';

// استخدام Singleton
final repository = LocalStorageRepository(
  CacheHelperFactory.instance,
);

// حفظ البيانات
await repository.saveAuthTokens(
  accessToken: 'token123',
  refreshToken: 'refresh456',
);

// قراءة البيانات
final token = await repository.getAccessToken();
final isLoggedIn = await repository.isLoggedIn();
```

### 2️⃣ الاستخدام المباشر مع CacheHelper

```dart
import 'package:granzia_health_connect/core/services/cache_helper_factory.dart';
import 'package:granzia_health_connect/core/storage/storage_keys.dart';

final cacheHelper = CacheHelperFactory.instance;

// حفظ أنواع مختلفة من البيانات
await cacheHelper.setString(StorageKeys.userEmail, 'user@example.com');
await cacheHelper.setInt(StorageKeys.onboardingVersion, 2);
await cacheHelper.setBool(StorageKeys.hasSeenOnboarding, true);
await cacheHelper.setStringList('tags', ['health', 'fitness']);

// قراءة البيانات
final email = await cacheHelper.getString(StorageKeys.userEmail);
final version = await cacheHelper.getInt(StorageKeys.onboardingVersion);
final hasSeen = await cacheHelper.getBool(StorageKeys.hasSeenOnboarding);
```

### 3️⃣ استخدام WithCache للأداء الأفضل

```dart
// إنشاء instance مع cache
final cacheHelper = await CacheHelperFactory.createWithCache(
  allowList: StorageKeys.allKeys, // اختياري
);

final repository = LocalStorageRepository(cacheHelper);
```

---

## LocalStorageRepository - العمليات المتاحة

### 🔐 Authentication

```dart
// حفظ tokens
await repository.saveAuthTokens(
  accessToken: 'token',
  refreshToken: 'refresh',
);

// قراءة tokens
final accessToken = await repository.getAccessToken();
final refreshToken = await repository.getRefreshToken();

// التحقق من تسجيل الدخول
final isLoggedIn = await repository.isLoggedIn();

// تسجيل الخروج
await repository.clearAuthData();
```

### 📱 Onboarding

```dart
// تعيين onboarding كمكتمل
await repository.setOnboardingCompleted(version: 2);

// التحقق من الإكمال
final hasSeen = await repository.hasSeenOnboarding();
final version = await repository.getOnboardingVersion();
```

### ⚙️ Settings

```dart
// حفظ الإعدادات
await repository.saveSettings({
  'theme': 'dark',
  'language': 'ar',
});

// قراءة الإعدادات
final settings = await repository.getSettings();

// حفظ theme mode
await repository.saveThemeMode('dark');
final theme = await repository.getThemeMode();

// حفظ اللغة
await repository.saveLocale('ar');
final locale = await repository.getLocale();
```

### 🏥 Health Devices

```dart
// حفظ الأجهزة
await repository.saveDevices([
  {'id': '1', 'name': 'Blood Pressure Monitor'},
]);

// قراءة الأجهزة
final devices = await repository.getDevices();

// حفظ القراءات
await repository.saveDeviceReadings({
  'device_1': {'systolic': 120, 'diastolic': 80},
});

// آخر وقت مزامنة
await repository.saveLastSyncTime(DateTime.now());
final lastSync = await repository.getLastSyncTime();
```

### 👤 User Preferences

```dart
// الإشعارات
await repository.setNotificationsEnabled(true);
final notificationsEnabled = await repository.getNotificationsEnabled();

// البصمة
await repository.setBiometricsEnabled(true);
final biometricsEnabled = await repository.getBiometricsEnabled();

// المزامنة التلقائية
await repository.setAutoSyncEnabled(true);
final autoSyncEnabled = await repository.getAutoSyncEnabled();
```

---

## StorageKeys - إدارة المفاتيح

جميع المفاتيح معرفة في `StorageKeys` لتجنب الأخطاء:

```dart
// استخدام المفاتيح المعرفة
await cacheHelper.setString(StorageKeys.accessToken, 'token');
await cacheHelper.setBool(StorageKeys.hasSeenOnboarding, true);

// الحصول على جميع المفاتيح
final allKeys = StorageKeys.allKeys;

// المفاتيح الحساسة
final criticalKeys = StorageKeys.criticalKeys;

// المفاتيح القابلة للحذف عند Logout
final clearableKeys = StorageKeys.clearableOnLogout;
```

---

## التبديل بين Strategies

### SharedPreferencesAsync (الموصى به)

```dart
final cacheHelper = CacheHelperFactory.createAsync();
```

**المميزات:**
- ✅ دائماً يعطي أحدث البيانات
- ✅ يعمل مع multiple isolates
- ✅ لا توجد مشاكل cache synchronization

**الاستخدام:**
- عند استخدام background services
- عند الحاجة لبيانات موثوقة
- التطبيقات متعددة الـ isolates

### SharedPreferencesWithCache

```dart
final cacheHelper = await CacheHelperFactory.createWithCache(
  allowList: StorageKeys.allKeys,
);
```

**المميزات:**
- ✅ أداء أفضل للقراءة المتكررة
- ✅ عمليات قراءة شبه متزامنة

**الاستخدام:**
- عند وجود عمليات قراءة متكررة
- عدم استخدام multiple isolates
- الأداء أولوية

---

## إضافة Strategy جديد (مثل Hive)

### 1. إنشاء Strategy جديد

```dart
// lib/core/storage/strategies/hive_strategy.dart
import 'package:hive/hive.dart';
import '../storage_strategy.dart';

class HiveStrategy implements StorageStrategy {
  late Box _box;

  @override
  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('app_storage');
  }

  @override
  Future<bool> setString(String key, String value) async {
    try {
      await _box.put(key, value);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String?> getString(String key) async {
    try {
      return _box.get(key) as String?;
    } catch (e) {
      return null;
    }
  }

  // ... باقي الـ methods
}
```

### 2. إضافة Factory Method

```dart
// في cache_helper_factory.dart
static Future<CacheHelper> createWithHive() async {
  final strategy = HiveStrategy();
  await strategy.init();
  return CacheHelper(strategy);
}
```

### 3. الاستخدام

```dart
final cacheHelper = await CacheHelperFactory.createWithHive();
final repository = LocalStorageRepository(cacheHelper);
```

---

## إضافة Remote Backend Strategy

```dart
class RemoteStorageStrategy implements StorageStrategy {
  final ApiClient _apiClient;

  RemoteStorageStrategy(this._apiClient);

  @override
  Future<bool> setString(String key, String value) async {
    try {
      await _apiClient.post('/storage', {
        'key': key,
        'value': value,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String?> getString(String key) async {
    try {
      final response = await _apiClient.get('/storage/$key');
      return response.data['value'];
    } catch (e) {
      return null;
    }
  }

  // ... باقي الـ methods
}
```

---

## التهيئة في main.dart

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة CacheHelper
  await CacheHelperFactory.initializeSingleton();

  runApp(MyApp());
}
```

---

## الاختبارات (Testing)

```dart
// test/storage_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

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
```

---

## Migration من الكود القديم

### قبل:

```dart
final prefs = await SharedPreferences.getInstance();
await prefs.setString('user_email', 'test@example.com');
final email = prefs.getString('user_email');
```

### بعد:

```dart
final repository = LocalStorageRepository(
  CacheHelperFactory.instance,
);
await repository.saveUserEmail('test@example.com');
final email = await repository.getUserEmail();
```

---

## Best Practices

1. **استخدم StorageKeys دائماً** بدلاً من hard-coded strings
2. **استخدم LocalStorageRepository** للعمليات الشائعة
3. **استخدم SharedPreferencesAsync** كـ default
4. **لا تخزن بيانات حساسة** بدون تشفير
5. **استخدم allowList** مع WithCache للأمان
6. **قم بـ init** في بداية التطبيق

---

## الفروقات بين Async و WithCache

| Feature | SharedPreferencesAsync | SharedPreferencesWithCache |
|---------|----------------------|---------------------------|
| Performance | متوسط | عالي (بسبب الـ cache) |
| Multi-isolate | ✅ يعمل بشكل صحيح | ⚠️ يحتاج reload |
| Background services | ✅ موصى به | ❌ غير موصى به |
| Synchronous reads | ❌ كل العمليات async | ✅ بعد التهيئة |
| Cache issues | ✅ لا توجد | ⚠️ ممكنة |
| Recommended | ✅ للحالات العامة | للأداء العالي فقط |

---

## الخلاصة

النظام الجديد يوفر:

- ✅ **مرونة**: سهولة التبديل بين أنظمة التخزين
- ✅ **أمان**: إدارة مركزية للمفاتيح
- ✅ **أداء**: اختيار الـ strategy المناسب
- ✅ **صيانة**: كود نظيف وقابل للاختبار
- ✅ **مستقبلي**: جاهز لإضافة Hive أو Backend

---

## المراجع

- [SharedPreferences Documentation](https://pub.dev/packages/shared_preferences)
- [Strategy Pattern](https://refactoring.guru/design-patterns/strategy)
- [Repository Pattern](https://martinfowler.com/eaaCatalog/repository.html)
