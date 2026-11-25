// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'TrustTrail';

  @override
  String get tagline => 'Evidence-based vehicle history';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDone => 'Done';

  @override
  String get commonBack => 'Back';

  @override
  String get commonNext => 'Next';

  @override
  String get commonSkip => 'Skip';

  @override
  String get commonRetry => 'Try again';

  @override
  String get commonClose => 'Close';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonShare => 'Share';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonLoading => 'Loading…';

  @override
  String evidenceAttached(int count) {
    return 'Evidence attached ($count)';
  }

  @override
  String get selfReported => 'Self-reported';

  @override
  String get ownerRecorded => 'Owner-recorded';

  @override
  String get overdue => 'Overdue';

  @override
  String get dueSoon => 'Due soon';

  @override
  String get completionMeter => 'Completion meter';

  @override
  String get notATrustScore =>
      'Not a trust score — a count of documented sections.';

  @override
  String get demoBuild => 'Demo build — data stays on this device.';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get emptyGarageTitle => 'Your garage is empty';

  @override
  String get emptyGarageBody => 'Add your vehicle to start building its trail.';

  @override
  String get addVehicle => 'Add vehicle';

  @override
  String get navGarage => 'Garage';

  @override
  String get navSearch => 'Search';

  @override
  String get navReminders => 'Reminders';

  @override
  String get navProfile => 'Profile';

  @override
  String get navSaved => 'Saved';

  @override
  String get navBrowse => 'Browse';

  @override
  String get lookupMissTitle => 'We couldn\'t find that report';

  @override
  String get lookupMissBody =>
      'Tokens created on another device don\'t exist here. Ask the seller for the PDF.';

  @override
  String get loginNoAccount =>
      'No account found for that number. Create your account below.';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String namasteUser(String name) {
    return 'Namaste, $name';
  }

  @override
  String get yourGarage => 'Your garage';

  @override
  String get garageSubtitle => 'Every entry here is owner-recorded.';

  @override
  String get recentActivity => 'Recent activity';

  @override
  String get viewAll => 'View all';

  @override
  String get viewTimeline => 'View timeline';

  @override
  String get addRecord => 'Add record';

  @override
  String get shareReport => 'Share report';

  @override
  String get generateReport => 'Generate report';

  @override
  String incompleteSections(int count) {
    return '$count of 10 sections need attention';
  }

  @override
  String get missingSections => 'Missing evidence';

  @override
  String get odometer => 'Odometer';

  @override
  String get odometerTrend => 'Odometer trend';

  @override
  String gapNote(String from, String to, int months) {
    return 'No records between $from and $to ($months months).';
  }

  @override
  String get noRecordsTitle => 'No records yet';

  @override
  String get noRecordsBody => 'Add the first service, insurance or tax entry.';

  @override
  String get recordSaved => 'Record saved';

  @override
  String get vehicleAdded => 'Vehicle added';

  @override
  String get allSet => 'You\'re all set';

  @override
  String get onboardingTitle1 => 'A history buyers can read';

  @override
  String get onboardingBody1 =>
      'Service, insurance, tax and repairs — recorded as they happen, with photos of the paperwork.';

  @override
  String get onboardingTitle2 => 'Honest by design';

  @override
  String get onboardingBody2 =>
      'No invented trust scores. You see what is documented, what is missing and what is self-reported.';

  @override
  String get onboardingTitle3 => 'Share a dossier, not a story';

  @override
  String get onboardingBody3 =>
      'Generate a PDF or QR report that travels with the bike — even when the buyer is offline.';

  @override
  String get getStarted => 'Get started';

  @override
  String get chooseLanguage => 'Choose your language';

  @override
  String get english => 'English';

  @override
  String get nepali => 'नेपाली';

  @override
  String get chooseRole => 'How will you use TrustTrail?';

  @override
  String get ownerRole => 'I own a vehicle';

  @override
  String get ownerRoleBody =>
      'Record services and share an evidence-backed history when you sell.';

  @override
  String get buyerRole => 'I\'m checking a vehicle';

  @override
  String get buyerRoleBody => 'Look up a shared report by plate, QR or token.';

  @override
  String get continueDemo => 'Use the demo account';

  @override
  String get registerTitle => 'Create your account';

  @override
  String get loginTitle => 'Welcome back';

  @override
  String get fullName => 'Full name';

  @override
  String get phoneNumber => 'Mobile number';

  @override
  String get emailOptional => 'Email (optional)';

  @override
  String get consent =>
      'I understand this demo stores data only on this device.';

  @override
  String get sendOtp => 'Continue with phone';

  @override
  String get otpTitle => 'Enter the demo code';

  @override
  String otpSentTo(String phone) {
    return 'We sent a simulated code to $phone. Any 6 digits work in this demo.';
  }

  @override
  String get demoOtpHint => 'Demo OTP: 123456';

  @override
  String get verify => 'Verify';

  @override
  String get resendCode => 'Resend code';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get forgotPasswordBody =>
      'This demo has no online account. Sign in with your phone number, or create a new account with any 6-digit code.';

  @override
  String get logout => 'Log out';

  @override
  String get buyerSearchTitle => 'Check a vehicle';

  @override
  String get searchHint => 'Plate, token or link';

  @override
  String get scanQr => 'Scan QR';

  @override
  String get scanCameraError => 'The camera could not start on this device.';

  @override
  String get scanHintBody =>
      'Point at the seller\'s QR, or enter the code manually.';

  @override
  String get scanManualEntry => 'Enter code manually';

  @override
  String get scanPermissionNote =>
      'Camera permission is requested by the system. Manual entry always works.';

  @override
  String get scanTorch => 'Torch';

  @override
  String odometerTrendSemantics(String minKm, String maxKm) {
    return 'Odometer trend, $minKm to $maxKm';
  }

  @override
  String get searchButton => 'Look up report';

  @override
  String get recentSearches => 'Recent searches';

  @override
  String get savedReports => 'Saved reports';

  @override
  String get trySampleReport => 'Try a sample report';

  @override
  String get saveReport => 'Save report';

  @override
  String get removeSaved => 'Remove';

  @override
  String get compare => 'Compare';

  @override
  String get noSavedTitle => 'Nothing saved yet';

  @override
  String get noSavedBody => 'Save reports you want to compare later.';

  @override
  String get searchEmptyTitle => 'Search a plate or token';

  @override
  String get searchEmptyBody => 'Try BA 99 PA 4521 or TT-FZS-2026.';

  @override
  String get reportPrepareTitle => 'Prepare report';

  @override
  String get reportPrepareBody =>
      'Choose what the buyer can see. The snapshot freezes the data at this moment.';

  @override
  String get includeCosts => 'Include costs';

  @override
  String get includeEvidence => 'Include evidence thumbnails';

  @override
  String get includeCostsBody => 'Amounts you recorded in NPR.';

  @override
  String get includeEvidenceBody => 'The buyer sees the receipts you attached.';

  @override
  String get reportPreviewTitle => 'Report preview';

  @override
  String get reportShareTitle => 'Share report';

  @override
  String get copyCode => 'Copy code';

  @override
  String get copyLink => 'Copy link';

  @override
  String get downloadPdf => 'Share PDF';

  @override
  String get shareText => 'Share summary';

  @override
  String get reportGenerating => 'Preparing your report';

  @override
  String get demoTokenNote => 'This report lives on this device only.';

  @override
  String get oneDeviceNote =>
      'Reports resolve against the local database. Ask the seller for the PDF if you\'re on another phone.';

  @override
  String get completionNotScore => 'Completion meter — not a trust score.';

  @override
  String get categoryService => 'Service';

  @override
  String get categoryInsurance => 'Insurance';

  @override
  String get categoryTax => 'Road tax';

  @override
  String get categoryRepair => 'Repair';

  @override
  String get categoryOwnership => 'Ownership';

  @override
  String get categoryInspection => 'Inspection';

  @override
  String get categoryPollution => 'Pollution';

  @override
  String get categoryFuel => 'Fuel';

  @override
  String get sourceSelfReported => 'Self-reported';

  @override
  String get evidenceNone => 'No evidence attached';

  @override
  String evidenceAttachedShort(int count) {
    return '$count attached';
  }

  @override
  String get remindersTitle => 'Reminders';

  @override
  String get overdueGroup => 'Overdue';

  @override
  String get thisMonth => 'This month';

  @override
  String get laterGroup => 'Later';

  @override
  String get markDone => 'Mark done';

  @override
  String get snooze30 => 'Snooze 30 days';

  @override
  String get noReminders => 'No reminders';

  @override
  String get noRemindersBody =>
      'Add insurance, tax or service reminders from a vehicle.';

  @override
  String get addReminder => 'Add reminder';

  @override
  String reminderSummary(int reminders, int vehicles) {
    String _temp0 = intl.Intl.pluralLogic(
      reminders,
      locale: localeName,
      other: '$reminders active reminders',
      one: '1 active reminder',
      zero: 'No active reminders',
    );
    String _temp1 = intl.Intl.pluralLogic(
      vehicles,
      locale: localeName,
      other: '$vehicles vehicles',
      one: '1 vehicle',
      zero: 'no vehicles',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String overdueReminderBanner(int count, String status) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reminders',
      one: '1 reminder',
    );
    return '$_temp0 · $status';
  }

  @override
  String recordEvidenceSummary(int records, int evidence) {
    String _temp0 = intl.Intl.pluralLogic(
      records,
      locale: localeName,
      other: '$records records',
      one: '1 record',
    );
    String _temp1 = intl.Intl.pluralLogic(
      evidence,
      locale: localeName,
      other: '$evidence evidence files',
      one: '1 evidence file',
      zero: 'no evidence',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String recordsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count records',
      one: '1 record',
      zero: 'No records',
    );
    return '$_temp0';
  }

  @override
  String readingsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count readings',
      one: '1 reading',
      zero: 'No readings',
    );
    return '$_temp0';
  }

  @override
  String acrossReadings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count readings',
      one: '1 reading',
    );
    return 'across $_temp0';
  }

  @override
  String odometerAverageSummary(String km, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count readings',
      one: '1 reading',
    );
    return '$km km/month average across $_temp0.';
  }

  @override
  String odometerAverage(String km) {
    return '$km km/month average';
  }

  @override
  String responsesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count responses',
      one: '1 response',
      zero: 'No responses yet',
    );
    return '$_temp0';
  }

  @override
  String savedOn(String date) {
    return 'Saved $date';
  }

  @override
  String gapNoteSentence(String from, String to, String months) {
    return 'No records between $from and $to ($months months).';
  }

  @override
  String odometerDecreaseSentence(
    String fromKm,
    String toKm,
    String from,
    String to,
  ) {
    return 'Odometer decreased from $fromKm km to $toKm km between $from and $to.';
  }

  @override
  String highUsageSentence(String from, String to) {
    return 'Implied usage looks high between $from and $to. Check the readings.';
  }

  @override
  String flagDecreaseNote(String fromKm, String toKm) {
    return 'Odometer decreased from $fromKm km to $toKm km. Recorded as-is — check the documents.';
  }

  @override
  String flagHighUsageNote(String rate, String from, String to) {
    return 'Implied usage of $rate km/month between $from and $to. Check the readings.';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get language => 'Language';

  @override
  String get feedback => 'Help improve TrustTrail';

  @override
  String get feedbackBody =>
      'A 10-question usability survey, stored on this device.';

  @override
  String get demoData => 'Demo data';

  @override
  String get resetDemo => 'Reset demo data';

  @override
  String get resetDemoBody =>
      'Clears local records and restores the three demo reports.';

  @override
  String get resetDone => 'Demo data restored';

  @override
  String get aboutTitle => 'About TrustTrail';

  @override
  String get version => 'Version 1.0.0 (demo)';

  @override
  String get profileTitle => 'Profile';

  @override
  String get account => 'Account';

  @override
  String get switchRole => 'Switch role';

  @override
  String get stats => 'Your numbers';

  @override
  String get yourActivity => 'Your activity';

  @override
  String get statVehicles => 'Vehicles';

  @override
  String get statRecords => 'Records';

  @override
  String get statReports => 'Reports';

  @override
  String get susTitle => 'TrustTrail usability survey';

  @override
  String get susIntro =>
      'Ten statements, from 1 (strongly disagree) to 5 (strongly agree).';

  @override
  String get susSubmit => 'Submit survey';

  @override
  String get susScore => 'Your SUS score';

  @override
  String get susComment => 'Anything confusing? (optional)';

  @override
  String get susParticipant => 'Participant code';

  @override
  String get susThanks => 'Thank you — this helps the evaluation.';

  @override
  String get susExport => 'Export CSV';

  @override
  String get susScaleLow => '1 · disagree';

  @override
  String get susScaleHigh => '5 · agree';

  @override
  String get susCsvNote =>
      'CSV includes participant code, role, score and comments. Stored only on this device.';

  @override
  String get susFormulaNote =>
      'SUS: odd items score (x − 1), even items score (5 − x); sum × 2.5.';

  @override
  String susExportShare(int count) {
    return 'TrustTrail SUS responses ($count)';
  }

  @override
  String get evidenceTitle => 'Evidence';

  @override
  String get attachEvidence => 'Attach evidence';

  @override
  String get evidenceFromCamera => 'Take a photo';

  @override
  String get evidenceFromGallery => 'Choose from gallery';

  @override
  String get evidenceFromFile => 'Choose a PDF';

  @override
  String get evidenceEmptyTitle => 'No evidence yet';

  @override
  String get evidenceEmptyBody => 'Add a photo of the receipt or document.';

  @override
  String get evidenceViewer => 'Evidence viewer';

  @override
  String get uploadFailed => 'That file could not be added.';

  @override
  String get deleteRecord => 'Delete record';

  @override
  String get deleteRecordBody =>
      'This also removes its evidence. This cannot be undone.';

  @override
  String get requiredField => 'Required';

  @override
  String get invalidPhone => 'Enter a valid Nepali mobile number';

  @override
  String get invalidPlate => 'Use a plate like BA 2 PA 1234';

  @override
  String get invalidYear => 'Enter a valid year';

  @override
  String get invalidOdometer => 'Enter the odometer reading';

  @override
  String get invalidCost => 'Enter an amount in NPR';

  @override
  String get recordDetails => 'Record details';

  @override
  String get category => 'Category';

  @override
  String get recordTitle => 'Title';

  @override
  String get date => 'Date';

  @override
  String get workshop => 'Workshop';

  @override
  String get cost => 'Cost (NPR)';

  @override
  String get documentNo => 'Document number';

  @override
  String get notes => 'Notes';

  @override
  String get source => 'Source';

  @override
  String get sourceOwner => 'Owner-recorded';

  @override
  String get sourceWorkshop => 'Workshop receipt';

  @override
  String get sourceOfficial => 'Official document';

  @override
  String get odometerKm => 'Odometer (km)';

  @override
  String get saveRecord => 'Save record';

  @override
  String get selectDate => 'Select date';

  @override
  String get vehicleBasics => 'Vehicle basics';

  @override
  String get registration => 'Registration';

  @override
  String get review => 'Review';

  @override
  String get make => 'Make';

  @override
  String get model => 'Model';

  @override
  String get year => 'Year';

  @override
  String get plateRoman => 'Registration (Roman)';

  @override
  String get plateDevanagari => 'Registration (Devanagari)';

  @override
  String get province => 'Province';

  @override
  String get fuel => 'Fuel';

  @override
  String get transmission => 'Transmission';

  @override
  String get colour => 'Colour';

  @override
  String get chassis => 'Chassis number';

  @override
  String get engineNo => 'Engine number';

  @override
  String get initialOdometer => 'Current odometer';

  @override
  String get saveVehicle => 'Save vehicle';

  @override
  String stepOf(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get sus1 => 'I think that I would like to use TrustTrail frequently.';

  @override
  String get sus2 => 'I found TrustTrail unnecessarily complex.';

  @override
  String get sus3 => 'I thought TrustTrail was easy to use.';

  @override
  String get sus4 =>
      'I think that I would need the support of a technical person to be able to use TrustTrail.';

  @override
  String get sus5 =>
      'I found the various functions in TrustTrail were well integrated.';

  @override
  String get sus6 =>
      'I thought there was too much inconsistency in TrustTrail.';

  @override
  String get sus7 =>
      'I would imagine that most people would learn to use TrustTrail very quickly.';

  @override
  String get sus8 => 'I found TrustTrail very awkward to use.';

  @override
  String get sus9 => 'I felt very confident using TrustTrail.';

  @override
  String get sus10 =>
      'I needed to learn a lot of things before I could get going with TrustTrail.';

  @override
  String get susAverage => 'Average score';

  @override
  String get susResponses => 'Responses on this device';

  @override
  String get susExportDone => 'CSV ready to share';

  @override
  String get aboutIntro =>
      'TrustTrail is a student prototype for evidence-based vehicle history in Nepal\'s second-hand market.';

  @override
  String get aboutPrivacyTitle => 'Privacy';

  @override
  String get aboutPrivacyBody =>
      'All vehicles, records and evidence stay in this app\'s private storage on this phone. Nothing is uploaded or shared unless you choose to share a report.';

  @override
  String get aboutLimitsTitle => 'Honest limitations';

  @override
  String get aboutLimitsBody =>
      'Records are entered by owners and are not checked with the Department of Transport or any insurer. A completion meter shows how much of the checklist is covered — it is not a trust score. QR codes and links only resolve on the device that created the report.';

  @override
  String get aboutDataTitle => 'Demo build';

  @override
  String get aboutDataBody =>
      'The owner, vehicles, receipts and shared reports are fictitious sample data. The SMS code is simulated: any six digits work.';

  @override
  String get storageUsage => 'Evidence storage';

  @override
  String storageFiles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count files',
      one: '1 file',
      zero: 'No files',
    );
    return '$_temp0';
  }

  @override
  String get demoDataNote =>
      'Demo vehicles, receipts and shared reports are regenerated deterministically. Photos live in the app bundle.';

  @override
  String get modeOwner => 'Owner mode';

  @override
  String get modeBuyer => 'Buyer mode';

  @override
  String get selectVehicle => 'Choose a vehicle';

  @override
  String get orDivider => 'or';

  @override
  String get errorReportOpen => 'The report could not be opened.';

  @override
  String get errorSavedReports => 'Saved reports could not be read.';

  @override
  String get errorDatabase => 'The local database could not be read.';

  @override
  String get errorRecordLoad => 'The record could not be loaded.';

  @override
  String get errorPrepareVehicle => 'The vehicle could not be prepared.';

  @override
  String get errorVehicleLoad => 'This vehicle could not be loaded.';

  @override
  String get errorReportLoad => 'The report could not be loaded.';

  @override
  String get errorShareSheet => 'The share sheet could not be loaded.';

  @override
  String get errorSessionRestore => 'The local session could not be restored.';

  @override
  String get demoTokensTitle => 'Demo tokens';

  @override
  String get demoTokensBody =>
      'Every fresh install ships with three frozen reports. Search a plate or use one of these tokens:';

  @override
  String get tryDemoToken => 'Try a demo token:';

  @override
  String generatedOn(String date) {
    return 'Generated $date';
  }

  @override
  String reminderOverdueBy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Overdue by $count days',
      one: 'Overdue by 1 day',
    );
    return '$_temp0';
  }

  @override
  String get reminderDueToday => 'Due today';

  @override
  String reminderDueIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Due in $count days',
      one: 'Due in 1 day',
    );
    return '$_temp0';
  }

  @override
  String reminderKmToTarget(String km) {
    return '$km km to target';
  }

  @override
  String get reminderServiceDue => 'Service due';

  @override
  String get reminderNewTitle => 'Insurance renewal';

  @override
  String get allSectionsPresent => 'All ten documented sections are present.';

  @override
  String get recordedTimeline => 'Recorded timeline';

  @override
  String get noSharedRecords => 'No records were shared with this report.';

  @override
  String missingListLabel(String list) {
    return 'Missing: $list.';
  }

  @override
  String get genStepSnapshot => 'Freezing the vehicle snapshot';

  @override
  String get genStepSections => 'Counting completeness sections';

  @override
  String get genStepToken => 'Building the dossier token';

  @override
  String get genStepReady => 'Ready to share';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get devanagariHelper => 'Shown in the Nepali report and plate chip.';

  @override
  String get chassisHint => 'MBLJAW1234 (masked in reports)';

  @override
  String get addVehicleEvidenceNote =>
      'You can attach the bluebook scan and other evidence from any record later. The completion meter updates automatically.';

  @override
  String get sectionBluebook => 'Bluebook scan';

  @override
  String get sectionOwnership => 'Ownership record';

  @override
  String get sectionServices => 'Three service records';

  @override
  String get sectionOdometer => 'Three odometer readings';

  @override
  String get sectionPhotos => 'Vehicle photos';

  @override
  String get chartNeedsReadings =>
      'Add at least two odometer readings to see a trend.';

  @override
  String get provinceKoshi => 'Koshi';

  @override
  String get provinceMadhesh => 'Madhesh';

  @override
  String get provinceBagmati => 'Bagmati';

  @override
  String get provinceGandaki => 'Gandaki';

  @override
  String get provinceLumbini => 'Lumbini';

  @override
  String get provinceKarnali => 'Karnali';

  @override
  String get provinceSudurpashchim => 'Sudurpashchim';

  @override
  String get fuelPetrol => 'Petrol';

  @override
  String get fuelDiesel => 'Diesel';

  @override
  String get fuelElectric => 'Electric';

  @override
  String get fuelHybrid => 'Hybrid';

  @override
  String get fuelCng => 'CNG';

  @override
  String get transmissionManual => 'Manual';

  @override
  String get transmissionAutomatic => 'Automatic';

  @override
  String get transmissionAmt => 'AMT';

  @override
  String get transmissionCvt => 'CVT';

  @override
  String get colourHint => 'Black';

  @override
  String get splashTagline => 'Evidence, not promises.';

  @override
  String get splashDemoNote => 'Demo build · data stays on this device';

  @override
  String documentedPercent(int percent) {
    return '$percent% documented';
  }

  @override
  String get snapshotFreezeNote =>
      'The snapshot freezes today\'s data. Later edits do not change this report.';

  @override
  String get demoOtpNote => 'Demo OTP: 123456 · any 6 digits are accepted.';

  @override
  String get otpCodeLabel => '6-digit code';

  @override
  String get remindersIntro =>
      'Owner-set dates and odometer targets. No official penalties are invented.';

  @override
  String get noLongGapsNote =>
      'There are no gaps longer than 120 days between records.';

  @override
  String get ownerRecordedLocalNote =>
      'Owner-recorded history. Evidence is stored on this device and is not registry-verified.';

  @override
  String get dossierDisclaimer =>
      'Owner-recorded history. Evidence is not registry-verified. A gap means no record was shared, not that nothing happened.';

  @override
  String get compareTitle => 'Compare reports';

  @override
  String get compareSubtitle => 'Two saved snapshots, side by side.';

  @override
  String get savedReportsHint => 'Open a report, or select two to compare.';

  @override
  String get compareSelectTwo => 'Select two saved reports to compare.';

  @override
  String get compareNeutralNote =>
      'A factual side-by-side view. Completeness is a checklist count, not a ranking.';

  @override
  String get metricCompletion => 'Completion';

  @override
  String get metricRecords => 'Records';

  @override
  String get metricEvidence => 'Evidence files';

  @override
  String get metricLatestKm => 'Latest odometer';

  @override
  String get metricAvgKmMonth => 'Avg km/month';

  @override
  String get metricOdometerFlags => 'Odometer flags';

  @override
  String get metricGaps => 'Gaps';

  @override
  String get metricFirstRecord => 'First record';

  @override
  String get browseTitle => 'Marketplace';

  @override
  String get browseSubtitle =>
      'Second-hand vehicles with an owner-recorded history. Open an ad to read the report.';

  @override
  String get demoListingsNote =>
      'Demo listings — sellers, prices and areas are fictitious. Each opens a frozen snapshot from this device.';

  @override
  String get noListingsTitle => 'No listings available';

  @override
  String get noListingsBody =>
      'Reset the demo data in Settings to restore the sample listings.';

  @override
  String listedAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Listed $count days ago',
      one: 'Listed 1 day ago',
    );
    return '$_temp0';
  }

  @override
  String get demoListingBadge => 'Demo';

  @override
  String get vehicleHistory => 'Vehicle history';

  @override
  String get historyAtAGlance => 'History at a glance';

  @override
  String get glanceChecklist => 'Checklist';

  @override
  String get glanceRecords => 'Records';

  @override
  String get glanceEvidence => 'Evidence';

  @override
  String get glanceOdometer => 'Odometer checks';

  @override
  String get glanceGaps => 'Record gaps';

  @override
  String get glanceOwnership => 'Ownership entries';

  @override
  String get glanceNoIssues => 'No issues found';

  @override
  String get glanceNoGaps => 'No long gaps';

  @override
  String glanceFlags(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count readings flagged',
      one: '1 reading flagged',
    );
    return '$_temp0';
  }

  @override
  String glanceGapsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gaps over 120 days',
      one: '1 gap over 120 days',
    );
    return '$_temp0';
  }

  @override
  String get glanceOwnershipSub => 'As recorded by the owner';

  @override
  String get glanceComputedNote =>
      'Counts come from this frozen snapshot. A missing entry means no record was shared.';

  @override
  String reportHeroListedBy(String name) {
    return 'Listed by $name';
  }

  @override
  String documentedOf(int filled, int total) {
    return '$filled of $total documented';
  }
}
