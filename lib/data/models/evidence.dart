enum EvidenceKind {
  bill,
  paymentSlip,
  bluebook,
  policy,
  photo,
  pdf;

  static EvidenceKind parse(Object? value) => values.firstWhere(
    (kind) => kind.name == value,
    orElse: () => EvidenceKind.bill,
  );
}

class Evidence {
  const Evidence({
    required this.id,
    required this.recordId,
    required this.kind,
    required this.filePath,
    this.thumbPath,
    this.mime = 'image/jpeg',
    this.width,
    this.height,
    this.sizeBytes = 0,
    this.label,
    required this.createdAt,
  });

  final String id;
  final String recordId;
  final EvidenceKind kind;

  /// Absolute path, or an `asset:` URI for bundled demo evidence.
  final String filePath;
  final String? thumbPath;
  final String mime;
  final int? width;
  final int? height;
  final int sizeBytes;
  final String? label;
  final DateTime createdAt;

  bool get isAsset => filePath.startsWith('asset:');

  String get assetPath => filePath.substring('asset:'.length);

  bool get isPdf => kind == EvidenceKind.pdf || mime == 'application/pdf';

  Map<String, Object?> toMap() => {
    'id': id,
    'record_id': recordId,
    'kind': kind.name,
    'file_path': filePath,
    'thumb_path': thumbPath,
    'mime': mime,
    'width': width,
    'height': height,
    'size_bytes': sizeBytes,
    'label': label,
    'created_at': createdAt.toIso8601String(),
  };

  factory Evidence.fromMap(Map<String, Object?> map) => Evidence(
    id: map['id'] as String,
    recordId: map['record_id'] as String,
    kind: EvidenceKind.parse(map['kind']),
    filePath: map['file_path'] as String,
    thumbPath: map['thumb_path'] as String?,
    mime: map['mime'] as String? ?? 'image/jpeg',
    width: map['width'] as int?,
    height: map['height'] as int?,
    sizeBytes: map['size_bytes'] as int? ?? 0,
    label: map['label'] as String?,
    createdAt: DateTime.parse(map['created_at'] as String),
  );
}
