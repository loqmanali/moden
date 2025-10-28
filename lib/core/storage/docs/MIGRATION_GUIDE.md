# دليل الترحيل (Migration Guide)

## نظرة عامة

هذا الدليل يساعدك على الترحيل من استخدام `SharedPreferences` المباشر إلى النظام الجديد.

---

## الخطوات الأساسية

### 1️⃣ تحديث الـ imports

#### قبل:
```dart
import 'package:shared_preferences/shared_preferences.dart';
```

#### بعد:
```dart
import 'package:granzia_health_connect/core/services/cache_helper_factory.dart';
import 'package:granzia_health_connect/core/storage/local_storage_repository.dart';
import 'package:granzia_health_connect/core/storage/storage_keys.dart';
```

---

### 2️⃣ استبدال getInstance()

#### قبل:
```dart
final prefs = await SharedPreferences.getInstance();
```

#### بعد:
```dart
final repository = LocalStorageRepository(
  CacheHelperFactory.instance,
);
```

---

### 3️⃣ استبدال عمليات الحفظ والقراءة

#### قبل:
```dart
// String
await prefs.setString('user_email', 'user@example.com');
final email = prefs.getString('user_email');

// Bool
await prefs.setBool('has_seen_onboarding', true);
final hasSeen = prefs.getBool('has_seen_onboarding') ?? false;

// Int
await prefs.setInt('user_age', 25);
final age = prefs.getInt('user_age') ?? 0;
```

#### بعد (باستخدام Repository):
```dart
// String
await repository.saveUserEmail('user@example.com');
final email = await repository.getUserEmail();

// Bool
await repository.setOnboardingCompleted();
final hasSeen = await repository.hasSeenOnboarding();

// Int (مباشرة مع CacheHelper)
final cacheHelper = CacheHelperFactory.instance;
await cacheHelper.setInt('user_age', 25);
final age = await cacheHelper.getInt('user_age') ?? 0;
```

---

## أمثلة عملية للترحيل

### مثال 1: Authentication

#### قبل:
```dart
class AuthService {
  Future<void> saveTokens(String access, String refresh) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', access);
    await prefs.setString('refresh_token', refresh);
    await prefs.setBool('is_logged_in', true);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.setBool('is_logged_in', false);
  }
}
```

#### بعد:
```dart
class AuthService {
  final LocalStorageRepository _repository;

  AuthService({LocalStorageRepository? repository})
      : _repository = repository ??
            LocalStorageRepository(CacheHelperFactory.instance);

  Future<void> saveTokens(String access, String refresh) async {
    await _repository.saveAuthTokens(
      accessToken: access,
      refreshToken: refresh,
    );
  }

  Future<String?> getAccessToken() async {
    return await _repository.getAccessToken();
  }

  Future<bool> isLoggedIn() async {
    return await _repository.isLoggedIn();
  }

  Future<void> logout() async {
    await _repository.clearAuthData();
  }
}
```

---

### مثال 2: Settings

#### قبل:
```dart
class SettingsService {
  Future<void> saveTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', theme);
  }

  Future<String?> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('theme_mode');
  }

  Future<void> saveLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
  }

  Future<String?> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('language');
  }
}
```

#### بعد:
```dart
class SettingsService {
  final LocalStorageRepository _repository;

  SettingsService({LocalStorageRepository? repository})
      : _repository = repository ??
            LocalStorageRepository(CacheHelperFactory.instance);

  Future<void> saveTheme(String theme) async {
    await _repository.saveThemeMode(theme);
  }

  Future<String?> getTheme() async {
    return await _repository.getThemeMode();
  }

  Future<void> saveLanguage(String lang) async {
    await _repository.saveLocale(lang);
  }

  Future<String?> getLanguage() async {
    return await _repository.getLocale();
  }
}
```

---

### مثال 3: Onboarding

