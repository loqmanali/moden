import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppSystemUi {
  /// Generates SystemUiOverlayStyle based on current theme.
  static SystemUiOverlayStyle getOverlayStyle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color appBarBg =
        theme.appBarTheme.backgroundColor ?? colorScheme.surface;

    final Brightness statusIconBrightness =
        ThemeData.estimateBrightnessForColor(appBarBg) == Brightness.dark
            ? Brightness.light
            : Brightness.dark;

    return SystemUiOverlayStyle(
      statusBarColor: appBarBg,
      statusBarIconBrightness: statusIconBrightness,
      statusBarBrightness: statusIconBrightness == Brightness.light
          ? Brightness.dark
          : Brightness.light,
      systemNavigationBarColor:
          theme.brightness == Brightness.dark ? Colors.black : Colors.white,
      systemNavigationBarIconBrightness: theme.brightness == Brightness.dark
          ? Brightness.light
          : Brightness.dark,
    );
  }

  /// Applies overlay style globally (optional)
  static void applySystemUI(BuildContext context) {
    final overlay = getOverlayStyle(context);
    SystemChrome.setSystemUIOverlayStyle(overlay);
  }

  /// Sets SystemUiOverlayStyle without context (for use in main)
  /// [isDark] - whether the app is using dark mode
  static void setSystemUIWithoutContext({bool isDark = false}) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: isDark ? Colors.black : Colors.white,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }

  /// Sets edge-to-edge mode (Android)
  static void setEdgeToEdge() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
    );
  }
}
