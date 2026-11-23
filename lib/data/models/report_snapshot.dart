class ReportSnapshot {
  const ReportSnapshot({
    required this.id,
    required this.vehicleId,
    required this.token,
    required this.createdAt,
    required this.payloadJson,
    this.includeCosts = true,
    this.includeEvidence = true,
    this.pdfPath,
  });

  final String id;
  final String vehicleId;
  final String token;
  final DateTime createdAt;
  final String payloadJson;
  final bool includeCosts;
  final bool includeEvidence;
  final String? pdfPath;

  Map<String, Object?> toMap() => {
    'id': id,
    'vehicle_id': vehicleId,
    'token': token,
    'created_at': createdAt.toIso8601String(),
    'payload_json': payloadJson,
    'include_costs': includeCosts ? 1 : 0,
    'include_evidence': includeEvidence ? 1 : 0,
    'pdf_path': pdfPath,
  };

  factory ReportSnapshot.fromMap(Map<String, Object?> map) => ReportSnapshot(
    id: map['id'] as String,
    vehicleId: map['vehicle_id'] as String,
    token: map['token'] as String,
    createdAt: DateTime.parse(map['created_at'] as String),
    payloadJson: map['payload_json'] as String,
    includeCosts: (map['include_costs'] as int? ?? 1) == 1,
    includeEvidence: (map['include_evidence'] as int? ?? 1) == 1,
    pdfPath: map['pdf_path'] as String?,
  );
}

class SavedReport {
  const SavedReport({
    required this.id,
    required this.token,
    required this.snapshotJson,
    required this.savedAt,
  });

  final String id;
  final String token;
  final String snapshotJson;
  final DateTime savedAt;

  Map<String, Object?> toMap() => {
    'id': id,
    'token': token,
    'snapshot_json': snapshotJson,
    'saved_at': savedAt.toIso8601String(),
  };

  factory SavedReport.fromMap(Map<String, Object?> map) => SavedReport(
    id: map['id'] as String,
    token: map['token'] as String,
    snapshotJson: map['snapshot_json'] as String,
    savedAt: DateTime.parse(map['saved_at'] as String),
  );
}
