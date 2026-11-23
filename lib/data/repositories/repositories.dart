import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../local/app_database.dart';
import 'auth_repository.dart';
import 'event_repository.dart';
import 'evidence_repository.dart';
import 'feedback_repository.dart';
import 'record_repository.dart';
import 'reminder_repository.dart';
import 'report_repository.dart';
import 'vehicle_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(databaseProvider).db),
);

final vehicleRepositoryProvider = Provider<VehicleRepository>(
  (ref) => VehicleRepository(ref.watch(databaseProvider).db),
);

final recordRepositoryProvider = Provider<RecordRepository>(
  (ref) => RecordRepository(ref.watch(databaseProvider).db),
);

final evidenceRepositoryProvider = Provider<EvidenceRepository>(
  (ref) => EvidenceRepository(ref.watch(databaseProvider).db),
);

final reminderRepositoryProvider = Provider<ReminderRepository>(
  (ref) => ReminderRepository(ref.watch(databaseProvider).db),
);

final reportRepositoryProvider = Provider<ReportRepository>(
  (ref) => ReportRepository(ref.watch(databaseProvider).db),
);

final feedbackRepositoryProvider = Provider<FeedbackRepository>(
  (ref) => FeedbackRepository(ref.watch(databaseProvider).db),
);

final eventRepositoryProvider = Provider<EventRepository>(
  (ref) => EventRepository(ref.watch(databaseProvider).db),
);
