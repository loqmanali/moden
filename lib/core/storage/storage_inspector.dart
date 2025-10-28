import 'dart:convert';

import 'storage.dart';

class StorageUsageEntry {
  final String key;
  final int sizeBytes;
  final String? preview;

  StorageUsageEntry({required this.key, required this.sizeBytes, this.preview});
}

class StorageUsageSummary {
  final int totalBytes;
  final List<StorageUsageEntry> entries;

  StorageUsageSummary({required this.totalBytes, required this.entries});
}

class StorageInspector {
  static Future<StorageUsageSummary> getUsageSummary() async {
    int total = 0;
    final List<StorageUsageEntry> entries = [];

    for (final key in StorageKeys.allKeys) {
      final dynamicVal = await _readAny(key);
      if (dynamicVal == null) continue;
      final serialized = jsonEncode(dynamicVal);
      final bytes = utf8.encode(serialized).length;
      total += bytes;
      entries.add(StorageUsageEntry(
        key: key,
        sizeBytes: bytes,
        preview: _shorten(serialized),
      ));
    }

    // Also include custom keys that may not be in StorageKeys (like insights_* and profile_* keys)
    for (final extraKey in const [
      'insights_weekly_trends',
      'insights_health_score',
      'insights_goals',
      'insights_last_updated',
      'user_profile',
      'user_goals',
      'user_achievements',
      'profile_last_updated',
      'app_settings',
      'settings_last_updated',
    ]) {
      if (StorageKeys.allKeys.contains(extraKey)) continue;
      final dynamicVal = await _readAny(extraKey);
      if (dynamicVal == null) continue;
      final serialized = jsonEncode(dynamicVal);
      final bytes = utf8.encode(serialized).length;
      total += bytes;
      entries.add(StorageUsageEntry(
        key: extraKey,
        sizeBytes: bytes,
        preview: _shorten(serialized),
      ));
    }

    // Sort by size desc
    entries.sort((a, b) => b.sizeBytes.compareTo(a.sizeBytes));

    return StorageUsageSummary(totalBytes: total, entries: entries);
  }

  static Future<dynamic> _readAny(String key) async {
    // Try string first
    final s = await Storage.getString(key);
    if (s != null) {
      // Try to decode if it's JSON to return structured value; otherwise raw string
      try {
        return jsonDecode(s);
      } catch (_) {
        return s;
      }
    }
    final i = await Storage.getInt(key);
    if (i != null) return i;
    final b = await Storage.getBool(key);
    if (b != null) return b;
    return null;
  }

  static String humanizeBytes(int bytes) {
    const units = ['B', 'KB', 'MB', 'GB'];
    double size = bytes.toDouble();
    int unit = 0;
    while (size >= 1024 && unit < units.length - 1) {
      size /= 1024;
      unit++;
    }
    return '${size.toStringAsFixed(size < 10 && unit > 0 ? 1 : 0)} ${units[unit]}';
  }

  static String _shorten(String s, {int max = 120}) {
    if (s.length <= max) return s;
    return '${s.substring(0, max)}…';
  }
}
