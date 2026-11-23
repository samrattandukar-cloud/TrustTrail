import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/evidence.dart';
import '../../data/models/vehicle_record.dart';
import '../../data/repositories/repositories.dart';

class RecordDetail {
  const RecordDetail({required this.record, required this.evidence});

  final VehicleRecord record;
  final List<Evidence> evidence;
}

final recordDetailProvider = FutureProvider.autoDispose
    .family<RecordDetail?, String>((ref, id) async {
      final record = await ref.watch(recordRepositoryProvider).getById(id);
      if (record == null) return null;
      final evidence = await ref
          .watch(evidenceRepositoryProvider)
          .listForRecord(id);
      return RecordDetail(record: record, evidence: evidence);
    });
