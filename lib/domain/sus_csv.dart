import 'package:csv/csv.dart';

const susCsvHeader = [
  'participant_code',
  'role',
  'submitted_at',
  'sus_score',
  'answers',
  'comment',
];

/// One SUS response flattened into export columns.
class SusCsvEntry {
  const SusCsvEntry({
    required this.participantCode,
    required this.role,
    required this.submittedAt,
    required this.score,
    required this.answers,
    this.comment,
  });

  final String participantCode;
  final String role;
  final DateTime submittedAt;
  final double score;
  final List<int> answers;
  final String? comment;
}

String susCsv(List<SusCsvEntry> entries) {
  final rows = <List<Object?>>[
    susCsvHeader,
    for (final entry in entries)
      [
        entry.participantCode,
        entry.role,
        entry.submittedAt.toIso8601String(),
        entry.score.toStringAsFixed(2),
        entry.answers.join(' '),
        entry.comment ?? '',
      ],
  ];
  return Csv().encode(rows);
}
