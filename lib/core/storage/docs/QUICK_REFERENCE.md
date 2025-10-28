# 📖 مرجع سريع - Quick Reference

## 🚀 التهيئة

```dart
// في main.dart
await StorageLocator.init();                    // SharedPreferences
await StorageLocator.init(useHive: true);       // Hive (أسرع)
await StorageLocator.init(                      // Hive مع تشفير
  useHive: true,
  hiveEncryptionKey: 'your-secret-key',
);
```

---

## 🔐 Authentication

```dart
// حفظ tokens
await Storage.saveTokens(
  accessToken: 'token',
  refreshToken: 'refresh',
);

// قراءة tokens
final token = await Storage.getToken();
final refreshToken = await Storage.getRefreshToken();

// حفظ معلومات المستخدم
await Storage.saveUserEmail('user@example.com');
await Storage.saveUserId('user_123');

// قراءة معلومات المستخدم
final email = await Storage.getUserEmail();
final userId = await Storage.getUserId();

// التحقق من تسجيل الدخول
final isLoggedIn = await Storage.isLoggedIn();

// تسجيل خروج
await Storage.logout();                  // مسح auth data فقط
await Storage.completeLogout();          // مسح كل بيانات المستخدم
```

---

## 📱 Onboarding

```dart
// تعيين onboarding كمكتمل
await Storage.completeOnboarding();
await Storage.completeOnboarding(version: 2);

// التحقق من الإكمال
final hasSeen = await Storage.hasSeenOnboarding();
```

---

## ⚙️ Settings

```dart
// Theme
await Storage.saveTheme('dark');
final theme = await Storage.getTheme();

// Language
await Storage.saveLanguage('ar');
final language = await Storage.getLanguage();

// Settings Object
await Storage.saveSettings({
  'theme': 'dark',
  'language': 'ar',
  'fontSize': 16,
});
final settings = await Storage.getSettings();
```

---

## 👤 User Preferences

```dart
// Notifications
await Storage.setNotifications(true);
final enabled = await Storage.areNotificationsEnabled();

// Biometrics
await Storage.setBiometrics(true);
final enabled = await Storage.areBiometricsEnabled();
```

---

## 💾 Generic Operations

```dart
// String
await Storage.saveString('key', 'value');
final value = await Storage.getString('key');

// Int
await Storage.saveInt('age', 25);
final age = await Storage.getInt('age');

// Bool
await Storage.saveBool('flag', true);
final flag = await Storage.getBool('flag');

// Check existence
final exists = await Storage.has('key');

// Remove
await Storage.remove('key');

// Clear all
await Storage.clearAll();

// Reload
await Storage.reload();
```

---

## 🎨 Advanced Usage

```dart
// Repository access
final repository = Storage.repository;
await repository.saveDevices([...]);
await repository.saveDeviceReadings({...});

// CacheHelper access
final cacheHelper = StorageLocator.cacheHelper;
await cacheHelper.setString(StorageKeys.accessToken, 'token');

// Direct repository
final repository = StorageLocator.repository;
```

---

## 📊 Storage Keys

```dart
// Authentication
StorageKeys.accessToken
StorageKeys.refreshToken
StorageKeys.userId
StorageKeys.userEmail
StorageKeys.isLoggedIn

// Onboarding
StorageKeys.hasSeenOnboarding
StorageKeys.onboardingVersion

// Settings
StorageKeys.settings
StorageKeys.themeMode
StorageKeys.languageCode

// Health Devices
StorageKeys.savedDevices
StorageKeys.deviceReadings
StorageKeys.lastSyncTime

// Preferences
StorageKeys.notificationsEnabled
StorageKeys.biometricsEnabled
StorageKeys.autoSyncEnabled
```

---

## 🔄 Common Patterns

### Splash Screen
```dart
final hasSeen = await Storage.hasSeenOnboarding();
final isLoggedIn = await Storage.isLoggedIn();

if (!hasSeen) {
  context.go('/onboarding');
} else if (isLoggedIn) {
  context.go('/home');
} else {
  context.go('/login');
}
```

### Login
```dart
final response = await api.login(email, password);

await Storage.saveTokens(
  accessToken: response.accessToken,
  refreshToken: response.refreshToken,
);

await Storage.saveUserEmail(email);
await Storage.saveUserId(response.userId);
```

### Logout
```dart
await Storage.logout();
context.go('/login');
```

### Settings Load
```dart
final theme = await Storage.getTheme() ?? 'light';
final language = await Storage.getLanguage() ?? 'en';
final notifications = await Storage.areNotificationsEnabled();
```

---

## 🎯 Quick Tips

1. **استخدم Hive للأداء الأفضل**
   ```dart
   await StorageLocator.init(useHive: true);
   ```

2. **استخدم Storage للعمليات البسيطة**
   ```dart
   await Storage.saveUserEmail('user@example.com');
   ```

3. **استخدم Repository للعمليات المعقدة**
   ```dart
   await Storage.repository.saveSettings({...});
   ```

4. **استخدم StorageKeys للمفاتيح**
   ```dart
   await cacheHelper.setString(StorageKeys.accessToken, 'token');
   ```

---

## 📚 Documentation Files

- `SETUP_GUIDE.md` - دليل الإعداد الكامل
- `SIMPLE_EXAMPLES.dart` - 10 أمثلة بسيطة
- `QUICK_START.md` - البدء السريع
- `README.md` - التوثيق الشامل
- `USAGE_EXAMPLES.dart` - أمثلة متقدمة
- `MIGRATION_GUIDE.md` - دليل الترحيل

---

## ⚡ One-Liners

```dart
// Save & Read
await Storage.saveUserEmail('user@example.com');
final email = await Storage.getUserEmail();

// Check & Logout
if (await Storage.isLoggedIn()) await Storage.logout();

// Theme
await Storage.saveTheme(isDark ? 'dark' : 'light');

// Onboarding
if (!await Storage.hasSeenOnboarding()) showOnboarding();

// Notifications
await Storage.setNotifications(!await Storage.areNotificationsEnabled());
```

---

## 🎉 الخلاصة

```dart
// 1. Init
await StorageLocator.init();

// 2. Use
await Storage.saveUserEmail('user@example.com');
final email = await Storage.getUserEmail();

// 3. Done! 🎊
```
