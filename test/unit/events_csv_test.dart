import 'package:csv/csv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trusttrail/domain/events_csv.dart';

void main() {
  test('writes header and chronological event rows', () {
    final csv = eventsCsv([
      const EventCsvEntry(
        id: 'ev-1',
        type: 'record_saved',
        at: '2026-11-25T09:15:00.000Z',
        metaJson: '{"vehicleId":"veh-shine","category":"service"}',
      ),
      const EventCsvEntry(
        id: 'ev-2',
        type: 'report_shared',
        at: '2026-11-25T09:17:30.000Z',
      ),
    ]);

    final rows = Csv().decode(csv);
    expect(rows.first, eventsCsvHeader);
    expect(rows[1], [
      'ev-1',
      'record_saved',
      '2026-11-25T09:15:00.000Z',
      '{"vehicleId":"veh-shine","category":"service"}',
    ]);
    expect(rows[2], ['ev-2', 'report_shared', '2026-11-25T09:17:30.000Z', '']);
  });
}