#### قبل:
```dart
class OnboardingScreen extends StatelessWidget {
  Future<void> completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    context.go('/home');
  }
}

class SplashScreen extends StatefulWidget {
  Future<void> checkOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeen = prefs.getBool('has_seen_onboarding') ?? false;
    
    if (hasSeen) {
      context.go('/home');
    } else {
      context.go('/onboarding');
    }
  }
}
```

#### بعد:
```dart
class OnboardingScreen extends StatelessWidget {
  Future<void> completeOnboarding(BuildContext context) async {
    final repository = LocalStorageRepository(
      CacheHelperFactory.instance,
    );
    await repository.setOnboardingCompleted();
    if (context.mounted) {
      context.go('/home');
    }
  }
}

class SplashScreen extends StatefulWidget {
  Future<void> checkOnboarding() async {
    final repository = LocalStorageRepository(
      CacheHelperFactory.instance,
    );
    final hasSeen = await repository.hasSeenOnboarding();
    
    if (hasSeen) {
      context.go('/home');
    } else {
      context.go('/onboarding');
    }
  }
}
```

---

### مثال 4: BLoC/Cubit

#### قبل:
```dart
class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc() : super(const LocaleState(Locale('en'))) {
    on<ChangeLocaleEvent>(_onChangeLocale);
    on<LoadLocaleEvent>(_onLoadLocale);
  }

  Future<void> _onChangeLocale(
      ChangeLocaleEvent event, Emitter<LocaleState> emit) async {
    final locale = Locale(event.languageCode);
    emit(LocaleState(locale));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', event.languageCode);
  }

  Future<void> _onLoadLocale(
      LoadLocaleEvent event, Emitter<LocaleState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('locale');

    if (languageCode != null) {
      emit(LocaleState(Locale(languageCode)));
    }
  }
}
```

#### بعد:
```dart
class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  final LocalStorageRepository _repository;

  LocaleBloc({LocalStorageRepository? repository})
      : _repository = repository ??
            LocalStorageRepository(CacheHelperFactory.instance),
        super(const LocaleState(Locale('en'))) {
    on<ChangeLocaleEvent>(_onChangeLocale);
    on<LoadLocaleEvent>(_onLoadLocale);
  }

  Future<void> _onChangeLocale(
      ChangeLocaleEvent event, Emitter<LocaleState> emit) async {
    final locale = Locale(event.languageCode);
    emit(LocaleState(locale));

    await _repository.saveLocale(event.languageCode);
  }

  Future<void> _onLoadLocale(
      LoadLocaleEvent event, Emitter<LocaleState> emit) async {
    final languageCode = await _repository.getLocale();

    if (languageCode != null) {
      emit(LocaleState(Locale(languageCode)));
    }
  }
}
```

---

### مثال 5: استخدام Hard-coded Keys

#### قبل:
```dart
await prefs.setString('user_email', 'test@example.com');
await prefs.setBool('has_seen_onboarding', true);
await prefs.setString('access_token', 'token123');
```

#### بعد:
```dart
final cacheHelper = CacheHelperFactory.instance;

await cacheHelper.setString(StorageKeys.userEmail, 'test@example.com');
await cacheHelper.setBool(StorageKeys.hasSeenOnboarding, true);
await cacheHelper.setString(StorageKeys.accessToken, 'token123');
```

---

## Checklist للترحيل

- [ ] استبدل جميع `import 'package:shared_preferences/shared_preferences.dart'`
- [ ] استبدل `SharedPreferences.getInstance()` بـ `CacheHelperFactory.instance`
- [ ] استخدم `StorageKeys` بدلاً من hard-coded strings
- [ ] استخدم `LocalStorageRepository` للعمليات الشائعة
- [ ] حدّث الـ constructors لقبول `LocalStorageRepository` (للـ testing)
- [ ] تأكد من استخدام `await` مع جميع العمليات
- [ ] تأكد من استخدام `context.mounted` قبل navigation
- [ ] احذف الـ constants القديمة للمفاتيح
- [ ] قم بتحديث الـ tests

