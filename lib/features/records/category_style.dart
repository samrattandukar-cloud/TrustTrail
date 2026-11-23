import 'package:flutter/material.dart';

import '../../core/l10n/app_localizations.dart';
import '../../data/models/vehicle_record.dart';

extension RecordCategoryUi on RecordCategory {
  String label(AppLocalizations l10n) => switch (this) {
    RecordCategory.service => l10n.categoryService,
    RecordCategory.insurance => l10n.categoryInsurance,
    RecordCategory.tax => l10n.categoryTax,
    RecordCategory.repair => l10n.categoryRepair,
    RecordCategory.ownership => l10n.categoryOwnership,
    RecordCategory.inspection => l10n.categoryInspection,
    RecordCategory.pollution => l10n.categoryPollution,
    RecordCategory.fuel => l10n.categoryFuel,
  };

  IconData get icon => switch (this) {
    RecordCategory.service => Icons.build_circle_outlined,
    RecordCategory.insurance => Icons.shield_outlined,
    RecordCategory.tax => Icons.receipt_long_outlined,
    RecordCategory.repair => Icons.car_repair_outlined,
    RecordCategory.ownership => Icons.key_outlined,
    RecordCategory.inspection => Icons.fact_check_outlined,
    RecordCategory.pollution => Icons.eco_outlined,
    RecordCategory.fuel => Icons.local_gas_station_outlined,
  };
}

String categoryLabel(String raw, AppLocalizations l10n) {
  for (final category in RecordCategory.values) {
    if (category.name == raw) return category.label(l10n);
  }
  return raw;
}
