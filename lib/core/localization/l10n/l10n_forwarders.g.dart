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
  static Locale? _currentLocale;

  /// Initialize the global localization instance
  static void init(BuildContext context) {
    _current = AppLocalizations.of(context);
    _currentLocale = Localizations.localeOf(context);
  }

  static String get currentLanguageCode => _currentLocale?.languageCode ?? 'en';

  static bool get isArabic => currentLanguageCode == 'ar';

  static bool get isEnglish => currentLanguageCode == 'en';

  /// Get the current app localizations instance
  static AppLocalizations get _tr {
    if (_current == null) {
      throw Exception('L10n used before init. Call L10n.init(context) after Localizations load.');
    }
    return _current!;
  }

  // Getters
  static String get appTitle => _tr.appTitle;
  static String get appDescription => _tr.appDescription;
  static String get getStarted => _tr.getStarted;
  static String get signIn => _tr.signIn;
  static String get signUp => _tr.signUp;
  static String get email => _tr.email;
  static String get emailPlaceholder => _tr.emailPlaceholder;
  static String get password => _tr.password;
  static String get passwordPlaceholder => _tr.passwordPlaceholder;
  static String get pleaseEnterYourEmail => _tr.pleaseEnterYourEmail;
  static String get pleaseEnterYourPassword => _tr.pleaseEnterYourPassword;
  static String get pleaseEnterValidEmail => _tr.pleaseEnterValidEmail;
  static String get passwordMustBeAtLeast6Characters => _tr.passwordMustBeAtLeast6Characters;
  static String get events => _tr.events;

  // Methods
}
