// GENERATED CODE - DO NOT MODIFY BY HAND
// *****************************************************
//  L10n forwarders generated from app_localizations.dart
//  Run: dart run tool/generate_l10n_forwarders.dart
// *****************************************************

part of '../localization.dart';

/// Global localization utility for accessing translations without context
class L10n {
  /// The current app localizations instance
  static AppLocalizations? _current;

  /// Initialize the global localization instance
  static void init(BuildContext context) {
    _current = AppLocalizations.of(context);
  }

  /// Get the current app localizations instance
  static AppLocalizations get _tr {
    if (_current == null) {
      throw Exception(
          'L10n used before init. Call L10n.init(context) after Localizations load.');
    }
    return _current!;
  }

  // Getters
  static String get appTitle => _tr.appTitle;
  static String get welcome => _tr.welcome;
  static String get signIn => _tr.signIn;
  static String get signUp => _tr.signUp;
  static String get email => _tr.email;
  static String get password => _tr.password;
  static String get forgotPassword => _tr.forgotPassword;
  static String get settings => _tr.settings;
  static String get language => _tr.language;
  static String get theme => _tr.theme;
  static String get darkMode => _tr.darkMode;
  static String get lightMode => _tr.lightMode;
  static String get systemMode => _tr.systemMode;
  static String get notifications => _tr.notifications;
  static String get notificationSent => _tr.notificationSent;
  static String get enableNotifications => _tr.enableNotifications;
  static String get receiveNotifications => _tr.receiveNotifications;
  static String get sendTestNotification => _tr.sendTestNotification;
  static String get deviceToken => _tr.deviceToken;
  static String get loading => _tr.loading;
  static String get notAvailable => _tr.notAvailable;

  // Methods
  static String hello(String name) => _tr.hello(name);
  static String counter(int count) => _tr.counter(count);
}
