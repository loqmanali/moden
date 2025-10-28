# 🚀 دليل البدء السريع - Quick Start Guide

## 📦 التثبيت

لا يوجد تثبيت إضافي! النظام يستخدم `shared_preferences` الموجود بالفعل.

---

## ⚡ البدء السريع (5 دقائق)

### 1️⃣ الاستخدام الأساسي

```dart
import 'package:granzia_health_connect/core/storage/storage.dart';

// إنشاء repository
final repository = LocalStorageRepository(
  CacheHelperFactory.instance,
);

// حفظ بيانات
await repository.saveUserEmail('user@example.com');

// قراءة بيانات
final email = await repository.getUserEmail();
print('Email: $email');
```

### 2️⃣ حفظ وقراءة Authentication

```dart
// حفظ tokens
await repository.saveAuthTokens(
  accessToken: 'your_access_token',
  refreshToken: 'your_refresh_token',
);

// التحقق من تسجيل الدخول
final isLoggedIn = await repository.isLoggedIn();

// قراءة token
final token = await repository.getAccessToken();

// تسجيل خروج
await repository.clearAuthData();
```

### 3️⃣ إدارة Onboarding

```dart
// تعيين onboarding كمكتمل
await repository.setOnboardingCompleted();

// التحقق من الإكمال
final hasSeen = await repository.hasSeenOnboarding();

if (!hasSeen) {
  // عرض onboarding
}
```

### 4️⃣ حفظ Settings

```dart
// حفظ theme
await repository.saveThemeMode('dark');

// حفظ اللغة
await repository.saveLocale('ar');

// قراءة theme
final theme = await repository.getThemeMode();
```

---

## 🎯 حالات الاستخدام الشائعة

### في BLoC/Cubit

```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LocalStorageRepository _repository;

  AuthBloc({LocalStorageRepository? repository})
      : _repository = repository ??
            LocalStorageRepository(CacheHelperFactory.instance),
        super(AuthInitial());

  Future<void> login(String email, String password) async {
    // ... login logic
    
    await _repository.saveAuthTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
  }

  Future<void> logout() async {
    await _repository.clearAuthData();
  }
}
```

### في Service

```dart
class UserService {
  final LocalStorageRepository _repository;

  UserService({LocalStorageRepository? repository})
      : _repository = repository ??
            LocalStorageRepository(CacheHelperFactory.instance);

  Future<void> saveUserData(User user) async {
    await _repository.saveUserId(user.id);
    await _repository.saveUserEmail(user.email);
  }

  Future<String?> getUserId() async {
    return await _repository.getUserId();
  }
}
```

### في Screen/Widget

```dart
class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingFlow(
        onComplete: () async {
          final repository = LocalStorageRepository(
            CacheHelperFactory.instance,
          );
          await repository.setOnboardingCompleted();
          
          if (context.mounted) {
            context.go('/home');
          }
        },
      ),
    );
  }
}
```

---

## 🔑 استخدام المفاتيح (StorageKeys)

```dart
import 'package:granzia_health_connect/core/storage/storage.dart';

final cacheHelper = CacheHelperFactory.instance;

// استخدام المفاتيح المعرفة
await cacheHelper.setString(
  StorageKeys.accessToken,
  'token123',
);

await cacheHelper.setBool(
  StorageKeys.hasSeenOnboarding,
  true,
);

// قراءة
final token = await cacheHelper.getString(StorageKeys.accessToken);
final hasSeen = await cacheHelper.getBool(StorageKeys.hasSeenOnboarding);
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
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    
    final repository = LocalStorageRepository(
      CacheHelperFactory.instance,
    );
    
    final hasSeen = await repository.hasSeenOnboarding();
    
    if (!mounted) return;
    
    if (hasSeen) {
      context.go('/home');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
```

### مثال 2: Settings Screen

```dart
class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _repository = LocalStorageRepository(
    CacheHelperFactory.instance,
  );
  
  bool _notificationsEnabled = true;
  bool _biometricsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final notifications = await _repository.getNotificationsEnabled();
    final biometrics = await _repository.getBiometricsEnabled();
    
    setState(() {
      _notificationsEnabled = notifications;
      _biometricsEnabled = biometrics;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    await _repository.setNotificationsEnabled(value);
    setState(() => _notificationsEnabled = value);
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
          // ... more settings
        ],
      ),
    );
  }
}
```

### مثال 3: Login Screen