---

## نصائح مهمة

### ✅ DO

1. **استخدم LocalStorageRepository للعمليات الشائعة**
   ```dart
   final repository = LocalStorageRepository(CacheHelperFactory.instance);
   await repository.saveUserEmail('user@example.com');
   ```

2. **استخدم StorageKeys للمفاتيح**
   ```dart
   await cacheHelper.setString(StorageKeys.accessToken, 'token');
   ```

3. **اجعل Repository قابل للحقن (Injectable)**
   ```dart
   class MyService {
     final LocalStorageRepository _repository;
     
     MyService({LocalStorageRepository? repository})
         : _repository = repository ?? 
             LocalStorageRepository(CacheHelperFactory.instance);
   }
   ```

4. **استخدم await مع جميع العمليات**
   ```dart
   final email = await repository.getUserEmail();
   ```

### ❌ DON'T

1. **لا تستخدم SharedPreferences مباشرة**
   ```dart
   // ❌ خطأ
   final prefs = await SharedPreferences.getInstance();
   ```

2. **لا تستخدم hard-coded strings**
   ```dart
   // ❌ خطأ
   await cacheHelper.setString('user_email', 'test@example.com');
   
   // ✅ صحيح
   await cacheHelper.setString(StorageKeys.userEmail, 'test@example.com');
   ```

3. **لا تنسى await**
   ```dart
   // ❌ خطأ
   repository.saveUserEmail('test@example.com'); // بدون await
   
   // ✅ صحيح
   await repository.saveUserEmail('test@example.com');
   ```

---

## التعامل مع الحالات الخاصة

### حالة 1: عمليات متعددة

#### قبل:
```dart
final prefs = await SharedPreferences.getInstance();
await prefs.setString('key1', 'value1');
await prefs.setString('key2', 'value2');
await prefs.setString('key3', 'value3');
```

#### بعد:
```dart
final cacheHelper = CacheHelperFactory.instance;
await Future.wait([
  cacheHelper.setString('key1', 'value1'),
  cacheHelper.setString('key2', 'value2'),
  cacheHelper.setString('key3', 'value3'),
]);
```

### حالة 2: JSON Storage

#### قبل:
```dart
final prefs = await SharedPreferences.getInstance();
final json = jsonEncode({'name': 'John', 'age': 30});
await prefs.setString('user_data', json);

final savedJson = prefs.getString('user_data');
final data = jsonDecode(savedJson!);
```

#### بعد:
```dart
final repository = LocalStorageRepository(CacheHelperFactory.instance);
await repository.saveSettings({'name': 'John', 'age': 30});

final data = await repository.getSettings();
```

### حالة 3: Clear Specific Keys

#### قبل:
```dart
final prefs = await SharedPreferences.getInstance();
await prefs.remove('access_token');
await prefs.remove('refresh_token');
await prefs.remove('user_id');
```

#### بعد:
```dart
final repository = LocalStorageRepository(CacheHelperFactory.instance);
await repository.clearAuthData();

// أو
await repository.performLogout(); // يمسح كل البيانات المتعلقة بالمستخدم
```

---

## الخلاصة

الترحيل للنظام الجديد يوفر:

- ✅ **كود أنظف**: استخدام Repository Pattern
- ✅ **أمان أفضل**: إدارة مركزية للمفاتيح
- ✅ **سهولة الاختبار**: Dependency Injection
- ✅ **مرونة**: سهولة التبديل بين أنظمة التخزين
- ✅ **أداء أفضل**: استخدام SharedPreferencesAsync/WithCache

---

## الحصول على المساعدة

إذا واجهت أي مشاكل أثناء الترحيل:

1. راجع `README.md` للتوثيق الكامل
2. راجع `USAGE_EXAMPLES.dart` للأمثلة العملية
3. تأكد من استخدام `StorageKeys` للمفاتيح
4. تأكد من استخدام `await` مع جميع العمليات
