import '../../core/l10n/l10n.dart';
import '../../domain/completeness.dart';

extension CompletenessSectionUi on CompletenessSection {
  String label(AppLocalizations l10n) => switch (this) {
    CompletenessSection.bluebook => l10n.sectionBluebook,
    CompletenessSection.ownership => l10n.sectionOwnership,
    CompletenessSection.insurance => l10n.categoryInsurance,
    CompletenessSection.roadTax => l10n.categoryTax,
    CompletenessSection.pollution => l10n.categoryPollution,
    CompletenessSection.services => l10n.sectionServices,
    CompletenessSection.odometer => l10n.sectionOdometer,
    CompletenessSection.engineNumber => l10n.engineNo,
    CompletenessSection.chassisNumber => l10n.chassis,
    CompletenessSection.photos => l10n.sectionPhotos,
  };
}

String sectionLabel(String raw, AppLocalizations l10n) {
  for (final section in CompletenessSection.values) {
    if (section.name == raw) return section.label(l10n);
  }
  return completenessLabel(raw);
}

String provinceLabel(String value, AppLocalizations l10n) => switch (value) {
  'Koshi' => l10n.provinceKoshi,
  'Madhesh' => l10n.provinceMadhesh,
  'Bagmati' => l10n.provinceBagmati,
  'Gandaki' => l10n.provinceGandaki,
  'Lumbini' => l10n.provinceLumbini,
  'Karnali' => l10n.provinceKarnali,
  'Sudurpashchim' => l10n.provinceSudurpashchim,
  _ => value,
};

String fuelLabel(String value, AppLocalizations l10n) => switch (value) {
  'Petrol' => l10n.fuelPetrol,
  'Diesel' => l10n.fuelDiesel,
  'Electric' => l10n.fuelElectric,
  'Hybrid' => l10n.fuelHybrid,
  'CNG' => l10n.fuelCng,
  _ => value,
};

String transmissionLabel(String value, AppLocalizations l10n) =>
    switch (value) {
      'Manual' => l10n.transmissionManual,
      'Automatic' => l10n.transmissionAutomatic,
      'AMT' => l10n.transmissionAmt,
      'CVT' => l10n.transmissionCvt,
      _ => value,
    };