```dart
class LoginScreen extends StatelessWidget {
  final _repository = LocalStorageRepository(
    CacheHelperFactory.instance,
  );

  Future<void> _login(String email, String password) async {
    // Call API
    final response = await authApi.login(email, password);
    
    // Save tokens
    await _repository.saveAuthTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
    
    // Save user info
    await _repository.saveUserId(response.userId);
    await _repository.saveUserEmail(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginForm(
        onSubmit: (email, password) async {
          await _login(email, password);
          context.go('/home');
        },
      ),
    );
  }
}
```

---

## 🎨 أنماط الاستخدام المختلفة

### Pattern 1: Direct Repository Usage (موصى به)

```dart
final repository = LocalStorageRepository(
  CacheHelperFactory.instance,
);

await repository.saveUserEmail('user@example.com');
final email = await repository.getUserEmail();
```

**متى تستخدمه:**
- ✅ للعمليات الشائعة (Auth, Settings, etc.)
- ✅ عندما تريد API عالي المستوى
- ✅ للكود النظيف والمقروء

### Pattern 2: Direct CacheHelper Usage

```dart
final cacheHelper = CacheHelperFactory.instance;

await cacheHelper.setString(StorageKeys.customKey, 'value');
final value = await cacheHelper.getString(StorageKeys.customKey);
```

**متى تستخدمه:**
- ✅ للبيانات المخصصة
- ✅ عندما لا يوجد method في Repository
- ✅ للتحكم الكامل

### Pattern 3: Dependency Injection

```dart
class MyService {
  final LocalStorageRepository _repository;

  MyService({LocalStorageRepository? repository})
      : _repository = repository ??
            LocalStorageRepository(CacheHelperFactory.instance);

  Future<void> doSomething() async {
    await _repository.saveUserEmail('user@example.com');
  }
}

// في الاختبار
final mockRepository = MockLocalStorageRepository();
final service = MyService(repository: mockRepository);
```

**متى تستخدمه:**
- ✅ في Services و BLoCs
- ✅ عندما تريد testability
- ✅ للكود المرن

---

## ⚙️ التهيئة في main.dart

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة CacheHelper (اختياري ولكن موصى به)
  await CacheHelperFactory.initializeSingleton();

  runApp(MyApp());
}
```

---

## 🧪 الاختبار (Testing)

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockLocalStorageRepository extends Mock 
    implements LocalStorageRepository {}

void main() {
  late MockLocalStorageRepository mockRepository;

  setUp(() {
    mockRepository = MockLocalStorageRepository();
  });

  test('should save user email', () async {
    when(mockRepository.saveUserEmail('test@example.com'))
        .thenAnswer((_) async => true);

    final result = await mockRepository.saveUserEmail('test@example.com');

    expect(result, true);
    verify(mockRepository.saveUserEmail('test@example.com')).called(1);
  });
}
```

---

## 📚 المزيد من الموارد

- 📖 **README.md** - توثيق شامل
- 💡 **USAGE_EXAMPLES.dart** - 10 أمثلة عملية
- 🔄 **MIGRATION_GUIDE.md** - دليل الترحيل
- 📊 **IMPLEMENTATION_SUMMARY.md** - ملخص التنفيذ

---

## ❓ الأسئلة الشائعة

### س: متى أستخدم Repository ومتى أستخدم CacheHelper؟

**ج:** استخدم Repository للعمليات الشائعة (Auth, Settings, etc.) واستخدم CacheHelper للبيانات المخصصة.

### س: هل يجب تهيئة CacheHelper في main.dart؟

**ج:** اختياري ولكن موصى به للأداء الأفضل.

### س: كيف أضيف مفتاح جديد؟

**ج:** أضفه في `StorageKeys`:
```dart
class StorageKeys {
  static const String myNewKey = 'my_new_key';
}
```

### س: كيف أستخدم WithCache للأداء الأفضل؟

**ج:**
```dart
final cacheHelper = await CacheHelperFactory.createWithCache(
  allowList: StorageKeys.allKeys,
);
final repository = LocalStorageRepository(cacheHelper);
```

---

## 🎉 ابدأ الآن!

```dart
// 1. Import
import 'package:granzia_health_connect/core/storage/storage.dart';

// 2. Create Repository
final repository = LocalStorageRepository(
  CacheHelperFactory.instance,
);

// 3. Use it!
await repository.saveUserEmail('user@example.com');
final email = await repository.getUserEmail();

print('Email: $email'); // Email: user@example.com
```

**مبروك! 🎊 أنت الآن جاهز لاستخدام نظام التخزين الجديد!**
