// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Nepali (`ne`).
class AppLocalizationsNe extends AppLocalizations {
  AppLocalizationsNe([String locale = 'ne']) : super(locale);

  @override
  String get appName => 'TrustTrail';

  @override
  String get tagline => 'प्रमाणमा आधारित वाहन इतिहास';

  @override
  String get commonContinue => 'जारी राख्नुहोस्';

  @override
  String get commonCancel => 'रद्द गर्नुहोस्';

  @override
  String get commonSave => 'सुरक्षित गर्नुहोस्';

  @override
  String get commonDone => 'सम्पन्न';

  @override
  String get commonBack => 'पछाडि';

  @override
  String get commonNext => 'अर्को';

  @override
  String get commonSkip => 'छोड्नुहोस्';

  @override
  String get commonRetry => 'फेरि प्रयास गर्नुहोस्';

  @override
  String get commonClose => 'बन्द गर्नुहोस्';

  @override
  String get commonAdd => 'थप्नुहोस्';

  @override
  String get commonEdit => 'सम्पादन';

  @override
  String get commonDelete => 'मेट्नुहोस्';

  @override
  String get commonShare => 'साझा गर्नुहोस्';

  @override
  String get commonSearch => 'खोज्नुहोस्';

  @override
  String get commonLoading => 'लोड हुँदैछ…';

  @override
  String evidenceAttached(int count) {
    return 'प्रमाण संलग्न ($count)';
  }

  @override
  String get selfReported => 'स्वयं घोषित';

  @override
  String get ownerRecorded => 'मालिकद्वारा अभिलेखित';

  @override
  String get overdue => 'म्याद नाघेको';

  @override
  String get dueSoon => 'चाँडै म्याद';

  @override
  String get completionMeter => 'पूर्णता मिटर';

  @override
  String get notATrustScore =>
      'यो विश्वास स्कोर होइन — दस्तावेज भएका खण्डहरूको गणना।';

  @override
  String get demoBuild => 'डेमो संस्करण — डेटा यही यन्त्रमा रहन्छ।';

  @override
  String get errorGeneric => 'केही गडबड भयो। फेरि प्रयास गर्नुहोस्।';

  @override
  String get emptyGarageTitle => 'तपाईंको ग्यारेज खाली छ';

  @override
  String get emptyGarageBody => 'वाहनको ट्रेल बनाउन पहिले वाहन थप्नुहोस्।';

  @override
  String get addVehicle => 'वाहन थप्नुहोस्';

  @override
  String get navGarage => 'ग्यारेज';

  @override
  String get navSearch => 'खोज';

  @override
  String get navReminders => 'रिमाइन्डर';

  @override
  String get navProfile => 'प्रोफाइल';

  @override
  String get navSaved => 'सुरक्षित';

  @override
  String get navBrowse => 'ब्राउज';

  @override
  String get lookupMissTitle => 'त्यो रिपोर्ट भेटिएन';

  @override
  String get lookupMissBody =>
      'अर्को यन्त्रमा बनाइएका टोकन यहाँ हुँदैनन्। विक्रेतासँग PDF माग्नुहोस्।';

  @override
  String get loginNoAccount =>
      'त्यो नम्बरको खाता भेटिएन। तल आफ्नो खाता बनाउनुहोस्।';

  @override
  String get welcomeBack => 'फेरि स्वागत';

  @override
  String namasteUser(String name) {
    return 'नमस्ते, $name';
  }

  @override
  String get yourGarage => 'तपाईंको ग्यारेज';

  @override
  String get garageSubtitle => 'यहाँको हरेक प्रविष्टि मालिकद्वारा अभिलेखित हो।';

  @override
  String get recentActivity => 'हालैको गतिविधि';

  @override
  String get viewAll => 'सबै हेर्नुहोस्';

  @override
  String get viewTimeline => 'टाइमलाइन हेर्नुहोस्';

  @override
  String get addRecord => 'अभिलेख थप्नुहोस्';

  @override
  String get shareReport => 'रिपोर्ट साझा गर्नुहोस्';

  @override
  String get generateReport => 'रिपोर्ट बनाउनुहोस्';

  @override
  String incompleteSections(int count) {
    return '१० मध्ये $count खण्डमा ध्यान दिनुहोस्';
  }

  @override
  String get missingSections => 'छुटेका प्रमाण';

  @override
  String get odometer => 'ओडोमिटर';

  @override
  String get odometerTrend => 'ओडोमिटर प्रवृत्ति';

  @override
  String gapNote(String from, String to, int months) {
    return '$from देखि $to सम्म कुनै अभिलेख छैन ($months महिना)।';
  }

  @override
  String get noRecordsTitle => 'अझै कुनै अभिलेख छैन';

