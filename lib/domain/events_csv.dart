import 'package:csv/csv.dart';

const eventsCsvHeader = ['id', 'type', 'at', 'meta_json'];

/// One offline usability event flattened into CSV export columns.
class EventCsvEntry {
  const EventCsvEntry({
    required this.id,
    required this.type,
    required this.at,
    this.metaJson,
  });

  final String id;
  final String type;
  final String at;
  final String? metaJson;
}

String eventsCsv(List<EventCsvEntry> entries) {
  final rows = <List<Object?>>[
    eventsCsvHeader,
    for (final entry in entries)
      [entry.id, entry.type, entry.at, entry.metaJson ?? ''],
  ];
  return Csv().encode(rows);
}
