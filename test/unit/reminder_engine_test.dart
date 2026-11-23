import 'package:flutter_test/flutter_test.dart';
import 'package:trusttrail/domain/reminder_engine.dart';

void main() {
  final today = DateTime(2026, 11, 22);

  group('reminder engine', () {
    test('marks a passed date as overdue', () {
      final assessment = assessReminder(
        type: ReminderType.roadTax,
        dueDate: DateTime(2026, 11, 18),
        done: false,
        today: today,
      );
      expect(assessment.status, ReminderStatus.overdue);
      expect(assessment.daysUntil, -4);
      expect(assessment.needsAttention, isTrue);
    });

    test('marks a date within thirty days as due soon', () {
      final assessment = assessReminder(
        type: ReminderType.insurance,
        dueDate: DateTime(2026, 12, 4),
        done: false,
        today: today,
      );
      expect(assessment.status, ReminderStatus.dueSoon);
      expect(assessment.daysUntil, 12);
    });

    test('marks a distant date as upcoming', () {
      final assessment = assessReminder(
        type: ReminderType.pollution,
        dueDate: DateTime(2027, 2, 20),
        done: false,
        today: today,
      );
      expect(assessment.status, ReminderStatus.upcoming);
    });

    test('completed reminders do not ask for attention', () {
      final assessment = assessReminder(
        type: ReminderType.insurance,
        dueDate: DateTime(2026, 11, 1),
        done: true,
        today: today,
      );
      expect(assessment.status, ReminderStatus.done);
      expect(assessment.needsAttention, isFalse);
    });

    test('service reminders react to the current odometer', () {
      final passed = assessReminder(
        type: ReminderType.service,
        dueDate: DateTime(2027, 1, 1),
        done: false,
        today: today,
        targetOdometer: 18580,
        currentOdometer: 18600,
      );
      expect(passed.status, ReminderStatus.dueNow);
      expect(passed.kmUntil, -20);

      final near = assessReminder(
        type: ReminderType.service,
        dueDate: DateTime(2027, 1, 1),
        done: false,
        today: today,
        targetOdometer: 18580,
        currentOdometer: 18240,
      );
      expect(near.status, ReminderStatus.dueSoon);
      expect(near.kmUntil, 340);
    });
  });
}
