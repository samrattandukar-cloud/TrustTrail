/// The ten documented sections behind the completion meter.
///
/// This is deliberately a count, not a score: it never infers trust from
/// missing data.
enum CompletenessSection {
  bluebook,
  ownership,
  insurance,
  roadTax,
  pollution,
  services,
  odometer,
  engineNumber,
  chassisNumber,
  photos,
}

class CompletenessInput {
  const CompletenessInput({
    this.hasBluebook = false,
    this.hasOwnershipRecord = false,
    this.hasInsurance = false,
    this.hasRoadTax = false,
    this.hasPollution = false,
    this.serviceRecordCount = 0,
    this.odometerReadingCount = 0,
    this.hasEngineNumber = false,
    this.hasChassisNumber = false,
    this.photoCount = 0,
  });

  final bool hasBluebook;
  final bool hasOwnershipRecord;
  final bool hasInsurance;
  final bool hasRoadTax;
  final bool hasPollution;
  final int serviceRecordCount;
  final int odometerReadingCount;
  final bool hasEngineNumber;
  final bool hasChassisNumber;
  final int photoCount;
}

class SectionState {
  const SectionState(this.section, this.filled);

  final CompletenessSection section;
  final bool filled;
}

class CompletenessReport {
  const CompletenessReport(this.sections);

  final List<SectionState> sections;

  int get filled => sections.where((state) => state.filled).length;

  int get total => sections.length;

  int get percent => total == 0 ? 0 : ((filled * 100) / total).round();

  bool get isComplete => filled == total;

  List<CompletenessSection> get missing => sections
      .where((state) => !state.filled)
      .map((state) => state.section)
      .toList();

  bool isFilled(CompletenessSection section) =>
      sections.any((state) => state.section == section && state.filled);
}

CompletenessReport computeCompleteness(CompletenessInput input) {
  return CompletenessReport([
    SectionState(CompletenessSection.bluebook, input.hasBluebook),
    SectionState(CompletenessSection.ownership, input.hasOwnershipRecord),
    SectionState(CompletenessSection.insurance, input.hasInsurance),
    SectionState(CompletenessSection.roadTax, input.hasRoadTax),
    SectionState(CompletenessSection.pollution, input.hasPollution),
    SectionState(CompletenessSection.services, input.serviceRecordCount >= 3),
    SectionState(CompletenessSection.odometer, input.odometerReadingCount >= 3),
    SectionState(CompletenessSection.engineNumber, input.hasEngineNumber),
    SectionState(CompletenessSection.chassisNumber, input.hasChassisNumber),
    SectionState(CompletenessSection.photos, input.photoCount > 0),
  ]);
}

/// "roadTax" -> "Road tax"; used anywhere a section name is shown as prose.
String completenessLabel(String raw) {
  final spaced = raw
      .replaceAll('_', ' ')
      .replaceAllMapped(RegExp('([a-z0-9])([A-Z])'), (m) => '${m[1]} ${m[2]}');
  final words = spaced.split(' ').where((word) => word.isNotEmpty).toList();
  if (words.isEmpty) return raw;
  final first = words.first[0].toUpperCase() + words.first.substring(1);
  return [first, ...words.skip(1).map((word) => word.toLowerCase())].join(' ');
}