  @override
  String get noRecordsBody => 'पहिलो सर्भिस, बीमा वा कर प्रविष्टि थप्नुहोस्।';

  @override
  String get recordSaved => 'अभिलेख सुरक्षित भयो';

  @override
  String get vehicleAdded => 'वाहन थपियो';

  @override
  String get allSet => 'सबै तयार छ';

  @override
  String get onboardingTitle1 => 'खरिदकर्ताले पढ्न सक्ने इतिहास';

  @override
  String get onboardingBody1 =>
      'सर्भिस, बीमा, कर र मर्मत — कागजातको फोटोसहित समयमै अभिलेख।';

  @override
  String get onboardingTitle2 => 'इमानदार डिजाइन';

  @override
  String get onboardingBody2 =>
      'बनावटी विश्वास स्कोर छैन। के दस्तावेज छ, के छैन र के स्वयं घोषित हो — सबै देखिन्छ।';

  @override
  String get onboardingTitle3 => 'कथा होइन, डोजियर साझा गर्नुहोस्';

  @override
  String get onboardingBody3 =>
      'PDF वा QR रिपोर्ट बनाउनुहोस् जुन खरिदकर्तासँग अफलाइन पनि जान्छ।';

  @override
  String get getStarted => 'सुरु गर्नुहोस्';

  @override
  String get chooseLanguage => 'भाषा छान्नुहोस्';

  @override
  String get english => 'English';

  @override
  String get nepali => 'नेपाली';

  @override
  String get chooseRole => 'तपाईं TrustTrail कसरी प्रयोग गर्नुहुन्छ?';

  @override
  String get ownerRole => 'मेरो वाहन छ';

  @override
  String get ownerRoleBody =>
      'सर्भिस अभिलेख राख्नुहोस् र बेच्दा प्रमाणसहितको इतिहास साझा गर्नुहोस्।';

  @override
  String get buyerRole => 'म वाहन जाँच्दै छु';

  @override
  String get buyerRoleBody => 'प्लेट, QR वा टोकनबाट साझा रिपोर्ट हेर्नुहोस्।';

  @override
  String get continueDemo => 'डेमो खाता प्रयोग गर्नुहोस्';

  @override
  String get registerTitle => 'खाता बनाउनुहोस्';

  @override
  String get loginTitle => 'फेरि स्वागत';

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get phoneNumber => 'मोबाइल नम्बर';

  @override
  String get emailOptional => 'इमेल (वैकल्पिक)';

  @override
  String get consent => 'म बुझ्छु कि यो डेमोले डेटा यही यन्त्रमा मात्र राख्छ।';

  @override
  String get sendOtp => 'फोन नम्बरले जारी राख्नुहोस्';

  @override
  String get otpTitle => 'डेमो कोड हाल्नुहोस्';

  @override
  String otpSentTo(String phone) {
    return '$phone मा नक्कली कोड पठाइयो। यो डेमोमा जुनसुकै ६ अंक मान्य छ।';
  }

  @override
  String get demoOtpHint => 'डेमो OTP: १२३४५६';

  @override
  String get verify => 'प्रमाणित गर्नुहोस्';

  @override
  String get resendCode => 'कोड फेरि पठाउनुहोस्';

  @override
  String get forgotPassword => 'पासवर्ड बिर्सनुभयो?';

  @override
  String get forgotPasswordBody =>
      'यो डेमोमा अनलाइन खाता छैन। फोन नम्बरले साइन इन गर्नुहोस् वा जुनसुकै ६ अंकको कोडले नयाँ खाता बनाउनुहोस्।';

  @override
  String get logout => 'लगआउट';

  @override
  String get buyerSearchTitle => 'वाहन जाँच्नुहोस्';

  @override
  String get searchHint => 'प्लेट, टोकन वा लिंक';

  @override
  String get scanQr => 'QR स्क्यान';

  @override
  String get scanCameraError => 'यो यन्त्रमा क्यामेरा सुरु हुन सकेन।';

  @override
  String get scanHintBody =>
      'विक्रेताको QR मा देखाउनुहोस्, वा कोड हातैले हाल्नुहोस्।';

  @override
  String get scanManualEntry => 'कोड हातैले हाल्नुहोस्';

  @override
  String get scanPermissionNote =>
      'क्यामेरा अनुमति सिस्टमले माग्छ। हातैले कोड हाल्ने विकल्प सधैं काम गर्छ।';

  @override
  String get scanTorch => 'टर्च';

  @override
  String odometerTrendSemantics(String minKm, String maxKm) {
    return 'ओडोमिटर प्रवृत्ति, $minKm देखि $maxKm सम्म';
  }

  @override
  String get searchButton => 'रिपोर्ट खोज्नुहोस्';

