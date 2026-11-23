enum RecordCategory {
  service,
  insurance,
  tax,
  repair,
  ownership,
  inspection,
  pollution,
  fuel;

  static RecordCategory parse(Object? value) => values.firstWhere(
    (category) => category.name == value,
    orElse: () => RecordCategory.service,
  );
}

enum RecordSource {
  ownerRecorded,
  workshopReceipt,
  officialDocument;

  static RecordSource parse(Object? value) => values.firstWhere(
    (source) => source.name == value,
    orElse: () => RecordSource.ownerRecorded,
  );
}

class VehicleRecord {
  const VehicleRecord({
    required this.id,
    required this.vehicleId,
    required this.category,
    required this.title,
    this.description,
    required this.eventDate,
    this.odometerKm,
    this.workshop,
    this.costNpr,
    this.documentNo,
    this.source = RecordSource.ownerRecorded,
    required this.createdAt,
    this.isSeed = false,
  });

  final String id;
  final String vehicleId;
  final RecordCategory category;
  final String title;
  final String? description;
  final DateTime eventDate;
  final int? odometerKm;
  final String? workshop;
  final int? costNpr;
  final String? documentNo;
  final RecordSource source;
  final DateTime createdAt;
  final bool isSeed;

  String get eventDateIso =>
      '${eventDate.year.toString().padLeft(4, '0')}-'
      '${eventDate.month.toString().padLeft(2, '0')}-'
      '${eventDate.day.toString().padLeft(2, '0')}';

  Map<String, Object?> toMap() => {
    'id': id,
    'vehicle_id': vehicleId,
    'category': category.name,
    'title': title,
    'description': description,
    'event_date': eventDateIso,
    'odometer_km': odometerKm,
    'workshop': workshop,
    'cost_npr': costNpr,
    'document_no': documentNo,
    'source': source.name,
    'created_at': createdAt.toIso8601String(),
    'is_seed': isSeed ? 1 : 0,
  };

  factory VehicleRecord.fromMap(Map<String, Object?> map) => VehicleRecord(
    id: map['id'] as String,
    vehicleId: map['vehicle_id'] as String,
    category: RecordCategory.parse(map['category']),
    title: map['title'] as String,
    description: map['description'] as String?,
    eventDate: DateTime.parse(map['event_date'] as String),
    odometerKm: map['odometer_km'] as int?,
    workshop: map['workshop'] as String?,
    costNpr: map['cost_npr'] as int?,
    documentNo: map['document_no'] as String?,
    source: RecordSource.parse(map['source']),
    createdAt: DateTime.parse(map['created_at'] as String),
    isSeed: (map['is_seed'] as int? ?? 0) == 1,
  );

  VehicleRecord copyWith({
    RecordCategory? category,
    String? title,
    String? description,
    DateTime? eventDate,
    int? odometerKm,
    String? workshop,
    int? costNpr,
    String? documentNo,
    RecordSource? source,
  }) => VehicleRecord(
    id: id,
    vehicleId: vehicleId,
    category: category ?? this.category,
    title: title ?? this.title,
    description: description ?? this.description,
    eventDate: eventDate ?? this.eventDate,
    odometerKm: odometerKm ?? this.odometerKm,
    workshop: workshop ?? this.workshop,
    costNpr: costNpr ?? this.costNpr,
    documentNo: documentNo ?? this.documentNo,
    source: source ?? this.source,
    createdAt: createdAt,
    isSeed: isSeed,
  );
}
