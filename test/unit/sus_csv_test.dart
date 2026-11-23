import 'package:csv/csv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trusttrail/domain/sus_csv.dart';

void main() {
  test('writes the header and one row per response', () {
    final csv = susCsv([
      SusCsvEntry(
        participantCode: 'P01',
        role: 'owner',
        submittedAt: DateTime.utc(2026, 11, 22, 10, 30),
        score: 82.5,
        answers: const [5, 1, 4, 2, 5, 1, 4, 2, 4, 1],
        comment: 'Clear timeline',
      ),
    ]);
    final rows = Csv().decode(csv);

    expect(rows.first, susCsvHeader);
    expect(rows[1][0], 'P01');
    expect(rows[1][1], 'owner');
    expect(rows[1][2], '2026-11-22T10:30:00.000Z');
    expect(rows[1][3], '82.50');
    expect(rows[1][4], '5 1 4 2 5 1 4 2 4 1');
    expect(rows[1][5], 'Clear timeline');
  });

  test('escapes commas, quotes and newlines in comments', () {
    const tricky = 'Good, but "gaps" are\nconfusing';
    final csv = susCsv([
      SusCsvEntry(
        participantCode: 'P02',
        role: 'buyer',
        submittedAt: DateTime.utc(2026, 11, 22),
        score: 60,
        answers: const [3, 2, 3, 2, 3, 2, 3, 2, 3, 2],
        comment: tricky,
      ),
    ]);
    final rows = Csv().decode(csv);

    expect(rows[1][5], tricky);
  });

  test('leaves the comment column empty when none was given', () {
    final csv = susCsv([
      SusCsvEntry(
        participantCode: 'P03',
        role: 'owner',
        submittedAt: DateTime.utc(2026),
        score: 97.5,
        answers: const [5, 1, 5, 1, 5, 1, 5, 1, 5, 1],
      ),
    ]);
    final rows = Csv().decode(csv);

    expect(rows[1][5], '');
    expect(rows[1][3], '97.50');
  });
}
