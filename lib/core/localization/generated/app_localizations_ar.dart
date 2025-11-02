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

  @override
  String get startScanning => 'بدء المسح';

  @override
  String get viewWorkshops => 'عرض الدورات';

  @override
  String get qrScreenTitle => ' مسح الرمز';

  @override
  String get processing => 'معالجة...';

  @override
  String get scanQrCode => ' مسح الرمز';

  @override
  String get workshops => 'دورات';

  @override
  String get startingCamera => 'بدء الكاميرا...';

  @override
  String get stopScanning => 'إيقاف المسح';

  @override
  String get startCameraScan => 'بدء الكاميرا و المسح';

  @override
  String get accepted => 'القبول';

  @override
  String get accessGranted => 'تم القبول';

  @override
  String get ticketValidatedSuccessfully => 'تم التحقق من التذكرة بنجاح';

  @override
  String get scanNextTicket => 'مسح التذكرة التالية';

  @override
  String get returnToMyEvents => 'الرجوع إلى فعالياتي';

  @override
  String get rejected => 'الرفض';

  @override
  String get accessDenied => 'مرفوض';

  @override
  String get invalidOrAlreadyUsedTicket =>
      'التذكرة غير صالحة أو تم استخدامها مسبقًا';

  @override
  String get workshopsComingSoon => 'الدورات قريبا';

  @override
  String get stayTuned =>
      'ترقبوا - سيتم ظهور الجلسات المختارة هنا بمجرد التحضير';

  @override
  String get eventsEmptyStateText =>
      'نحن نُحضِّر التجربة القادمة. عُد قريبًا لتكتشف ما الجديد.';

  @override
  String get noActiveEventsYet => 'لا توجد فعاليات';
}
