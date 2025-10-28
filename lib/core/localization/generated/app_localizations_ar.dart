// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'برنامج المدن الطبية';

  @override
  String get appDescription => 'تحقق سريع وآمن من التذاكر لموظفي الفعاليات';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signUp => 'تسجيل';

  @override
  String get email => 'البريد الالكتروني';

  @override
  String get emailPlaceholder => 'أدخل البريد الالكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get passwordPlaceholder => 'أدخل كلمة المرور';

  @override
  String get pleaseEnterYourEmail => 'من فضلك أدخل البريد الالكتروني';

  @override
  String get pleaseEnterYourPassword => 'من فضلك أدخل كلمة المرور';

  @override
  String get pleaseEnterValidEmail => 'من فضلك أدخل بريد الكتروني صالح';

  @override
  String get passwordMustBeAtLeast6Characters =>
      'كلمة المرور يجب أن تكون على الأقل 6 أحرف';

  @override
  String get events => 'فعالياتي';
}