  @override
  String get recentSearches => 'हालैका खोज';

  @override
  String get savedReports => 'सुरक्षित रिपोर्ट';

  @override
  String get trySampleReport => 'नमुना रिपोर्ट हेर्नुहोस्';

  @override
  String get saveReport => 'रिपोर्ट सुरक्षित';

  @override
  String get removeSaved => 'हटाउनुहोस्';

  @override
  String get compare => 'तुलना';

  @override
  String get noSavedTitle => 'अझै केही सुरक्षित छैन';

  @override
  String get noSavedBody => 'पछि तुलना गर्न रिपोर्ट सुरक्षित गर्नुहोस्।';

  @override
  String get searchEmptyTitle => 'प्लेट वा टोकन खोज्नुहोस्';

  @override
  String get searchEmptyBody =>
      'BA 99 PA 4521 वा TT-FZS-2026 प्रयास गर्नुहोस्।';

  @override
  String get reportPrepareTitle => 'रिपोर्ट तयार गर्नुहोस्';

  @override
  String get reportPrepareBody =>
      'खरिदकर्ताले के देख्ने छान्नुहोस्। स्न्यापसनले अहिलेको डेटा स्थिर गर्छ।';

  @override
  String get includeCosts => 'खर्च समावेश';

  @override
  String get includeEvidence => 'प्रमाणका थम्बनेल समावेश';

  @override
  String get includeCostsBody => 'तपाईंले अभिलेख गरेका NPR रकम।';

  @override
  String get includeEvidenceBody => 'खरिदकर्ताले संलग्न रसिद देख्छ।';

  @override
  String get reportPreviewTitle => 'रिपोर्ट पूर्वावलोकन';

  @override
  String get reportShareTitle => 'रिपोर्ट साझा';

  @override
  String get copyCode => 'कोड कपी';

  @override
  String get copyLink => 'लिंक कपी';

  @override
  String get downloadPdf => 'PDF साझा';

  @override
  String get shareText => 'सारांश साझा';

  @override
  String get reportGenerating => 'तपाईंको रिपोर्ट तयार हुँदैछ';

  @override
  String get demoTokenNote => 'यो रिपोर्ट यही यन्त्रमा मात्र रहन्छ।';

  @override
  String get oneDeviceNote =>
      'रिपोर्ट स्थानीय डेटाबेसबाट खुल्छ। अर्को फोनमा भए विक्रेतासँग PDF माग्नुहोस्।';

  @override
  String get completionNotScore => 'पूर्णता मिटर — विश्वास स्कोर होइन।';

  @override
  String get categoryService => 'सर्भिस';

  @override
  String get categoryInsurance => 'बीमा';

  @override
  String get categoryTax => 'सडक कर';

  @override
  String get categoryRepair => 'मर्मत';

  @override
  String get categoryOwnership => 'स्वामित्व';

  @override
  String get categoryInspection => 'निरीक्षण';

  @override
  String get categoryPollution => 'प्रदूषण';

  @override
  String get categoryFuel => 'इन्धन';

  @override
  String get sourceSelfReported => 'स्वयं घोषित';

  @override
  String get evidenceNone => 'प्रमाण संलग्न छैन';

  @override
  String evidenceAttachedShort(int count) {
    return '$count संलग्न';
  }

  @override
  String get remindersTitle => 'रिमाइन्डर';

  @override
  String get overdueGroup => 'म्याद नाघेका';

  @override
  String get thisMonth => 'यो महिना';

  @override
  String get laterGroup => 'पछि';

  @override
  String get markDone => 'सम्पन्न भन्नुहोस्';

  @override
  String get snooze30 => '३० दिन स्थगित';

  @override
  String get noReminders => 'कुनै रिमाइन्डर छैन';

  @override
  String get noRemindersBody =>
      'वाहनबाट बीमा, कर वा सर्भिस रिमाइन्डर थप्नुहोस्।';

  @override
  String get addReminder => 'रिमाइन्डर थप्नुहोस्';

  @override
  String reminderSummary(int reminders, int vehicles) {
    String _temp0 = intl.Intl.pluralLogic(
      reminders,
      locale: localeName,
      other: '$reminders सक्रिय रिमाइन्डर',
      zero: 'कुनै सक्रिय रिमाइन्डर छैन',
    );
    String _temp1 = intl.Intl.pluralLogic(
      vehicles,
      locale: localeName,
      other: '$vehicles वाहन',
      one: '१ वाहन',
      zero: 'वाहन छैन',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String overdueReminderBanner(int count, String status) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count रिमाइन्डर',
      one: '१ रिमाइन्डर',
    );
    return '$_temp0 · $status';
  }

