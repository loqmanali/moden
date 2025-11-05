import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static final FirebaseRemoteConfig _remoteConfig =
      FirebaseRemoteConfig.instance;

  static Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 10),
      ),
    );

    // Default values
    await _remoteConfig.setDefaults({
      'is_dev': true,
    });

    await _remoteConfig.fetchAndActivate();
  }

  static bool get isDev => _remoteConfig.getBool('is_dev');
}

// import 'package:firebase_remote_config/firebase_remote_config.dart';
// import 'package:flutter/foundation.dart';
// import 'package:package_info_plus/package_info_plus.dart';

// class RemoteConfigService {
//   static final FirebaseRemoteConfig _remoteConfig =
//       FirebaseRemoteConfig.instance;

//   static const String _unknownContextKey = 'unknown';
//   static String _platformKey = _unknownContextKey;
//   static String? _versionKey;
//   static bool _initialized = false;

//   static Future<void> initialize({
//     String? overridePlatform,
//     String? overrideVersion,
//   }) async {
//     _platformKey =
//         _sanitizeKey(overridePlatform) ?? _resolvePlatformKey().toLowerCase();

//     if (overrideVersion != null) {
//       _versionKey = _sanitizeKey(overrideVersion);
//     } else {
//       _versionKey ??= _sanitizeKey(await _resolveAppVersion());
//     }

//     if (_initialized) {
//       return;
//     }

//     await _remoteConfig.setConfigSettings(
//       RemoteConfigSettings(
//         fetchTimeout: const Duration(seconds: 10),
//         minimumFetchInterval: const Duration(seconds: 10),
//       ),
//     );

//     // Default values
//     await _remoteConfig.setDefaults({
//       'is_dev': true,
//     });

//     await _remoteConfig.fetchAndActivate();

//     _initialized = true;
//   }

//   static bool get isDev => getBool('is_dev');

//   static bool getBool(String baseKey, {bool defaultValue = false}) {
//     final parameters = _remoteConfig.getAll();
//     for (final key in _buildCandidateKeys(baseKey)) {
//       if (key != null && parameters.containsKey(key)) {
//         return _remoteConfig.getBool(key);
//       }
//     }
//     return defaultValue;
//   }

//   static List<String?> _buildCandidateKeys(String baseKey) {
//     final keys = <String?>[];
//     final versionKey = _versionKey;
//     final platformKey =
//         _platformKey == _unknownContextKey ? null : _platformKey;

//     if (platformKey != null && versionKey != null) {
//       keys.add('${baseKey}_${platformKey}_$versionKey');
//     }
//     if (platformKey != null) {
//       keys.add('${baseKey}_$platformKey');
//     }
//     if (versionKey != null) {
//       keys.add('${baseKey}_$versionKey');
//     }
//     keys.add(baseKey);

//     return keys;
//   }

//   static Future<String?> _resolveAppVersion() async {
//     try {
//       final packageInfo = await PackageInfo.fromPlatform();
//       return packageInfo.version;
//     } catch (_) {
//       return null;
//     }
//   }

//   static String _resolvePlatformKey() {
//     if (kIsWeb) {
//       return 'web';
//     }

//     return switch (defaultTargetPlatform) {
//       TargetPlatform.android => 'android',
//       TargetPlatform.iOS => 'ios',
//       TargetPlatform.macOS => 'macos',
//       TargetPlatform.windows => 'windows',
//       TargetPlatform.linux => 'linux',
//       TargetPlatform.fuchsia => 'fuchsia',
//     };
//   }

//   static String? _sanitizeKey(String? rawKey) {
//     if (rawKey == null || rawKey.isEmpty) {
//       return null;
//     }

//     final normalized = rawKey
//         .toLowerCase()
//         .split(RegExp('[^a-z0-9]+'))
//         .where((segment) => segment.isNotEmpty)
//         .join('_');

//     if (normalized.isEmpty) {
//       return null;
//     }

//     return normalized;
//   }
// }
