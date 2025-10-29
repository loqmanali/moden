import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceInfoService {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// Get unique device identifier
  Future<String> getDeviceId() async {
    try {
      if (kIsWeb) {
        final webInfo = await _deviceInfo.webBrowserInfo;
        return 'web_${webInfo.userAgent?.hashCode ?? 'unknown'}';
      } else if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return androidInfo.id; // Android ID
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? 'ios_unknown';
      } else {
        return 'unknown_platform';
      }
    } catch (e) {
      return 'error_getting_device_id';
    }
  }

  /// Get device model name
  Future<String> getDeviceModel() async {
    try {
      if (kIsWeb) {
        final webInfo = await _deviceInfo.webBrowserInfo;
        return '${webInfo.browserName} ${webInfo.platform}';
      } else if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return '${androidInfo.brand} ${androidInfo.model}';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return '${iosInfo.name} ${iosInfo.model}';
      } else {
        return 'Unknown Device';
      }
    } catch (e) {
      return 'Unknown Device';
    }
  }

  /// Get complete device info string
  Future<String> getDeviceInfo() async {
    try {
      if (kIsWeb) {
        final webInfo = await _deviceInfo.webBrowserInfo;
        return 'Web: ${webInfo.browserName} on ${webInfo.platform}';
      } else if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return 'Android: ${androidInfo.brand} ${androidInfo.model} (${androidInfo.version.release})';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return 'iOS: ${iosInfo.name} ${iosInfo.model} (${iosInfo.systemVersion})';
      } else {
        return 'Unknown Platform';
      }
    } catch (e) {
      return 'Error getting device info';
    }
  }
}
