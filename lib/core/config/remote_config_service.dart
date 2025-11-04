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
