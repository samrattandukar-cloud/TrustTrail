import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ne.dart';

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
    Locale('en'),
    Locale('ne'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'TrustTrail'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Evidence-based vehicle history'**
  String get tagline;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get commonSkip;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get commonRetry;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonAdd;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get commonShare;

  /// No description provided for @commonSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get commonSearch;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get commonLoading;

  /// No description provided for @evidenceAttached.
  ///
  /// In en, this message translates to:
  /// **'Evidence attached ({count})'**
  String evidenceAttached(int count);

  /// No description provided for @selfReported.
  ///
  /// In en, this message translates to:
  /// **'Self-reported'**
  String get selfReported;

  /// No description provided for @ownerRecorded.
  ///
  /// In en, this message translates to:
  /// **'Owner-recorded'**
  String get ownerRecorded;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @dueSoon.
  ///
  /// In en, this message translates to:
  /// **'Due soon'**
  String get dueSoon;

  /// No description provided for @completionMeter.
  ///
  /// In en, this message translates to:
  /// **'Completion meter'**
  String get completionMeter;

  /// No description provided for @notATrustScore.
  ///
  /// In en, this message translates to:
  /// **'Not a trust score — a count of documented sections.'**
  String get notATrustScore;

  /// No description provided for @demoBuild.
  ///
  /// In en, this message translates to:
  /// **'Demo build — data stays on this device.'**
  String get demoBuild;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @emptyGarageTitle.
  ///
  /// In en, this message translates to:
  /// **'Your garage is empty'**
  String get emptyGarageTitle;

  /// No description provided for @emptyGarageBody.
  ///
  /// In en, this message translates to:
  /// **'Add your vehicle to start building its trail.'**
  String get emptyGarageBody;

  /// No description provided for @addVehicle.
  ///
  /// In en, this message translates to:
  /// **'Add vehicle'**
  String get addVehicle;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add a photo'**
  String get addPhoto;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get changePhoto;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhoto;

  /// No description provided for @vehiclePhotoHint.
  ///
  /// In en, this message translates to:
  /// **'Optional — shown on your reports.'**
  String get vehiclePhotoHint;

  /// No description provided for @navGarage.
  ///
  /// In en, this message translates to:
  /// **'Garage'**
  String get navGarage;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get navReminders;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get navSaved;

  /// No description provided for @navBrowse.
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get navBrowse;

  /// No description provided for @lookupMissTitle.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find that report'**
  String get lookupMissTitle;

  /// No description provided for @lookupMissBody.
  ///
  /// In en, this message translates to:
  /// **'Tokens created on another device don\'t exist here. Ask the seller for the PDF.'**
  String get lookupMissBody;

  /// No description provided for @loginNoAccount.
  ///
  /// In en, this message translates to:
  /// **'No account found for that number. Create your account below.'**
  String get loginNoAccount;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @namasteUser.
  ///
  /// In en, this message translates to:
  /// **'Namaste, {name}'**
  String namasteUser(String name);

  /// No description provided for @yourGarage.
  ///
  /// In en, this message translates to:
  /// **'Your garage'**
  String get yourGarage;

  /// No description provided for @garageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Every entry here is owner-recorded.'**
  String get garageSubtitle;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get recentActivity;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @viewTimeline.
  ///
  /// In en, this message translates to:
  /// **'View timeline'**
  String get viewTimeline;

  /// No description provided for @addRecord.
  ///
  /// In en, this message translates to:
  /// **'Add record'**
  String get addRecord;

  /// No description provided for @shareReport.
  ///
  /// In en, this message translates to:
  /// **'Share report'**
  String get shareReport;

  /// No description provided for @generateReport.
  ///
  /// In en, this message translates to:
  /// **'Generate report'**
  String get generateReport;

  /// No description provided for @incompleteSections.
  ///
  /// In en, this message translates to:
  /// **'{count} of 10 sections need attention'**
  String incompleteSections(int count);

  /// No description provided for @missingSections.
  ///
  /// In en, this message translates to:
  /// **'Missing evidence'**
  String get missingSections;

  /// No description provided for @odometer.
  ///
  /// In en, this message translates to:
  /// **'Odometer'**
  String get odometer;

  /// No description provided for @odometerTrend.
  ///
  /// In en, this message translates to:
  /// **'Odometer trend'**
  String get odometerTrend;

  /// No description provided for @gapNote.
  ///
  /// In en, this message translates to:
  /// **'No records between {from} and {to} ({months} months).'**
  String gapNote(String from, String to, int months);

  /// No description provided for @noRecordsTitle.
  ///
  /// In en, this message translates to:
  /// **'No records yet'**
  String get noRecordsTitle;

  /// No description provided for @noRecordsBody.
  ///
  /// In en, this message translates to:
  /// **'Add the first service, insurance or tax entry.'**
  String get noRecordsBody;

  /// No description provided for @recordSaved.
  ///
  /// In en, this message translates to:
  /// **'Record saved'**
  String get recordSaved;

  /// No description provided for @vehicleAdded.
  ///
  /// In en, this message translates to:
  /// **'Vehicle added'**
  String get vehicleAdded;

  /// No description provided for @allSet.
  ///
  /// In en, this message translates to:
  /// **'You\'re all set'**
  String get allSet;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'A history buyers can read'**
  String get onboardingTitle1;

  /// No description provided for @onboardingBody1.
  ///
  /// In en, this message translates to:
  /// **'Service, insurance, tax and repairs — recorded as they happen, with photos of the paperwork.'**
  String get onboardingBody1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Honest by design'**
  String get onboardingTitle2;

  /// No description provided for @onboardingBody2.
  ///
  /// In en, this message translates to:
  /// **'No invented trust scores. You see what is documented, what is missing and what is self-reported.'**
  String get onboardingBody2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Share a dossier, not a story'**
  String get onboardingTitle3;

  /// No description provided for @onboardingBody3.
  ///
  /// In en, this message translates to:
  /// **'Generate a PDF or QR report that travels with the bike — even when the buyer is offline.'**
  String get onboardingBody3;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get chooseLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @nepali.
  ///
  /// In en, this message translates to:
  /// **'नेपाली'**
  String get nepali;

  /// No description provided for @chooseRole.
  ///
  /// In en, this message translates to:
  /// **'How will you use TrustTrail?'**
  String get chooseRole;

  /// No description provided for @ownerRole.
  ///
  /// In en, this message translates to:
  /// **'I own a vehicle'**
  String get ownerRole;

  /// No description provided for @ownerRoleBody.
  ///
  /// In en, this message translates to:
  /// **'Record services and share an evidence-backed history when you sell.'**
  String get ownerRoleBody;

  /// No description provided for @buyerRole.
  ///
  /// In en, this message translates to:
  /// **'I\'m checking a vehicle'**
  String get buyerRole;

  /// No description provided for @buyerRoleBody.
  ///
  /// In en, this message translates to:
  /// **'Look up a shared report by plate, QR or token.'**
  String get buyerRoleBody;

  /// No description provided for @continueDemo.
  ///
  /// In en, this message translates to:
  /// **'Use the demo account'**
  String get continueDemo;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get registerTitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginTitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get phoneNumber;

  /// No description provided for @emailOptional.
  ///
  /// In en, this message translates to:
  /// **'Email (optional)'**
  String get emailOptional;

  /// No description provided for @consent.
  ///
  /// In en, this message translates to:
  /// **'I understand this demo stores data only on this device.'**
  String get consent;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Continue with phone'**
  String get sendOtp;

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the demo code'**
  String get otpTitle;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'We sent a simulated code to {phone}. Any 6 digits work in this demo.'**
  String otpSentTo(String phone);

  /// No description provided for @demoOtpHint.
  ///
  /// In en, this message translates to:
  /// **'Demo OTP: 123456'**
  String get demoOtpHint;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordBody.
  ///
  /// In en, this message translates to:
  /// **'This demo has no online account. Sign in with your phone number, or create a new account with any 6-digit code.'**
  String get forgotPasswordBody;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @buyerSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Check a vehicle'**
  String get buyerSearchTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Plate, token or link'**
  String get searchHint;

  /// No description provided for @scanQr.
  ///
  /// In en, this message translates to:
  /// **'Scan QR'**
  String get scanQr;

  /// No description provided for @scanCameraError.
  ///
  /// In en, this message translates to:
  /// **'The camera could not start on this device.'**
  String get scanCameraError;

  /// No description provided for @scanHintBody.
  ///
  /// In en, this message translates to:
  /// **'Point at the seller\'s QR, or enter the code manually.'**
  String get scanHintBody;

  /// No description provided for @scanManualEntry.
  ///
  /// In en, this message translates to:
  /// **'Enter code manually'**
  String get scanManualEntry;

  /// No description provided for @scanPermissionNote.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is requested by the system. Manual entry always works.'**
  String get scanPermissionNote;

  /// No description provided for @scanTorch.
  ///
  /// In en, this message translates to:
  /// **'Torch'**
  String get scanTorch;

  /// No description provided for @odometerTrendSemantics.
  ///
  /// In en, this message translates to:
  /// **'Odometer trend, {minKm} to {maxKm}'**
  String odometerTrendSemantics(String minKm, String maxKm);

  /// No description provided for @searchButton.
  ///
  /// In en, this message translates to:
  /// **'Look up report'**
  String get searchButton;

  /// No description provided for @recentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get recentSearches;

  /// No description provided for @savedReports.
  ///
  /// In en, this message translates to:
  /// **'Saved reports'**
  String get savedReports;

  /// No description provided for @trySampleReport.
  ///
  /// In en, this message translates to:
  /// **'Try a sample report'**
  String get trySampleReport;

  /// No description provided for @saveReport.
  ///
  /// In en, this message translates to:
  /// **'Save report'**
  String get saveReport;

  /// No description provided for @removeSaved.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeSaved;

  /// No description provided for @compare.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get compare;

  /// No description provided for @noSavedTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing saved yet'**
  String get noSavedTitle;

  /// No description provided for @noSavedBody.
  ///
  /// In en, this message translates to:
  /// **'Save reports you want to compare later.'**
  String get noSavedBody;

  /// No description provided for @searchEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Search a plate or token'**
  String get searchEmptyTitle;

  /// No description provided for @searchEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Try BA 99 PA 4521 or TT-FZS-2026.'**
  String get searchEmptyBody;

  /// No description provided for @reportPrepareTitle.
  ///
  /// In en, this message translates to:
  /// **'Prepare report'**
  String get reportPrepareTitle;

  /// No description provided for @reportPrepareBody.
  ///
  /// In en, this message translates to:
  /// **'Choose what the buyer can see. The snapshot freezes the data at this moment.'**
  String get reportPrepareBody;

  /// No description provided for @includeCosts.
  ///
  /// In en, this message translates to:
  /// **'Include costs'**
  String get includeCosts;

  /// No description provided for @includeEvidence.
  ///
  /// In en, this message translates to:
  /// **'Include evidence thumbnails'**
  String get includeEvidence;

  /// No description provided for @includeCostsBody.
  ///
  /// In en, this message translates to:
  /// **'Amounts you recorded in NPR.'**
  String get includeCostsBody;

  /// No description provided for @includeEvidenceBody.
  ///
  /// In en, this message translates to:
  /// **'The buyer sees the receipts you attached.'**
  String get includeEvidenceBody;

  /// No description provided for @reportPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Report preview'**
  String get reportPreviewTitle;

  /// No description provided for @reportShareTitle.
  ///
  /// In en, this message translates to:
  /// **'Share report'**
  String get reportShareTitle;

  /// No description provided for @copyCode.
  ///
  /// In en, this message translates to:
  /// **'Copy code'**
  String get copyCode;

  /// No description provided for @copyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get copyLink;

  /// No description provided for @downloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Share PDF'**
  String get downloadPdf;

  /// No description provided for @shareText.
  ///
  /// In en, this message translates to:
  /// **'Share summary'**
  String get shareText;

  /// No description provided for @reportGenerating.
  ///
  /// In en, this message translates to:
  /// **'Preparing your report'**
  String get reportGenerating;

  /// No description provided for @demoTokenNote.
  ///
  /// In en, this message translates to:
  /// **'This report lives on this device only.'**
  String get demoTokenNote;

  /// No description provided for @oneDeviceNote.
  ///
  /// In en, this message translates to:
  /// **'Reports resolve against the local database. Ask the seller for the PDF if you\'re on another phone.'**
  String get oneDeviceNote;

  /// No description provided for @completionNotScore.
  ///
  /// In en, this message translates to:
  /// **'Completion meter — not a trust score.'**
  String get completionNotScore;

  /// No description provided for @categoryService.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get categoryService;

  /// No description provided for @categoryInsurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get categoryInsurance;

  /// No description provided for @categoryTax.
  ///
  /// In en, this message translates to:
  /// **'Road tax'**
  String get categoryTax;

  /// No description provided for @categoryRepair.
  ///
  /// In en, this message translates to:
  /// **'Repair'**
  String get categoryRepair;

  /// No description provided for @categoryOwnership.
  ///
  /// In en, this message translates to:
  /// **'Ownership'**
  String get categoryOwnership;

  /// No description provided for @categoryInspection.
  ///
  /// In en, this message translates to:
  /// **'Inspection'**
  String get categoryInspection;

  /// No description provided for @categoryPollution.
  ///
  /// In en, this message translates to:
  /// **'Pollution'**
  String get categoryPollution;

  /// No description provided for @categoryFuel.
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get categoryFuel;

  /// No description provided for @sourceSelfReported.
  ///
  /// In en, this message translates to:
  /// **'Self-reported'**
  String get sourceSelfReported;

  /// No description provided for @evidenceNone.
  ///
  /// In en, this message translates to:
  /// **'No evidence attached'**
  String get evidenceNone;

  /// No description provided for @evidenceAttachedShort.
  ///
  /// In en, this message translates to:
  /// **'{count} attached'**
  String evidenceAttachedShort(int count);

  /// No description provided for @remindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get remindersTitle;

  /// No description provided for @overdueGroup.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdueGroup;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get thisMonth;

  /// No description provided for @laterGroup.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get laterGroup;

  /// No description provided for @markDone.
  ///
  /// In en, this message translates to:
  /// **'Mark done'**
  String get markDone;

  /// No description provided for @snooze30.
  ///
  /// In en, this message translates to:
  /// **'Snooze 30 days'**
  String get snooze30;

  /// No description provided for @noReminders.
  ///
  /// In en, this message translates to:
  /// **'No reminders'**
  String get noReminders;

  /// No description provided for @noRemindersBody.
  ///
  /// In en, this message translates to:
  /// **'Add insurance, tax or service reminders from a vehicle.'**
  String get noRemindersBody;

  /// No description provided for @addReminder.
  ///
  /// In en, this message translates to:
  /// **'Add reminder'**
  String get addReminder;

  /// No description provided for @reminderSummary.
  ///
  /// In en, this message translates to:
  /// **'{reminders, plural, =0{No active reminders} =1{1 active reminder} other{{reminders} active reminders}} · {vehicles, plural, =0{no vehicles} =1{1 vehicle} other{{vehicles} vehicles}}'**
  String reminderSummary(int reminders, int vehicles);

  /// No description provided for @overdueReminderBanner.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 reminder} other{{count} reminders}} · {status}'**
  String overdueReminderBanner(int count, String status);

  /// No description provided for @recordEvidenceSummary.
  ///
  /// In en, this message translates to:
  /// **'{records, plural, =1{1 record} other{{records} records}} · {evidence, plural, =0{no evidence} =1{1 evidence file} other{{evidence} evidence files}}'**
  String recordEvidenceSummary(int records, int evidence);

  /// No description provided for @recordsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No records} =1{1 record} other{{count} records}}'**
  String recordsCount(int count);

  /// No description provided for @readingsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No readings} =1{1 reading} other{{count} readings}}'**
  String readingsCount(int count);

  /// No description provided for @acrossReadings.
  ///
  /// In en, this message translates to:
  /// **'across {count, plural, =1{1 reading} other{{count} readings}}'**
  String acrossReadings(int count);

  /// No description provided for @odometerAverageSummary.
  ///
  /// In en, this message translates to:
  /// **'{km} km/month average across {count, plural, =1{1 reading} other{{count} readings}}.'**
  String odometerAverageSummary(String km, int count);

  /// No description provided for @odometerAverage.
  ///
  /// In en, this message translates to:
  /// **'{km} km/month average'**
  String odometerAverage(String km);

  /// No description provided for @responsesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No responses yet} =1{1 response} other{{count} responses}}'**
  String responsesCount(int count);

  /// No description provided for @savedOn.
  ///
  /// In en, this message translates to:
  /// **'Saved {date}'**
  String savedOn(String date);

  /// No description provided for @gapNoteSentence.
  ///
  /// In en, this message translates to:
  /// **'No records between {from} and {to} ({months} months).'**
  String gapNoteSentence(String from, String to, String months);

  /// No description provided for @odometerDecreaseSentence.
  ///
  /// In en, this message translates to:
  /// **'Odometer decreased from {fromKm} km to {toKm} km between {from} and {to}.'**
  String odometerDecreaseSentence(
    String fromKm,
    String toKm,
    String from,
    String to,
  );

  /// No description provided for @highUsageSentence.
  ///
  /// In en, this message translates to:
  /// **'Implied usage looks high between {from} and {to}. Check the readings.'**
  String highUsageSentence(String from, String to);

  /// No description provided for @flagDecreaseNote.
  ///
  /// In en, this message translates to:
  /// **'Odometer decreased from {fromKm} km to {toKm} km. Recorded as-is — check the documents.'**
  String flagDecreaseNote(String fromKm, String toKm);

  /// No description provided for @flagHighUsageNote.
  ///
  /// In en, this message translates to:
  /// **'Implied usage of {rate} km/month between {from} and {to}. Check the readings.'**
  String flagHighUsageNote(String rate, String from, String to);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Help improve TrustTrail'**
  String get feedback;

  /// No description provided for @feedbackBody.
  ///
  /// In en, this message translates to:
  /// **'A 10-question usability survey, stored on this device.'**
  String get feedbackBody;

  /// No description provided for @demoData.
  ///
  /// In en, this message translates to:
  /// **'Demo data'**
  String get demoData;

  /// No description provided for @resetDemo.
  ///
  /// In en, this message translates to:
  /// **'Reset demo data'**
  String get resetDemo;

  /// No description provided for @resetDemoBody.
  ///
  /// In en, this message translates to:
  /// **'Clears local records and restores the three demo reports.'**
  String get resetDemoBody;

  /// No description provided for @resetDone.
  ///
  /// In en, this message translates to:
  /// **'Demo data restored'**
  String get resetDone;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About TrustTrail'**
  String get aboutTitle;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0 (demo)'**
  String get version;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @switchRole.
  ///
  /// In en, this message translates to:
  /// **'Switch role'**
  String get switchRole;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Your numbers'**
  String get stats;

  /// No description provided for @yourActivity.
  ///
  /// In en, this message translates to:
  /// **'Your activity'**
  String get yourActivity;

  /// No description provided for @statVehicles.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get statVehicles;

  /// No description provided for @statRecords.
  ///
  /// In en, this message translates to:
  /// **'Records'**
  String get statRecords;

  /// No description provided for @statReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get statReports;

  /// No description provided for @susTitle.
  ///
  /// In en, this message translates to:
  /// **'TrustTrail usability survey'**
  String get susTitle;

  /// No description provided for @susIntro.
  ///
  /// In en, this message translates to:
  /// **'Ten statements, from 1 (strongly disagree) to 5 (strongly agree).'**
  String get susIntro;

  /// No description provided for @susSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit survey'**
  String get susSubmit;

  /// No description provided for @susScore.
  ///
  /// In en, this message translates to:
  /// **'Your SUS score'**
  String get susScore;

  /// No description provided for @susComment.
  ///
  /// In en, this message translates to:
  /// **'Anything confusing? (optional)'**
  String get susComment;

  /// No description provided for @susParticipant.
  ///
  /// In en, this message translates to:
  /// **'Participant code'**
  String get susParticipant;

  /// No description provided for @susThanks.
  ///
  /// In en, this message translates to:
  /// **'Thank you — this helps the evaluation.'**
  String get susThanks;

  /// No description provided for @susExport.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get susExport;

  /// No description provided for @susScaleLow.
  ///
  /// In en, this message translates to:
  /// **'1 · disagree'**
  String get susScaleLow;

  /// No description provided for @susScaleHigh.
  ///
  /// In en, this message translates to:
  /// **'5 · agree'**
  String get susScaleHigh;

  /// No description provided for @susCsvNote.
  ///
  /// In en, this message translates to:
  /// **'CSV includes participant code, role, score and comments. Stored only on this device.'**
  String get susCsvNote;

  /// No description provided for @susFormulaNote.
  ///
  /// In en, this message translates to:
  /// **'SUS: odd items score (x − 1), even items score (5 − x); sum × 2.5.'**
  String get susFormulaNote;

  /// No description provided for @susExportShare.
  ///
  /// In en, this message translates to:
  /// **'TrustTrail SUS responses ({count})'**
  String susExportShare(int count);

  /// No description provided for @evidenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Evidence'**
  String get evidenceTitle;

  /// No description provided for @attachEvidence.
  ///
  /// In en, this message translates to:
  /// **'Attach evidence'**
  String get attachEvidence;

  /// No description provided for @evidenceFromCamera.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get evidenceFromCamera;

  /// No description provided for @evidenceFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get evidenceFromGallery;

  /// No description provided for @evidenceFromFile.
  ///
  /// In en, this message translates to:
  /// **'Choose a PDF'**
  String get evidenceFromFile;

  /// No description provided for @evidenceEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No evidence yet'**
  String get evidenceEmptyTitle;

  /// No description provided for @evidenceEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add a photo of the receipt or document.'**
  String get evidenceEmptyBody;

  /// No description provided for @evidenceViewer.
  ///
  /// In en, this message translates to:
  /// **'Evidence viewer'**
  String get evidenceViewer;

  /// No description provided for @uploadFailed.
  ///
  /// In en, this message translates to:
  /// **'That file could not be added.'**
  String get uploadFailed;

  /// No description provided for @deleteRecord.
  ///
  /// In en, this message translates to:
  /// **'Delete record'**
  String get deleteRecord;

  /// No description provided for @deleteRecordBody.
  ///
  /// In en, this message translates to:
  /// **'This also removes its evidence. This cannot be undone.'**
  String get deleteRecordBody;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid Nepali mobile number'**
  String get invalidPhone;

  /// No description provided for @invalidPlate.
  ///
  /// In en, this message translates to:
  /// **'Use a plate like BA 2 PA 1234'**
  String get invalidPlate;

  /// No description provided for @invalidYear.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid year'**
  String get invalidYear;

  /// No description provided for @invalidOdometer.
  ///
  /// In en, this message translates to:
  /// **'Enter the odometer reading'**
  String get invalidOdometer;

  /// No description provided for @invalidCost.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount in NPR'**
  String get invalidCost;

  /// No description provided for @recordDetails.
  ///
  /// In en, this message translates to:
  /// **'Record details'**
  String get recordDetails;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @recordTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get recordTitle;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @workshop.
  ///
  /// In en, this message translates to:
  /// **'Workshop'**
  String get workshop;

  /// No description provided for @cost.
  ///
  /// In en, this message translates to:
  /// **'Cost (NPR)'**
  String get cost;

  /// No description provided for @documentNo.
  ///
  /// In en, this message translates to:
  /// **'Document number'**
  String get documentNo;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// No description provided for @sourceOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner-recorded'**
  String get sourceOwner;

  /// No description provided for @sourceWorkshop.
  ///
  /// In en, this message translates to:
  /// **'Workshop receipt'**
  String get sourceWorkshop;

  /// No description provided for @sourceOfficial.
  ///
  /// In en, this message translates to:
  /// **'Official document'**
  String get sourceOfficial;

  /// No description provided for @odometerKm.
  ///
  /// In en, this message translates to:
  /// **'Odometer (km)'**
  String get odometerKm;

  /// No description provided for @saveRecord.
  ///
  /// In en, this message translates to:
  /// **'Save record'**
  String get saveRecord;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @vehicleBasics.
  ///
  /// In en, this message translates to:
  /// **'Vehicle basics'**
  String get vehicleBasics;

  /// No description provided for @registration.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get registration;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @make.
  ///
  /// In en, this message translates to:
  /// **'Make'**
  String get make;

  /// No description provided for @model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @plateRoman.
  ///
  /// In en, this message translates to:
  /// **'Registration (Roman)'**
  String get plateRoman;

  /// No description provided for @plateDevanagari.
  ///
  /// In en, this message translates to:
  /// **'Registration (Devanagari)'**
  String get plateDevanagari;

  /// No description provided for @province.
  ///
  /// In en, this message translates to:
  /// **'Province'**
  String get province;

  /// No description provided for @fuel.
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get fuel;

  /// No description provided for @transmission.
  ///
  /// In en, this message translates to:
  /// **'Transmission'**
  String get transmission;

  /// No description provided for @colour.
  ///
  /// In en, this message translates to:
  /// **'Colour'**
  String get colour;

  /// No description provided for @chassis.
  ///
  /// In en, this message translates to:
  /// **'Chassis number'**
  String get chassis;

  /// No description provided for @engineNo.
  ///
  /// In en, this message translates to:
  /// **'Engine number'**
  String get engineNo;

  /// No description provided for @initialOdometer.
  ///
  /// In en, this message translates to:
  /// **'Current odometer'**
  String get initialOdometer;

  /// No description provided for @saveVehicle.
  ///
  /// In en, this message translates to:
  /// **'Save vehicle'**
  String get saveVehicle;

  /// No description provided for @stepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String stepOf(int current, int total);

  /// No description provided for @sus1.
  ///
  /// In en, this message translates to:
  /// **'I think that I would like to use TrustTrail frequently.'**
  String get sus1;

  /// No description provided for @sus2.
  ///
  /// In en, this message translates to:
  /// **'I found TrustTrail unnecessarily complex.'**
  String get sus2;

  /// No description provided for @sus3.
  ///
  /// In en, this message translates to:
  /// **'I thought TrustTrail was easy to use.'**
  String get sus3;

  /// No description provided for @sus4.
  ///
  /// In en, this message translates to:
  /// **'I think that I would need the support of a technical person to be able to use TrustTrail.'**
  String get sus4;

  /// No description provided for @sus5.
  ///
  /// In en, this message translates to:
  /// **'I found the various functions in TrustTrail were well integrated.'**
  String get sus5;

  /// No description provided for @sus6.
  ///
  /// In en, this message translates to:
  /// **'I thought there was too much inconsistency in TrustTrail.'**
  String get sus6;

  /// No description provided for @sus7.
  ///
  /// In en, this message translates to:
  /// **'I would imagine that most people would learn to use TrustTrail very quickly.'**
  String get sus7;

  /// No description provided for @sus8.
  ///
  /// In en, this message translates to:
  /// **'I found TrustTrail very awkward to use.'**
  String get sus8;

  /// No description provided for @sus9.
  ///
  /// In en, this message translates to:
  /// **'I felt very confident using TrustTrail.'**
  String get sus9;

  /// No description provided for @sus10.
  ///
  /// In en, this message translates to:
  /// **'I needed to learn a lot of things before I could get going with TrustTrail.'**
  String get sus10;

  /// No description provided for @susAverage.
  ///
  /// In en, this message translates to:
  /// **'Average score'**
  String get susAverage;

  /// No description provided for @susResponses.
  ///
  /// In en, this message translates to:
  /// **'Responses on this device'**
  String get susResponses;

  /// No description provided for @susExportDone.
  ///
  /// In en, this message translates to:
  /// **'CSV ready to share'**
  String get susExportDone;

  /// No description provided for @aboutIntro.
  ///
  /// In en, this message translates to:
  /// **'TrustTrail is a student prototype for evidence-based vehicle history in Nepal\'s second-hand market.'**
  String get aboutIntro;

  /// No description provided for @aboutPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get aboutPrivacyTitle;

  /// No description provided for @aboutPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'All vehicles, records and evidence stay in this app\'s private storage on this phone. Nothing is uploaded or shared unless you choose to share a report.'**
  String get aboutPrivacyBody;

  /// No description provided for @aboutLimitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Honest limitations'**
  String get aboutLimitsTitle;

  /// No description provided for @aboutLimitsBody.
  ///
  /// In en, this message translates to:
  /// **'Records are entered by owners and are not checked with the Department of Transport or any insurer. A completion meter shows how much of the checklist is covered — it is not a trust score. QR codes and links only resolve on the device that created the report.'**
  String get aboutLimitsBody;

  /// No description provided for @aboutDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Demo build'**
  String get aboutDataTitle;

  /// No description provided for @aboutDataBody.
  ///
  /// In en, this message translates to:
  /// **'The owner, vehicles, receipts and shared reports are fictitious sample data. The SMS code is simulated: any six digits work.'**
  String get aboutDataBody;

  /// No description provided for @storageUsage.
  ///
  /// In en, this message translates to:
  /// **'Evidence storage'**
  String get storageUsage;

  /// No description provided for @storageFiles.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No files} =1{1 file} other{{count} files}}'**
  String storageFiles(int count);

  /// No description provided for @demoDataNote.
  ///
  /// In en, this message translates to:
  /// **'Demo vehicles, receipts and shared reports are regenerated deterministically. Photos live in the app bundle.'**
  String get demoDataNote;

  /// No description provided for @modeOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner mode'**
  String get modeOwner;

  /// No description provided for @modeBuyer.
  ///
  /// In en, this message translates to:
  /// **'Buyer mode'**
  String get modeBuyer;

  /// No description provided for @selectVehicle.
  ///
  /// In en, this message translates to:
  /// **'Choose a vehicle'**
  String get selectVehicle;

  /// No description provided for @orDivider.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get orDivider;

  /// No description provided for @errorReportOpen.
  ///
  /// In en, this message translates to:
  /// **'The report could not be opened.'**
  String get errorReportOpen;

  /// No description provided for @errorSavedReports.
  ///
  /// In en, this message translates to:
  /// **'Saved reports could not be read.'**
  String get errorSavedReports;

  /// No description provided for @errorDatabase.
  ///
  /// In en, this message translates to:
  /// **'The local database could not be read.'**
  String get errorDatabase;

  /// No description provided for @errorRecordLoad.
  ///
  /// In en, this message translates to:
  /// **'The record could not be loaded.'**
  String get errorRecordLoad;

  /// No description provided for @errorPrepareVehicle.
  ///
  /// In en, this message translates to:
  /// **'The vehicle could not be prepared.'**
  String get errorPrepareVehicle;

  /// No description provided for @errorVehicleLoad.
  ///
  /// In en, this message translates to:
  /// **'This vehicle could not be loaded.'**
  String get errorVehicleLoad;

  /// No description provided for @errorReportLoad.
  ///
  /// In en, this message translates to:
  /// **'The report could not be loaded.'**
  String get errorReportLoad;

  /// No description provided for @errorShareSheet.
  ///
  /// In en, this message translates to:
  /// **'The share sheet could not be loaded.'**
  String get errorShareSheet;

  /// No description provided for @errorSessionRestore.
  ///
  /// In en, this message translates to:
  /// **'The local session could not be restored.'**
  String get errorSessionRestore;

  /// No description provided for @demoTokensTitle.
  ///
  /// In en, this message translates to:
  /// **'Demo tokens'**
  String get demoTokensTitle;

  /// No description provided for @demoTokensBody.
  ///
  /// In en, this message translates to:
  /// **'Every fresh install ships with three frozen reports. Search a plate or use one of these tokens:'**
  String get demoTokensBody;

  /// No description provided for @tryDemoToken.
  ///
  /// In en, this message translates to:
  /// **'Try a demo token:'**
  String get tryDemoToken;

  /// No description provided for @generatedOn.
  ///
  /// In en, this message translates to:
  /// **'Generated {date}'**
  String generatedOn(String date);

  /// No description provided for @reminderOverdueBy.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Overdue by 1 day} other{Overdue by {count} days}}'**
  String reminderOverdueBy(int count);

  /// No description provided for @reminderDueToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get reminderDueToday;

  /// No description provided for @reminderDueIn.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Due in 1 day} other{Due in {count} days}}'**
  String reminderDueIn(int count);

  /// No description provided for @reminderKmToTarget.
  ///
  /// In en, this message translates to:
  /// **'{km} km to target'**
  String reminderKmToTarget(String km);

  /// No description provided for @reminderServiceDue.
  ///
  /// In en, this message translates to:
  /// **'Service due'**
  String get reminderServiceDue;

  /// No description provided for @reminderNewTitle.
  ///
  /// In en, this message translates to:
  /// **'Insurance renewal'**
  String get reminderNewTitle;

  /// No description provided for @allSectionsPresent.
  ///
  /// In en, this message translates to:
  /// **'All ten documented sections are present.'**
  String get allSectionsPresent;

  /// No description provided for @recordedTimeline.
  ///
  /// In en, this message translates to:
  /// **'Recorded timeline'**
  String get recordedTimeline;

  /// No description provided for @noSharedRecords.
  ///
  /// In en, this message translates to:
  /// **'No records were shared with this report.'**
  String get noSharedRecords;

  /// No description provided for @missingListLabel.
  ///
  /// In en, this message translates to:
  /// **'Missing: {list}.'**
  String missingListLabel(String list);

  /// No description provided for @genStepSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Freezing the vehicle snapshot'**
  String get genStepSnapshot;

  /// No description provided for @genStepSections.
  ///
  /// In en, this message translates to:
  /// **'Counting completeness sections'**
  String get genStepSections;

  /// No description provided for @genStepToken.
  ///
  /// In en, this message translates to:
  /// **'Building the dossier token'**
  String get genStepToken;

  /// No description provided for @genStepReady.
  ///
  /// In en, this message translates to:
  /// **'Ready to share'**
  String get genStepReady;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @devanagariHelper.
  ///
  /// In en, this message translates to:
  /// **'Shown in the Nepali report and plate chip.'**
  String get devanagariHelper;

  /// No description provided for @chassisHint.
  ///
  /// In en, this message translates to:
  /// **'MBLJAW1234 (masked in reports)'**
  String get chassisHint;

  /// No description provided for @addVehicleEvidenceNote.
  ///
  /// In en, this message translates to:
  /// **'You can attach the bluebook scan and other evidence from any record later. The completion meter updates automatically.'**
  String get addVehicleEvidenceNote;

  /// No description provided for @sectionBluebook.
  ///
  /// In en, this message translates to:
  /// **'Bluebook scan'**
  String get sectionBluebook;

  /// No description provided for @sectionOwnership.
  ///
  /// In en, this message translates to:
  /// **'Ownership record'**
  String get sectionOwnership;

  /// No description provided for @sectionServices.
  ///
  /// In en, this message translates to:
  /// **'Three service records'**
  String get sectionServices;

  /// No description provided for @sectionOdometer.
  ///
  /// In en, this message translates to:
  /// **'Three odometer readings'**
  String get sectionOdometer;

  /// No description provided for @sectionPhotos.
  ///
  /// In en, this message translates to:
  /// **'Vehicle photos'**
  String get sectionPhotos;

  /// No description provided for @chartNeedsReadings.
  ///
  /// In en, this message translates to:
  /// **'Add at least two odometer readings to see a trend.'**
  String get chartNeedsReadings;

  /// No description provided for @provinceKoshi.
  ///
  /// In en, this message translates to:
  /// **'Koshi'**
  String get provinceKoshi;

  /// No description provided for @provinceMadhesh.
  ///
  /// In en, this message translates to:
  /// **'Madhesh'**
  String get provinceMadhesh;

  /// No description provided for @provinceBagmati.
  ///
  /// In en, this message translates to:
  /// **'Bagmati'**
  String get provinceBagmati;

  /// No description provided for @provinceGandaki.
  ///
  /// In en, this message translates to:
  /// **'Gandaki'**
  String get provinceGandaki;

  /// No description provided for @provinceLumbini.
  ///
  /// In en, this message translates to:
  /// **'Lumbini'**
  String get provinceLumbini;

  /// No description provided for @provinceKarnali.
  ///
  /// In en, this message translates to:
  /// **'Karnali'**
  String get provinceKarnali;

  /// No description provided for @provinceSudurpashchim.
  ///
  /// In en, this message translates to:
  /// **'Sudurpashchim'**
  String get provinceSudurpashchim;

  /// No description provided for @fuelPetrol.
  ///
  /// In en, this message translates to:
  /// **'Petrol'**
  String get fuelPetrol;

  /// No description provided for @fuelDiesel.
  ///
  /// In en, this message translates to:
  /// **'Diesel'**
  String get fuelDiesel;

  /// No description provided for @fuelElectric.
  ///
  /// In en, this message translates to:
  /// **'Electric'**
  String get fuelElectric;

  /// No description provided for @fuelHybrid.
  ///
  /// In en, this message translates to:
  /// **'Hybrid'**
  String get fuelHybrid;

  /// No description provided for @fuelCng.
  ///
  /// In en, this message translates to:
  /// **'CNG'**
  String get fuelCng;

  /// No description provided for @transmissionManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get transmissionManual;

  /// No description provided for @transmissionAutomatic.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get transmissionAutomatic;

  /// No description provided for @transmissionAmt.
  ///
  /// In en, this message translates to:
  /// **'AMT'**
  String get transmissionAmt;

  /// No description provided for @transmissionCvt.
  ///
  /// In en, this message translates to:
  /// **'CVT'**
  String get transmissionCvt;

  /// No description provided for @colourHint.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get colourHint;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Evidence, not promises.'**
  String get splashTagline;

  /// No description provided for @splashDemoNote.
  ///
  /// In en, this message translates to:
  /// **'Demo build · data stays on this device'**
  String get splashDemoNote;

  /// Percentage of completion-meter sections that have data
  ///
  /// In en, this message translates to:
  /// **'{percent}% documented'**
  String documentedPercent(int percent);

  /// No description provided for @snapshotFreezeNote.
  ///
  /// In en, this message translates to:
  /// **'The snapshot freezes today\'s data. Later edits do not change this report.'**
  String get snapshotFreezeNote;

  /// No description provided for @demoOtpNote.
  ///
  /// In en, this message translates to:
  /// **'Demo OTP: 123456 · any 6 digits are accepted.'**
  String get demoOtpNote;

  /// No description provided for @otpCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'6-digit code'**
  String get otpCodeLabel;

  /// No description provided for @remindersIntro.
  ///
  /// In en, this message translates to:
  /// **'Owner-set dates and odometer targets. No official penalties are invented.'**
  String get remindersIntro;

  /// No description provided for @noLongGapsNote.
  ///
  /// In en, this message translates to:
  /// **'There are no gaps longer than 120 days between records.'**
  String get noLongGapsNote;

  /// No description provided for @ownerRecordedLocalNote.
  ///
  /// In en, this message translates to:
  /// **'Owner-recorded history. Evidence is stored on this device and is not registry-verified.'**
  String get ownerRecordedLocalNote;

  /// No description provided for @dossierDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Owner-recorded history. Evidence is not registry-verified. A gap means no record was shared, not that nothing happened.'**
  String get dossierDisclaimer;

  /// No description provided for @compareTitle.
  ///
  /// In en, this message translates to:
  /// **'Compare reports'**
  String get compareTitle;

  /// No description provided for @compareSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Two saved snapshots, side by side.'**
  String get compareSubtitle;

  /// No description provided for @savedReportsHint.
  ///
  /// In en, this message translates to:
  /// **'Open a report, or select two to compare.'**
  String get savedReportsHint;

  /// No description provided for @compareSelectTwo.
  ///
  /// In en, this message translates to:
  /// **'Select two saved reports to compare.'**
  String get compareSelectTwo;

  /// No description provided for @compareNeutralNote.
  ///
  /// In en, this message translates to:
  /// **'A factual side-by-side view. Completeness is a checklist count, not a ranking.'**
  String get compareNeutralNote;

  /// No description provided for @metricCompletion.
  ///
  /// In en, this message translates to:
  /// **'Completion'**
  String get metricCompletion;

  /// No description provided for @metricRecords.
  ///
  /// In en, this message translates to:
  /// **'Records'**
  String get metricRecords;

  /// No description provided for @metricEvidence.
  ///
  /// In en, this message translates to:
  /// **'Evidence files'**
  String get metricEvidence;

  /// No description provided for @metricLatestKm.
  ///
  /// In en, this message translates to:
  /// **'Latest odometer'**
  String get metricLatestKm;

  /// No description provided for @metricAvgKmMonth.
  ///
  /// In en, this message translates to:
  /// **'Avg km/month'**
  String get metricAvgKmMonth;

  /// No description provided for @metricOdometerFlags.
  ///
  /// In en, this message translates to:
  /// **'Odometer flags'**
  String get metricOdometerFlags;

  /// No description provided for @metricGaps.
  ///
  /// In en, this message translates to:
  /// **'Gaps'**
  String get metricGaps;

  /// No description provided for @metricFirstRecord.
  ///
  /// In en, this message translates to:
  /// **'First record'**
  String get metricFirstRecord;

  /// No description provided for @browseTitle.
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get browseTitle;

  /// No description provided for @browseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Second-hand vehicles with an owner-recorded history. Open an ad to read the report.'**
  String get browseSubtitle;

  /// No description provided for @demoListingsNote.
  ///
  /// In en, this message translates to:
  /// **'Demo listings — sellers, prices and areas are fictitious. Each opens a frozen snapshot from this device.'**
  String get demoListingsNote;

  /// No description provided for @noListingsTitle.
  ///
  /// In en, this message translates to:
  /// **'No listings available'**
  String get noListingsTitle;

  /// No description provided for @noListingsBody.
  ///
  /// In en, this message translates to:
  /// **'Reset the demo data in Settings to restore the sample listings.'**
  String get noListingsBody;

  /// No description provided for @listedAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Listed 1 day ago} other{Listed {count} days ago}}'**
  String listedAgo(int count);

  /// No description provided for @demoListingBadge.
  ///
  /// In en, this message translates to:
  /// **'Demo'**
  String get demoListingBadge;

  /// No description provided for @vehicleHistory.
  ///
  /// In en, this message translates to:
  /// **'Vehicle history'**
  String get vehicleHistory;

  /// No description provided for @historyAtAGlance.
  ///
  /// In en, this message translates to:
  /// **'History at a glance'**
  String get historyAtAGlance;

  /// No description provided for @glanceChecklist.
  ///
  /// In en, this message translates to:
  /// **'Checklist'**
  String get glanceChecklist;

  /// No description provided for @glanceRecords.
  ///
  /// In en, this message translates to:
  /// **'Records'**
  String get glanceRecords;

  /// No description provided for @glanceEvidence.
  ///
  /// In en, this message translates to:
  /// **'Evidence'**
  String get glanceEvidence;

  /// No description provided for @glanceOdometer.
  ///
  /// In en, this message translates to:
  /// **'Odometer checks'**
  String get glanceOdometer;

  /// No description provided for @glanceGaps.
  ///
  /// In en, this message translates to:
  /// **'Record gaps'**
  String get glanceGaps;

  /// No description provided for @glanceOwnership.
  ///
  /// In en, this message translates to:
  /// **'Ownership entries'**
  String get glanceOwnership;

  /// No description provided for @glanceNoIssues.
  ///
  /// In en, this message translates to:
  /// **'No issues found'**
  String get glanceNoIssues;

  /// No description provided for @glanceNoGaps.
  ///
  /// In en, this message translates to:
  /// **'No long gaps'**
  String get glanceNoGaps;

  /// No description provided for @glanceFlags.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 reading flagged} other{{count} readings flagged}}'**
  String glanceFlags(int count);

  /// No description provided for @glanceGapsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 gap over 120 days} other{{count} gaps over 120 days}}'**
  String glanceGapsCount(int count);

  /// No description provided for @glanceOwnershipSub.
  ///
  /// In en, this message translates to:
  /// **'As recorded by the owner'**
  String get glanceOwnershipSub;

  /// No description provided for @glanceComputedNote.
  ///
  /// In en, this message translates to:
  /// **'Counts come from this frozen snapshot. A missing entry means no record was shared.'**
  String get glanceComputedNote;

  /// No description provided for @reportHeroListedBy.
  ///
  /// In en, this message translates to:
  /// **'Listed by {name}'**
  String reportHeroListedBy(String name);

  /// No description provided for @documentedOf.
  ///
  /// In en, this message translates to:
  /// **'{filled} of {total} documented'**
  String documentedOf(int filled, int total);

  /// No description provided for @integrityTitle.
  ///
  /// In en, this message translates to:
  /// **'Integrity trail'**
  String get integrityTitle;

  /// No description provided for @integrityIntact.
  ///
  /// In en, this message translates to:
  /// **'Tamper-evident seal intact · {count} linked entries · SHA-256 {fingerprint}'**
  String integrityIntact(int count, String fingerprint);

  /// No description provided for @integrityMismatch.
  ///
  /// In en, this message translates to:
  /// **'Snapshot integrity mismatch — records may have been altered after export.'**
  String get integrityMismatch;

  /// No description provided for @integrityNote.
  ///
  /// In en, this message translates to:
  /// **'SHA-256 hash chain over owner-recorded entries. Checks snapshot tampering only — not registry-verified.'**
  String get integrityNote;

  /// No description provided for @backupTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup & restore'**
  String get backupTitle;

  /// No description provided for @backupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Export or restore your offline garage file'**
  String get backupSubtitle;

  /// No description provided for @backupIntro.
  ///
  /// In en, this message translates to:
  /// **'Before switching phones or resetting demo data, export your local database as JSON with a SHA-256 checksum. Keep a separate copy of evidence files.'**
  String get backupIntro;

  /// No description provided for @backupExportAction.
  ///
  /// In en, this message translates to:
  /// **'Export backup file'**
  String get backupExportAction;

  /// No description provided for @backupImportAction.
  ///
  /// In en, this message translates to:
  /// **'Restore from backup file'**
  String get backupImportAction;

  /// No description provided for @backupExportShare.
  ///
  /// In en, this message translates to:
  /// **'TrustTrail offline backup ({vehicles} vehicles, {records} records)'**
  String backupExportShare(int vehicles, int records);

  /// No description provided for @backupRestoreConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore backup?'**
  String get backupRestoreConfirmTitle;

  /// No description provided for @backupRestoreConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This replaces the current local database with the selected backup file.'**
  String get backupRestoreConfirmBody;

  /// No description provided for @backupRestoreDone.
  ///
  /// In en, this message translates to:
  /// **'Restored {vehicles} vehicles and {records} records.'**
  String backupRestoreDone(int vehicles, int records);

  /// No description provided for @backupInvalidFile.
  ///
  /// In en, this message translates to:
  /// **'That file is not a valid TrustTrail backup or failed its SHA-256 integrity check.'**
  String get backupInvalidFile;

  /// No description provided for @backupSummary.
  ///
  /// In en, this message translates to:
  /// **'{vehicles} vehicles · {records} records · {reminders} reminders'**
  String backupSummary(int vehicles, int records, int reminders);

  /// No description provided for @eventsExport.
  ///
  /// In en, this message translates to:
  /// **'Export event log (CSV)'**
  String get eventsExport;

  /// No description provided for @eventsExportShare.
  ///
  /// In en, this message translates to:
  /// **'TrustTrail usability event log ({count} events)'**
  String eventsExportShare(int count);

  /// No description provided for @eventsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No evaluation events logged yet.'**
  String get eventsEmpty;

  /// No description provided for @eventsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} logged task events'**
  String eventsCount(int count);
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
      <String>['en', 'ne'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ne':
      return AppLocalizationsNe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
