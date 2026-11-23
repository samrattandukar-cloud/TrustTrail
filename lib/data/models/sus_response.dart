class SusResponse {
  const SusResponse({
    required this.id,
    required this.participantCode,
    required this.role,
    required this.answers,
    required this.susScore,
    this.comment,
    required this.createdAt,
  });

  final String id;
  final String participantCode;
  final String role;
  final List<int> answers;
  final double susScore;
  final String? comment;
  final DateTime createdAt;

  Map<String, Object?> toMap() => {
    'id': id,
    'participant_code': participantCode,
    'role': role,
    'answers_json': answers.join(','),
    'sus_score': susScore,
    'comment': comment,
    'created_at': createdAt.toIso8601String(),
  };

  factory SusResponse.fromMap(Map<String, Object?> map) => SusResponse(
    id: map['id'] as String,
    participantCode: map['participant_code'] as String,
    role: map['role'] as String,
    answers: (map['answers_json'] as String? ?? '')
        .split(',')
        .where((value) => value.isNotEmpty)
        .map(int.parse)
        .toList(),
    susScore: (map['sus_score'] as num).toDouble(),
    comment: map['comment'] as String?,
    createdAt: DateTime.parse(map['created_at'] as String),
  );
}
