import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../core/utils/token_codec.dart';
import '../models/evidence.dart';
import '../models/report_snapshot.dart';
import '../models/vehicle.dart';
import '../models/vehicle_record.dart';
import 'report_payload_builder.dart';

class ReportMatch {
  const ReportMatch({required this.snapshot, required this.vehicle});

  final ReportSnapshot snapshot;
  final Vehicle vehicle;

  Map<String, Object?> get payload =>
      jsonDecode(snapshot.payloadJson) as Map<String, Object?>;
}

class ReportRepository {
  ReportRepository(this._db);

  final Database _db;

  Future<ReportSnapshot> create({
    required Vehicle vehicle,
    required List<VehicleRecord> records,
    required List<Evidence> evidence,
    bool includeCosts = true,
    bool includeEvidence = true,
    String? token,
  }) async {
    final reportToken = token ?? await _uniqueToken();
    final now = DateTime.now();
    final payload = buildReportPayload(
      token: reportToken,
      vehicle: vehicle,
      records: records,
      evidence: evidence,
      generatedAt: now,
      includeCosts: includeCosts,
      includeEvidence: includeEvidence,
    );
    final snapshot = ReportSnapshot(
      id: const Uuid().v4(),
      vehicleId: vehicle.id,
      token: reportToken,
      createdAt: now,
      payloadJson: jsonEncode(payload),
      includeCosts: includeCosts,
      includeEvidence: includeEvidence,
    );
    await _db.insert('report_snapshots', snapshot.toMap());
    return snapshot;
  }

  Future<ReportSnapshot?> getByToken(String token) async {
    final rows = await _db.query(
      'report_snapshots',
      where: 'token = ?',
      whereArgs: [token],
      limit: 1,
    );
    return rows.isEmpty ? null : ReportSnapshot.fromMap(rows.first);
  }

  Future<ReportSnapshot?> latestForVehicle(String vehicleId) async {
    final rows = await _db.query(
      'report_snapshots',
      where: 'vehicle_id = ?',
      whereArgs: [vehicleId],
      orderBy: 'created_at DESC',
      limit: 1,
    );
    return rows.isEmpty ? null : ReportSnapshot.fromMap(rows.first);
  }

  Future<List<ReportSnapshot>> listForVehicle(String vehicleId) async {
    final rows = await _db.query(
      'report_snapshots',
      where: 'vehicle_id = ?',
      whereArgs: [vehicleId],
      orderBy: 'created_at DESC',
    );
    return rows.map(ReportSnapshot.fromMap).toList();
  }

  /// Resolves a typed code, QR URI or plate against the local snapshots.
  /// Tokens only point at a frozen payload; they are never a registry claim.
  Future<ReportMatch?> search(String input) async {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return null;

    final code = TokenCodec.compact(trimmed);
    final plate = _plateKey(trimmed);

    final snapshotRows = await _db.query(
      'report_snapshots',
      orderBy: 'created_at DESC',
    );
    if (snapshotRows.isEmpty) return null;

    final vehicleRows = await _db.query('vehicles');
    final vehicles = {
      for (final row in vehicleRows) row['id'] as String: Vehicle.fromMap(row),
    };

    for (final row in snapshotRows) {
      final snapshot = ReportSnapshot.fromMap(row);
      final vehicle = vehicles[snapshot.vehicleId];
      if (vehicle == null) continue;
      final tokenMatches =
          code.isNotEmpty && TokenCodec.compact(snapshot.token) == code;
      final plateMatches =
          plate.length >= 4 && _plateKey(vehicle.plateRoman) == plate;
      if (tokenMatches || plateMatches) {
        return ReportMatch(snapshot: snapshot, vehicle: vehicle);
      }
    }
    return null;
  }

  Future<void> updatePdfPath(String id, String? path) async {
    await _db.update(
      'report_snapshots',
      {'pdf_path': path},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> saveReport(String token) async {
    final snapshot = await getByToken(token);
    if (snapshot == null) throw StateError('Unknown report $token');
    await _db.insert('saved_reports', {
      'id': const Uuid().v4(),
      'token': snapshot.token,
      'snapshot_json': snapshot.payloadJson,
      'saved_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeSaved(String token) async {
    await _db.delete('saved_reports', where: 'token = ?', whereArgs: [token]);
  }

  Future<bool> isSaved(String token) async {
    final rows = await _db.query(
      'saved_reports',
      where: 'token = ?',
      whereArgs: [token],
      limit: 1,
    );
    return rows.isNotEmpty;
  }

  Future<List<SavedReport>> savedReports() async {
    final rows = await _db.query('saved_reports', orderBy: 'saved_at DESC');
    return rows.map(SavedReport.fromMap).toList();
  }

  Future<String> _uniqueToken() async {
    for (var attempt = 0; attempt < 8; attempt++) {
      final token = TokenCodec.generate();
      if (await getByToken(token) == null) return token;
    }
    throw StateError('Could not allocate a unique report token');
  }

  static String _plateKey(String value) =>
      value.replaceAll(RegExp(r'[^A-Za-z0-9]'), '').toUpperCase();
}
