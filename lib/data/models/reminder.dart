import '../../domain/reminder_engine.dart';

enum ReminderState {
  due,
  snoozed,
  done;

  static ReminderState parse(Object? value) => values.firstWhere(
    (state) => state.name == value,
    orElse: () => ReminderState.due,
  );
}

class Reminder {
  const Reminder({
    required this.id,
    required this.vehicleId,
    required this.type,
    required this.title,
    required this.dueDate,
    this.targetOdometer,
    this.state = ReminderState.due,
    this.notes,
  });

  final String id;
  final String vehicleId;
  final ReminderType type;
  final String title;
  final DateTime dueDate;
  final int? targetOdometer;
  final ReminderState state;
  final String? notes;

  bool get isDone => state == ReminderState.done;

  Map<String, Object?> toMap() => {
    'id': id,
    'vehicle_id': vehicleId,
    'type': type.name,
    'title': title,
    'due_date': dueDate.toIso8601String().substring(0, 10),
    'target_odometer': targetOdometer,
    'status': state.name,
    'notes': notes,
  };

  factory Reminder.fromMap(Map<String, Object?> map) => Reminder(
    id: map['id'] as String,
    vehicleId: map['vehicle_id'] as String,
    type: ReminderType.values.firstWhere(
      (type) => type.name == map['type'],
      orElse: () => ReminderType.insurance,
    ),
    title: map['title'] as String,
    dueDate: DateTime.parse(map['due_date'] as String),
    targetOdometer: map['target_odometer'] as int?,
    state: ReminderState.parse(map['status']),
    notes: map['notes'] as String?,
  );

  Reminder copyWith({
    ReminderState? state,
    DateTime? dueDate,
    int? targetOdometer,
  }) => Reminder(
    id: id,
    vehicleId: vehicleId,
    type: type,
    title: title,
    dueDate: dueDate ?? this.dueDate,
    targetOdometer: targetOdometer ?? this.targetOdometer,
    state: state ?? this.state,
    notes: notes,
  );
}
