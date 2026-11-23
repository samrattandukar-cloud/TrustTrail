enum ReminderType { insurance, roadTax, pollution, service }

enum ReminderStatus { done, overdue, dueNow, dueSoon, upcoming }

class ReminderAssessment {
  const ReminderAssessment({
    required this.status,
    this.daysUntil,
    this.kmUntil,
  });

  final ReminderStatus status;
  final int? daysUntil;
  final int? kmUntil;

  bool get needsAttention =>
      status == ReminderStatus.overdue ||
      status == ReminderStatus.dueNow ||
      status == ReminderStatus.dueSoon;
}

/// Reminders are owner-set dates and odometer targets. Nothing here invents
/// official fines or legal deadlines.
ReminderAssessment assessReminder({
  required ReminderType type,
  required DateTime dueDate,
  required bool done,
  DateTime? today,
  int? targetOdometer,
  int? currentOdometer,
  int dueSoonDays = 30,
  int dueSoonKm = 500,
}) {
  if (done) return const ReminderAssessment(status: ReminderStatus.done);

  final now = today ?? DateTime.now();
  final date = DateTime(dueDate.year, dueDate.month, dueDate.day);
  final reference = DateTime(now.year, now.month, now.day);
  final days = date.difference(reference).inDays;

  if (type == ReminderType.service &&
      targetOdometer != null &&
      currentOdometer != null) {
    final km = targetOdometer - currentOdometer;
    if (km <= 0) {
      return ReminderAssessment(
        status: ReminderStatus.dueNow,
        daysUntil: days,
        kmUntil: km,
      );
    }
    if (days < 0) {
      return ReminderAssessment(
        status: ReminderStatus.overdue,
        daysUntil: days,
        kmUntil: km,
      );
    }
    if (km <= dueSoonKm) {
      return ReminderAssessment(
        status: ReminderStatus.dueSoon,
        daysUntil: days,
        kmUntil: km,
      );
    }
    return ReminderAssessment(
      status: ReminderStatus.upcoming,
      daysUntil: days,
      kmUntil: km,
    );
  }

  if (days < 0) {
    return ReminderAssessment(status: ReminderStatus.overdue, daysUntil: days);
  }
  if (days == 0) {
    return ReminderAssessment(status: ReminderStatus.dueNow, daysUntil: 0);
  }
  if (days <= dueSoonDays) {
    return ReminderAssessment(status: ReminderStatus.dueSoon, daysUntil: days);
  }
  return ReminderAssessment(status: ReminderStatus.upcoming, daysUntil: days);
}