  @override
  String recordEvidenceSummary(int records, int evidence) {
    String _temp0 = intl.Intl.pluralLogic(
      records,
      locale: localeName,
      other: '$records रेकर्ड',
      one: '१ रेकर्ड',
    );
    String _temp1 = intl.Intl.pluralLogic(
      evidence,
      locale: localeName,
      other: '$evidence प्रमाण फाइल',
      one: '१ प्रमाण फाइल',
      zero: 'प्रमाण छैन',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String recordsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count रेकर्ड',
      one: '१ रेकर्ड',
      zero: 'रेकर्ड छैन',
    );
    return '$_temp0';
  }

  @override
  String readingsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count रेडिङ',
      one: '१ रेडिङ',
      zero: 'रेडिङ छैन',
    );
    return '$_temp0';
  }

  @override
  String acrossReadings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count रेडिङभर',
      one: '१ रेडिङभर',
    );
    return '$_temp0';
  }

  @override
  String odometerAverageSummary(String km, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count रेडिङ',
      one: '१ रेडिङ',
    );
    return '$km किमी/महिना औसत, $_temp0मा आधारित।';
  }

  @override
  String odometerAverage(String km) {
    return '$km किमी/महिना औसत';
  }

  @override
  String responsesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count प्रतिक्रिया',
      one: '१ प्रतिक्रिया',
      zero: 'अहिलेसम्म कुनै प्रतिक्रिया छैन',
    );
    return '$_temp0';
  }

  @override
  String savedOn(String date) {
    return '$date मा सुरक्षित';
  }

  @override
  String gapNoteSentence(String from, String to, String months) {
    return '$from र $to बीच कुनै रेकर्ड छैन ($months महिना)।';
  }

  @override
  String odometerDecreaseSentence(
    String fromKm,
    String toKm,
    String from,
    String to,
  ) {
    return '$from र $to बीच ओडोमिटर $fromKm किमीबाट $toKm किमीमा घटेको छ।';
  }

  @override
  String highUsageSentence(String from, String to) {
    return '$from र $to बीच प्रयोग उच्च देखिन्छ। रेडिङ जाँच्नुहोस्।';
  }

  @override
  String flagDecreaseNote(String fromKm, String toKm) {
    return 'ओडोमिटर $fromKm किमीबाट $toKm किमीमा घटेको छ। यथावत् राखिएको — कागजात जाँच्नुहोस्।';
  }

  @override
  String flagHighUsageNote(String rate, String from, String to) {
    return '$from र $to बीच करिब $rate किमी/महिना प्रयोग देखिन्छ। रेडिङ जाँच्नुहोस्।';
  }

  @override
  String get settingsTitle => 'सेटिङ';

  @override
  String get appearance => 'देखावट';

  @override
  String get themeLight => 'उज्यालो';

  @override
  String get themeDark => 'अँध्यारो';

  @override
  String get themeSystem => 'सिस्टम';

  @override
  String get language => 'भाषा';

  @override
  String get feedback => 'TrustTrail सुधार्न मद्दत गर्नुहोस्';

  @override
  String get feedbackBody =>
      '१० प्रश्नको प्रयोगयोग्यता सर्वेक्षण, यही यन्त्रमा।';

  @override
  String get demoData => 'डेमो डेटा';

  @override
  String get resetDemo => 'डेमो डेटा रिसेट';

  @override
  String get resetDemoBody =>
      'स्थानीय अभिलेख मेटेर तीन डेमो रिपोर्ट फेरि बनाउँछ।';

  @override
  String get resetDone => 'डेमो डेटा फेरि तयार भयो';

  @override
  String get aboutTitle => 'TrustTrail बारे';

  @override
  String get version => 'संस्करण १.०.० (डेमो)';

  @override
  String get profileTitle => 'प्रोफाइल';

  @override
  String get account => 'खाता';

  @override
  String get switchRole => 'भूमिका परिवर्तन';

  @override
  String get stats => 'तपाईंका अंक';

  @override
  String get yourActivity => 'तपाईंको गतिविधि';

  @override
  String get statVehicles => 'वाहन';

  @override
  String get statRecords => 'अभिलेख';

  @override
  String get statReports => 'रिपोर्ट';

  @override
  String get susTitle => 'TrustTrail प्रयोगयोग्यता सर्वेक्षण';

  @override
  String get susIntro => 'दस भनाइ, १ (पूर्ण असहमति) देखि ५ (पूर्ण सहमति)।';

  @override
  String get susSubmit => 'सर्वेक्षण पठाउनुहोस्';

  @override
  String get susScore => 'तपाईंको SUS स्कोर';

  @override
  String get susComment => 'केही अन्योलमा पार्‍यो? (वैकल्पिक)';

  @override
  String get susParticipant => 'सहभागी कोड';

  @override
  String get susThanks => 'धन्यवाद — यसले मूल्याङ्कनमा मद्दत गर्छ।';

  @override
  String get susExport => 'CSV निर्यात';

  @override
  String get susScaleLow => '१ · असहमति';

  @override
  String get susScaleHigh => '५ · सहमति';

  @override
  String get susCsvNote =>
      'CSV मा सहभागी कोड, भूमिका, स्कोर र टिप्पणी समावेश हुन्छन्। यही यन्त्रमा मात्र रहन्छ।';

  @override
  String get susFormulaNote =>
      'SUS: विषम प्रश्न (x − १), सम प्रश्न (५ − x); जोड × २.५।';

  @override
  String susExportShare(int count) {
    return 'TrustTrail SUS प्रतिक्रिया ($count)';
  }

  @override
  String get evidenceTitle => 'प्रमाण';

  @override
  String get attachEvidence => 'प्रमाण संलग्न';

  @override
  String get evidenceFromCamera => 'फोटो खिच्नुहोस्';

  @override
  String get evidenceFromGallery => 'ग्यालरीबाट छान्नुहोस्';

  @override
  String get evidenceFromFile => 'PDF छान्नुहोस्';

  @override
  String get evidenceEmptyTitle => 'अझै प्रमाण छैन';

  @override
  String get evidenceEmptyBody => 'रसिद वा कागजातको फोटो थप्नुहोस्।';

  @override
  String get evidenceViewer => 'प्रमाण हेर्ने';

  @override
  String get uploadFailed => 'त्यो फाइल थप्न सकिएन।';

  @override
  String get deleteRecord => 'अभिलेख मेट्नुहोस्';

  @override
  String get deleteRecordBody =>
      'यससँगै प्रमाण पनि मेटिन्छ। यो फिर्ता गर्न सकिँदैन।';

  @override
  String get requiredField => 'आवश्यक';

  @override
  String get invalidPhone => 'मान्य नेपाली मोबाइल नम्बर हाल्नुहोस्';

  @override
  String get invalidPlate => 'BA 2 PA 1234 जस्तो प्लेट हाल्नुहोस्';

  @override
  String get invalidYear => 'मान्य वर्ष हाल्नुहोस्';

  @override
  String get invalidOdometer => 'ओडोमिटर रिडिङ हाल्नुहोस्';

  @override
  String get invalidCost => 'NPR रकम हाल्नुहोस्';

  @override
  String get recordDetails => 'अभिलेख विवरण';

  @override
  String get category => 'श्रेणी';

  @override
  String get recordTitle => 'शीर्षक';

  @override
  String get date => 'मिति';

  @override
  String get workshop => 'वर्कशप';

  @override
  String get cost => 'खर्च (NPR)';

  @override
  String get documentNo => 'कागजात नम्बर';

  @override
  String get notes => 'टिप्पणी';

  @override
  String get source => 'स्रोत';

  @override
  String get sourceOwner => 'मालिकद्वारा अभिलेखित';

  @override
  String get sourceWorkshop => 'वर्कशप रसिद';

  @override
  String get sourceOfficial => 'आधिकारिक कागजात';

  @override
  String get odometerKm => 'ओडोमिटर (किमी)';

  @override
  String get saveRecord => 'अभिलेख सुरक्षित';

  @override
  String get selectDate => 'मिति छान्नुहोस्';

  @override
  String get vehicleBasics => 'वाहनको आधारभूत';

  @override
  String get registration => 'दर्ता';

  @override
  String get review => 'समीक्षा';

  @override
  String get make => 'ब्रान्ड';

  @override
  String get model => 'मोडेल';

  @override
  String get year => 'वर्ष';

  @override
  String get plateRoman => 'दर्ता (रोमन)';

  @override
  String get plateDevanagari => 'दर्ता (देवनागरी)';

  @override
  String get province => 'प्रदेश';

  @override
  String get fuel => 'इन्धन';

  @override
  String get transmission => 'गियर';

  @override
  String get colour => 'रङ';

  @override
  String get chassis => 'च्यासिस नम्बर';

  @override
  String get engineNo => 'इन्जिन नम्बर';

  @override
  String get initialOdometer => 'हालको ओडोमिटर';

  @override
  String get saveVehicle => 'वाहन सुरक्षित';

  @override
  String stepOf(int current, int total) {
    return 'चरण $current / $total';
  }

  @override
  String get sus1 => 'म TrustTrail बारम्बार प्रयोग गर्न चाहन्छु।';

  @override
  String get sus2 => 'मलाई TrustTrail अनावश्यक रूपमा जटिल लाग्यो।';

  @override
  String get sus3 => 'TrustTrail प्रयोग गर्न सजिलो लाग्यो।';

  @override
  String get sus4 =>
      'TrustTrail प्रयोग गर्न मलाई प्राविधिक व्यक्तिको सहयोग चाहिन्छ जस्तो लाग्छ।';

  @override
  String get sus5 =>
      'TrustTrail का विभिन्न सुविधाहरू राम्ररी एकीकृत छन् जस्तो लाग्यो।';

  @override
  String get sus6 => 'TrustTrail मा धेरै असंगति छ जस्तो लाग्यो।';

  @override
  String get sus7 =>
      'अधिकांश मानिसले TrustTrail छिट्टै सिक्छन् भन्ने मलाई लाग्छ।';

  @override
  String get sus8 => 'TrustTrail प्रयोग गर्न निकै अप्ठ्यारो लाग्यो।';

  @override
  String get sus9 => 'TrustTrail प्रयोग गर्दा मलाई धेरै आत्मविश्वास महसुस भयो।';

  @override
  String get sus10 => 'TrustTrail सुरु गर्नुअघि मैले धेरै कुरा सिक्नुपर्‍यो।';

  @override
  String get susAverage => 'औसत स्कोर';

  @override
  String get susResponses => 'यही यन्त्रमा प्रतिक्रिया';

  @override
  String get susExportDone => 'CSV साझा गर्न तयार';

  @override
  String get aboutIntro =>
      'TrustTrail नेपालको दोस्रो हात बजारमा प्रमाणमा आधारित वाहन इतिहासका लागि विद्यार्थी प्रोटोटाइप हो।';

  @override
  String get aboutPrivacyTitle => 'गोपनीयता';

  @override
  String get aboutPrivacyBody =>
      'सबै वाहन, अभिलेख र प्रमाण यही फोनको निजी भण्डारणमा रहन्छन्। तपाईंले रिपोर्ट साझा नगरेसम्म केही पनि अपलोड वा साझा हुँदैन।';

  @override
  String get aboutLimitsTitle => 'स्पष्ट सीमाहरू';

  @override
  String get aboutLimitsBody =>
      'अभिलेख मालिकहरूले भरेका हुन् र यातायात विभाग वा बीमकसँग जाँचिएका छैनन्। पूर्णता मिटरले चेकलिस्टको कति भाग समेटिएको देखाउँछ — यो विश्वास स्कोर होइन। QR र लिङ्क रिपोर्ट बनाएको यन्त्रमा मात्र खुल्छन्।';

  @override
  String get aboutDataTitle => 'डेमो संस्करण';

  @override
  String get aboutDataBody =>
      'मालिक, वाहन, रसिद र साझा रिपोर्टहरू काल्पनिक नमुना डेटा हुन्। SMS कोड नक्कली हो: कुनै पनि छ अंकले काम गर्छ।';

  @override
  String get storageUsage => 'प्रमाण भण्डारण';

  @override
  String storageFiles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count फाइल',
      one: '१ फाइल',
      zero: 'कुनै फाइल छैन',
    );
    return '$_temp0';
  }

  @override
  String get demoDataNote =>
      'डेमो वाहन, रसिद र साझा रिपोर्टहरू निर्धारित रूपमा फेरि बनाइन्छन्। फोटोहरू एप बन्डलमा रहन्छन्।';

  @override
  String get modeOwner => 'मालिक मोड';

  @override
  String get modeBuyer => 'खरिदकर्ता मोड';

  @override
  String get selectVehicle => 'वाहन छान्नुहोस्';

  @override
  String get orDivider => 'वा';

  @override
  String get errorReportOpen => 'रिपोर्ट खोल्न सकिएन।';

  @override
  String get errorSavedReports => 'सुरक्षित रिपोर्टहरू पढ्न सकिएन।';

  @override
  String get errorDatabase => 'स्थानीय डेटाबेस पढ्न सकिएन।';

  @override
  String get errorRecordLoad => 'अभिलेख लोड गर्न सकिएन।';

  @override
  String get errorPrepareVehicle => 'वाहन तयार गर्न सकिएन।';

  @override
  String get errorVehicleLoad => 'यो वाहन लोड गर्न सकिएन।';

  @override
  String get errorReportLoad => 'रिपोर्ट लोड गर्न सकिएन।';

  @override
  String get errorShareSheet => 'साझा विकल्प लोड गर्न सकिएन।';

  @override
  String get errorSessionRestore => 'स्थानीय सत्र पुनःस्थापित गर्न सकिएन।';

  @override
  String get demoTokensTitle => 'डेमो टोकन';

  @override
  String get demoTokensBody =>
      'हरेक नयाँ स्थापनामा तीन स्थिर रिपोर्ट हुन्छन्। प्लेट खोज्नुहोस् वा यीमध्ये एउटा टोकन प्रयोग गर्नुहोस्:';

  @override
  String get tryDemoToken => 'डेमो टोकन प्रयास गर्नुहोस्:';

  @override
  String generatedOn(String date) {
    return 'बनाइयो: $date';
  }

  @override
  String reminderOverdueBy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'म्याद $count दिन नाघ्यो',
      one: 'म्याद १ दिन नाघ्यो',
    );
    return '$_temp0';
  }

  @override
  String get reminderDueToday => 'आज म्याद';

  @override
  String reminderDueIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिनमा म्याद',
      one: '१ दिनमा म्याद',
    );
    return '$_temp0';
  }

  @override
  String reminderKmToTarget(String km) {
    return '$km किमी बाँकी';
  }

  @override
  String get reminderServiceDue => 'सर्भिस म्याद';

  @override
  String get reminderNewTitle => 'बीमा नवीकरण';

  @override
  String get allSectionsPresent => 'सबै दस दस्तावेजीकृत खण्ड उपलब्ध छन्।';

  @override
  String get recordedTimeline => 'अभिलेखित टाइमलाइन';

  @override
  String get noSharedRecords => 'यो रिपोर्टसँग कुनै अभिलेख साझा गरिएको छैन।';

  @override
  String missingListLabel(String list) {
    return 'छुटेको: $list।';
  }

  @override
  String get genStepSnapshot => 'वाहनको स्न्यापसन स्थिर गर्दै';

  @override
  String get genStepSections => 'पूर्णता खण्ड गन्दै';

  @override
  String get genStepToken => 'डोजियर टोकन बनाउँदै';

  @override
  String get genStepReady => 'साझा गर्न तयार';

  @override
  String get copiedToClipboard => 'क्लिपबोर्डमा प्रतिलिपि भयो';

  @override
  String get devanagariHelper => 'नेपाली रिपोर्ट र प्लेट चिपमा देखिन्छ।';

  @override
  String get chassisHint => 'MBLJAW1234 (रिपोर्टमा मास्क गरिन्छ)';

  @override
  String get addVehicleEvidenceNote =>
      'ब्लुबुक स्क्यान र अन्य प्रमाण पछि कुनै पनि अभिलेखबाट संलग्न गर्न सकिन्छ। पूर्णता मिटर स्वतः अद्यावधिक हुन्छ।';

  @override
  String get sectionBluebook => 'ब्लुबुक स्क्यान';

  @override
  String get sectionOwnership => 'स्वामित्व अभिलेख';

  @override
  String get sectionServices => 'तीन सर्भिस अभिलेख';

  @override
  String get sectionOdometer => 'तीन ओडोमिटर रेडिङ';

  @override
  String get sectionPhotos => 'वाहनका फोटो';

  @override
  String get chartNeedsReadings =>
      'प्रवृत्ति हेर्न कम्तीमा दुई ओडोमिटर रेडिङ थप्नुहोस्।';

  @override
  String get provinceKoshi => 'कोशी';

  @override
  String get provinceMadhesh => 'मधेश';

  @override
  String get provinceBagmati => 'बागमती';

  @override
  String get provinceGandaki => 'गण्डकी';

  @override
  String get provinceLumbini => 'लुम्बिनी';

  @override
  String get provinceKarnali => 'कर्णाली';

  @override
  String get provinceSudurpashchim => 'सुदूरपश्चिम';

  @override
  String get fuelPetrol => 'पेट्रोल';

  @override
  String get fuelDiesel => 'डिजेल';

  @override
  String get fuelElectric => 'इलेक्ट्रिक';

  @override
  String get fuelHybrid => 'हाइब्रिड';

  @override
  String get fuelCng => 'CNG';

  @override
  String get transmissionManual => 'म्यानुअल';

  @override
  String get transmissionAutomatic => 'अटोमेटिक';

  @override
  String get transmissionAmt => 'AMT';

  @override
  String get transmissionCvt => 'CVT';

  @override
  String get colourHint => 'कालो';

  @override
  String get splashTagline => 'प्रमाण, वाचा होइन।';

  @override
  String get splashDemoNote => 'डेमो संस्करण · डाटा यही डिभाइसमा रहन्छ';

  @override
  String documentedPercent(int percent) {
    return '$percent% दस्तावेजीकृत';
  }

  @override
  String get snapshotFreezeNote =>
      'यो स्न्यापसटले आजको डाटा स्थिर गर्छ। पछिका सम्पादनले यो रिपोर्ट परिवर्तन गर्दैनन्।';

  @override
  String get demoOtpNote => 'डेमो OTP: १२३४५६ · जुनसुकै ६ अंक मान्य हुन्छ।';

  @override
  String get otpCodeLabel => '६-अंकीय कोड';

  @override
  String get remindersIntro =>
      'मालिकले राखेका मिति र ओडोमिटर लक्ष्य। आधिकारिक जरिवाना अनुमान गरिँदैन।';

  @override
  String get noLongGapsNote => 'रेकर्डबीच १२० दिनभन्दा लामो खाडल छैन।';

  @override
  String get ownerRecordedLocalNote =>
      'मालिकद्वारा अभिलेखित इतिहास। प्रमाण यही डिभाइसमा रहन्छ र रजिस्ट्रीबाट प्रमाणित होइन।';

  @override
  String get dossierDisclaimer =>
      'मालिकद्वारा अभिलेखित इतिहास। प्रमाण रजिस्ट्रीबाट प्रमाणित होइन। खाडल भन्नाले अभिलेख साझा नगरिएको मात्र हो, केही नभएको होइन।';

  @override
  String get compareTitle => 'रिपोर्ट तुलना';

  @override
  String get compareSubtitle => 'दुई सुरक्षित स्न्यापसट, छेउछाउमा।';

  @override
  String get savedReportsHint =>
      'रिपोर्ट खोल्नुहोस्, वा तुलना गर्न दुई छान्नुहोस्।';

  @override
  String get compareSelectTwo => 'तुलना गर्न दुई सुरक्षित रिपोर्ट छान्नुहोस्।';

  @override
  String get compareNeutralNote =>
      'यो तथ्यगत तुलनात्मक दृश्य हो। पूर्णता चेकलिस्टको गणना हो, श्रेणी होइन।';

  @override
  String get metricCompletion => 'पूर्णता';

  @override
  String get metricRecords => 'रेकर्ड';

  @override
  String get metricEvidence => 'प्रमाण फाइल';

  @override
  String get metricLatestKm => 'पछिल्लो ओडोमिटर';

  @override
  String get metricAvgKmMonth => 'औसत किमी/महिना';

  @override
  String get metricOdometerFlags => 'ओडोमिटर चेतावनी';

  @override
  String get metricGaps => 'खाडल';

  @override
  String get metricFirstRecord => 'पहिलो रेकर्ड';

  @override
  String get browseTitle => 'बजार';

  @override
  String get browseSubtitle =>
      'मालिकले अभिलेख गरेको इतिहाससहितका दोस्रो हातका वाहन। विज्ञापन खोलेर रिपोर्ट हेर्नुहोस्।';

  @override
  String get demoListingsNote =>
      'डेमो सूची — विक्रेता, मूल्य र स्थान काल्पनिक हुन्। प्रत्येकले यही यन्त्रको स्थिर स्न्यापसट खोल्छ।';

  @override
  String get noListingsTitle => 'कुनै सूची उपलब्ध छैन';

  @override
  String get noListingsBody =>
      'नमुना सूची फर्काउन सेटिङमा डेमो डाटा रिसेट गर्नुहोस्।';

  @override
  String listedAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिनअघि सूचीबद्ध',
      one: '१ दिनअघि सूचीबद्ध',
    );
    return '$_temp0';
  }

  @override
  String get demoListingBadge => 'डेमो';

  @override
  String get vehicleHistory => 'वाहन इतिहास';

  @override
  String get historyAtAGlance => 'एक नजरमा इतिहास';

  @override
  String get glanceChecklist => 'चेकलिस्ट';

  @override
  String get glanceRecords => 'रेकर्ड';

  @override
  String get glanceEvidence => 'प्रमाण';

  @override
  String get glanceOdometer => 'ओडोमिटर जाँच';

  @override
  String get glanceGaps => 'रेकर्ड खाडल';

  @override
  String get glanceOwnership => 'स्वामित्व प्रविष्टि';

  @override
  String get glanceNoIssues => 'समस्या भेटिएन';

  @override
  String get glanceNoGaps => 'लामो खाडल छैन';

  @override
  String glanceFlags(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count रिडिङ चेतावनी',
      one: '१ रिडिङ चेतावनी',
    );
    return '$_temp0';
  }

  @override
  String glanceGapsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '१२० दिनभन्दा लामो $count खाडल',
      one: '१२० दिनभन्दा लामो १ खाडल',
    );
    return '$_temp0';
  }

  @override
  String get glanceOwnershipSub => 'मालिकको अभिलेखअनुसार';

  @override
  String get glanceComputedNote =>
      'गणना यही स्थिर स्न्यापसटबाट गरिएको हो। नदेखिएको प्रविष्टि भन्नाले अभिलेख साझा नगरिएको हो।';

  @override
  String reportHeroListedBy(String name) {
    return '$name द्वारा सूचीबद्ध';
  }

  @override
  String documentedOf(int filled, int total) {
    return '$filled/$total दस्तावेजीकृत';
  }
}
