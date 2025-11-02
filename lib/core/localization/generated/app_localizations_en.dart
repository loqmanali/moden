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

  @override
  String get startScanning => 'Start Scanning';

  @override
  String get viewWorkshops => 'View Workshops';

  @override
  String get qrScreenTitle => 'QR Validator';

  @override
  String get processing => 'Processing...';

  @override
  String get scanQrCode => 'Scan QR Code';

  @override
  String get workshops => 'Workshops';

  @override
  String get startingCamera => 'Starting Camera...';

  @override
  String get stopScanning => 'Stop Scanning';

  @override
  String get startCameraScan => 'Start Camera & Scan';

  @override
  String get accepted => 'Accepted';

  @override
  String get accessGranted => 'Access Granted';

  @override
  String get ticketValidatedSuccessfully => 'Ticket Validated Successfully';

  @override
  String get scanNextTicket => 'Scan Next Ticket';

  @override
  String get returnToMyEvents => 'Return to My Events';

  @override
  String get rejected => 'Rejected';

  @override
  String get accessDenied => 'Access Denied';

  @override
  String get invalidOrAlreadyUsedTicket => 'Invalid or already used ticket';

  @override
  String get workshopsComingSoon => 'Workshops Coming Soon';

  @override
  String get stayTuned =>
      'Stay tuned — curated sessions will appear here as soon as they’re ready.';

  @override
  String get eventsEmptyStateText =>
      'We’re curating the next experience. Check back soon to discover what’s coming next.';

  @override
  String get noActiveEventsYet => 'No active events yet';
}
