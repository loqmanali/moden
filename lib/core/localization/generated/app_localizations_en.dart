// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Medical Cities Program';

  @override
  String get appDescription => 'Fast, secure ticket validation for event staff';

  @override
  String get getStarted => 'Get Started';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get email => 'E-mail';

  @override
  String get emailPlaceholder => 'Enter your email';

  @override
  String get password => 'Password';

  @override
  String get passwordPlaceholder => 'Enter your password';

  @override
  String get pleaseEnterYourEmail => 'Please Enter Your Email';

  @override
  String get pleaseEnterYourPassword => 'Please Enter Your Password';

  @override
  String get pleaseEnterValidEmail => 'Please Enter Valid Email';

  @override
  String get passwordMustBeAtLeast6Characters =>
      'Password Must Be At Least 6 Characters';

  @override
  String get events => 'Events';
}
