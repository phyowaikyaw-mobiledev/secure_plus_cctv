import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_my.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('en'),
    Locale('my'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Secure Plus'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Your Security, Our Responsibility'**
  String get appTagline;

  /// No description provided for @appSubTagline.
  ///
  /// In en, this message translates to:
  /// **'Professional CCTV Solutions Since 2016'**
  String get appSubTagline;

  /// No description provided for @exitConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Exit Secure Plus?'**
  String get exitConfirmTitle;

  /// No description provided for @exitConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to close the application?'**
  String get exitConfirmMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @myanmar.
  ///
  /// In en, this message translates to:
  /// **'Myanmar'**
  String get myanmar;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Smart CCTV Solutions'**
  String get onboardingTitle1;

  /// No description provided for @onboardingSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'Professional installation with crystal-clear HD & 4K monitoring for your home and business.'**
  String get onboardingSubtitle1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Remote Access, Anywhere'**
  String get onboardingTitle2;

  /// No description provided for @onboardingSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'View your cameras live from your phone — secure, encrypted, anytime, anywhere.'**
  String get onboardingSubtitle2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Trusted Since 2016'**
  String get onboardingTitle3;

  /// No description provided for @onboardingSubtitle3.
  ///
  /// In en, this message translates to:
  /// **'500+ successful installations. Secure Plus CCTV protects what matters most.'**
  String get onboardingSubtitle3;

  /// No description provided for @roleCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get roleCustomer;

  /// No description provided for @roleCustomerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Browse services, submit requests & view portfolio'**
  String get roleCustomerSubtitle;

  /// No description provided for @roleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin / Owner'**
  String get roleAdmin;

  /// No description provided for @roleAdminSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage projects, requests, tickets and quotes'**
  String get roleAdminSubtitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your access code to continue'**
  String get loginSubtitle;

  /// No description provided for @adminLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Admin Login'**
  String get adminLoginTitle;

  /// No description provided for @adminLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Authorized personnel only'**
  String get adminLoginSubtitle;

  /// No description provided for @usernameHint.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordHint;

  /// No description provided for @accessCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter Access Code (e.g. SP-1234)'**
  String get accessCodeHint;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @wrongCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid username or password'**
  String get wrongCredentials;

  /// No description provided for @invalidCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid access code. Please contact admin.'**
  String get invalidCode;

  /// No description provided for @securePlusServices.
  ///
  /// In en, this message translates to:
  /// **'Our Services'**
  String get securePlusServices;

  /// No description provided for @homeCctvPackage.
  ///
  /// In en, this message translates to:
  /// **'Home CCTV Package'**
  String get homeCctvPackage;

  /// No description provided for @homeCctvDesc.
  ///
  /// In en, this message translates to:
  /// **'4–8 camera setup ideal for homes & small offices. Mobile remote viewing included.'**
  String get homeCctvDesc;

  /// No description provided for @smePackage.
  ///
  /// In en, this message translates to:
  /// **'SME & Shop Package'**
  String get smePackage;

  /// No description provided for @smePackageDesc.
  ///
  /// In en, this message translates to:
  /// **'High-clarity cameras with DVR/NVR setup, network optimization and mobile viewing.'**
  String get smePackageDesc;

  /// No description provided for @enterprisePackage.
  ///
  /// In en, this message translates to:
  /// **'Enterprise & Factory'**
  String get enterprisePackage;

  /// No description provided for @enterprisePackageDesc.
  ///
  /// In en, this message translates to:
  /// **'Scalable IP camera solutions, centralized monitoring and long-term recording.'**
  String get enterprisePackageDesc;

  /// No description provided for @requestNewInstallation.
  ///
  /// In en, this message translates to:
  /// **'Request New Installation'**
  String get requestNewInstallation;

  /// No description provided for @createMaintenanceTicket.
  ///
  /// In en, this message translates to:
  /// **'Create Maintenance Ticket'**
  String get createMaintenanceTicket;

  /// No description provided for @viewCompletedSites.
  ///
  /// In en, this message translates to:
  /// **'View Completed Sites'**
  String get viewCompletedSites;

  /// No description provided for @contactAbout.
  ///
  /// In en, this message translates to:
  /// **'Contact / About Us'**
  String get contactAbout;

  /// No description provided for @ownerDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get ownerDashboard;

  /// No description provided for @totalRequests.
  ///
  /// In en, this message translates to:
  /// **'Total Requests'**
  String get totalRequests;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @scheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get scheduled;

  /// No description provided for @installing.
  ///
  /// In en, this message translates to:
  /// **'Installing'**
  String get installing;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @urgentTickets.
  ///
  /// In en, this message translates to:
  /// **'Urgent Tickets'**
  String get urgentTickets;

  /// No description provided for @navDash.
  ///
  /// In en, this message translates to:
  /// **'Dash'**
  String get navDash;

  /// No description provided for @navProjects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get navProjects;

  /// No description provided for @navRequests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get navRequests;

  /// No description provided for @navTickets.
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get navTickets;

  /// No description provided for @navQuotes.
  ///
  /// In en, this message translates to:
  /// **'Quotes'**
  String get navQuotes;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @ownerSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get ownerSettings;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @changeOwnerPin.
  ///
  /// In en, this message translates to:
  /// **'Change Admin PIN'**
  String get changeOwnerPin;

  /// No description provided for @lockOwner.
  ///
  /// In en, this message translates to:
  /// **'Lock & Logout'**
  String get lockOwner;

  /// No description provided for @businessInfoOptional.
  ///
  /// In en, this message translates to:
  /// **'Business Info'**
  String get businessInfoOptional;

  /// No description provided for @businessInfoHint.
  ///
  /// In en, this message translates to:
  /// **'Extend this screen with editable business profile, addresses and social links.'**
  String get businessInfoHint;

  /// No description provided for @currentPin.
  ///
  /// In en, this message translates to:
  /// **'Current PIN'**
  String get currentPin;

  /// No description provided for @newPin.
  ///
  /// In en, this message translates to:
  /// **'New PIN'**
  String get newPin;

  /// No description provided for @currentPinWrong.
  ///
  /// In en, this message translates to:
  /// **'Current PIN is incorrect'**
  String get currentPinWrong;

  /// No description provided for @pinUpdated.
  ///
  /// In en, this message translates to:
  /// **'PIN updated successfully'**
  String get pinUpdated;

  /// No description provided for @enterOwnerPin.
  ///
  /// In en, this message translates to:
  /// **'Enter Admin PIN'**
  String get enterOwnerPin;

  /// No description provided for @pinHint.
  ///
  /// In en, this message translates to:
  /// **'6-digit PIN'**
  String get pinHint;

  /// No description provided for @wrongPin.
  ///
  /// In en, this message translates to:
  /// **'Wrong PIN. Please try again.'**
  String get wrongPin;

  /// No description provided for @contactAndAbout.
  ///
  /// In en, this message translates to:
  /// **'Contact & About'**
  String get contactAndAbout;

  /// No description provided for @cctvInstallationService.
  ///
  /// In en, this message translates to:
  /// **'CCTV Installation & Service'**
  String get cctvInstallationService;

  /// No description provided for @since2016.
  ///
  /// In en, this message translates to:
  /// **'Since 2016'**
  String get since2016;

  /// No description provided for @contactChannels.
  ///
  /// In en, this message translates to:
  /// **'Contact Channels'**
  String get contactChannels;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// No description provided for @supportedBrands.
  ///
  /// In en, this message translates to:
  /// **'Supported Brands'**
  String get supportedBrands;

  /// No description provided for @routeNotFound.
  ///
  /// In en, this message translates to:
  /// **'Route not found'**
  String get routeNotFound;

  /// No description provided for @dashboardError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load dashboard. Check your connection.'**
  String get dashboardError;

  /// No description provided for @generateCode.
  ///
  /// In en, this message translates to:
  /// **'Generate Customer Code'**
  String get generateCode;

  /// No description provided for @generatedCodes.
  ///
  /// In en, this message translates to:
  /// **'Generated Codes'**
  String get generatedCodes;

  /// No description provided for @noCodesYet.
  ///
  /// In en, this message translates to:
  /// **'No codes generated yet'**
  String get noCodesYet;

  /// No description provided for @copyCode.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyCode;

  /// No description provided for @deleteCode.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteCode;

  /// No description provided for @codeCopied.
  ///
  /// In en, this message translates to:
  /// **'Code copied to clipboard'**
  String get codeCopied;

  /// No description provided for @aboutCompany.
  ///
  /// In en, this message translates to:
  /// **'About Secure Plus CCTV'**
  String get aboutCompany;

  /// No description provided for @aboutFounder.
  ///
  /// In en, this message translates to:
  /// **'Founded by Ko Phyo San Thu'**
  String get aboutFounder;

  /// No description provided for @whyChooseUs.
  ///
  /// In en, this message translates to:
  /// **'Why Customers Trust Us'**
  String get whyChooseUs;

  /// No description provided for @installationsCount.
  ///
  /// In en, this message translates to:
  /// **'500+ Successful Installations'**
  String get installationsCount;

  /// No description provided for @debug.
  ///
  /// In en, this message translates to:
  /// **'Debug Info'**
  String get debug;

  /// No description provided for @onboardingCompleted.
  ///
  /// In en, this message translates to:
  /// **'Onboarding completed'**
  String get onboardingCompleted;

  /// No description provided for @pinUnlocked.
  ///
  /// In en, this message translates to:
  /// **'PIN unlocked'**
  String get pinUnlocked;

  /// No description provided for @currentRoute.
  ///
  /// In en, this message translates to:
  /// **'Current route'**
  String get currentRoute;
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
      <String>['en', 'my'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'my':
      return AppLocalizationsMy();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
