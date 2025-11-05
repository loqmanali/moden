import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Medical Cities Program'**
  String get appTitle;

  /// The description of the application
  ///
  /// In en, this message translates to:
  /// **'Fast, secure ticket validation for event staff'**
  String get appDescription;

  /// Get started button text
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Sign in button text
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Sign up button text
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get email;

  /// Email placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailPlaceholder;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Password placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordPlaceholder;

  /// Please Enter Your Email
  ///
  /// In en, this message translates to:
  /// **'Please Enter Your Email'**
  String get pleaseEnterYourEmail;

  /// Please Enter Your Password
  ///
  /// In en, this message translates to:
  /// **'Please Enter Your Password'**
  String get pleaseEnterYourPassword;

  /// Please Enter Valid Email
  ///
  /// In en, this message translates to:
  /// **'Please Enter Valid Email'**
  String get pleaseEnterValidEmail;

  /// Password Must Be At Least 6 Characters
  ///
  /// In en, this message translates to:
  /// **'Password Must Be At Least 6 Characters'**
  String get passwordMustBeAtLeast6Characters;

  /// Events
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// Start Scanning
  ///
  /// In en, this message translates to:
  /// **'Start Scanning'**
  String get startScanning;

  /// View Workshops
  ///
  /// In en, this message translates to:
  /// **'View Workshops'**
  String get viewWorkshops;

  /// QR Validator
  ///
  /// In en, this message translates to:
  /// **'QR Validator'**
  String get qrScreenTitle;

  /// Processing...
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// Scan QR Code
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQrCode;

  /// Workshops
  ///
  /// In en, this message translates to:
  /// **'Workshops'**
  String get workshops;

  /// Starting Camera...
  ///
  /// In en, this message translates to:
  /// **'Starting Camera...'**
  String get startingCamera;

  /// Stop Scanning
  ///
  /// In en, this message translates to:
  /// **'Stop Scanning'**
  String get stopScanning;

  /// Start Camera & Scan
  ///
  /// In en, this message translates to:
  /// **'Start Camera & Scan'**
  String get startCameraScan;

  /// Accepted
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get accepted;

  /// Access Granted
  ///
  /// In en, this message translates to:
  /// **'Access Granted'**
  String get accessGranted;

  /// Ticket Validated Successfully
  ///
  /// In en, this message translates to:
  /// **'Ticket Validated Successfully'**
  String get ticketValidatedSuccessfully;

  /// Scan Next Ticket
  ///
  /// In en, this message translates to:
  /// **'Scan Next Ticket'**
  String get scanNextTicket;

  /// Return to My Events
  ///
  /// In en, this message translates to:
  /// **'Return to My Events'**
  String get returnToMyEvents;

  /// Rejected
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// Access Denied
  ///
  /// In en, this message translates to:
  /// **'Access Denied'**
  String get accessDenied;

  /// Invalid or already used ticket
  ///
  /// In en, this message translates to:
  /// **'Invalid or already used ticket'**
  String get invalidOrAlreadyUsedTicket;

  /// Workshops Coming Soon
  ///
  /// In en, this message translates to:
  /// **'Workshops Coming Soon'**
  String get workshopsComingSoon;

  /// Stay Tuned
  ///
  /// In en, this message translates to:
  /// **'Stay tuned — curated sessions will appear here as soon as they’re ready.'**
  String get stayTuned;

  /// Events Empty State Text
  ///
  /// In en, this message translates to:
  /// **'We’re curating the next experience. Check back soon to discover what’s coming next.'**
  String get eventsEmptyStateText;

  /// No Active Events Yet
  ///
  /// In en, this message translates to:
  /// **'No active events yet'**
  String get noActiveEventsYet;

  /// Back
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// QR Code
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get qrCode;

  /// Enter National ID
  ///
  /// In en, this message translates to:
  /// **'Enter National ID'**
  String get enterNationalId;

  /// National ID Must Be 10 Digits
  ///
  /// In en, this message translates to:
  /// **'National ID Must Be 10 Digits'**
  String get nationalIdMustBe10Digits;

  /// Search
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Please Enter National ID
  ///
  /// In en, this message translates to:
  /// **'Please Enter National ID'**
  String get pleaseEnterNationalId;

  /// Search By National ID
  ///
  /// In en, this message translates to:
  /// **'Search By National ID'**
  String get searchByNationalId;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
