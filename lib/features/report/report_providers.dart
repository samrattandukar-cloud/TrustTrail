import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/utils/bs_date.dart';
import '../../core/utils/token_codec.dart';
import '../../data/models/report_snapshot.dart';
import '../../data/repositories/report_repository.dart';
import '../../data/repositories/repositories.dart';
import 'report_pdf_builder.dart';

final reportMatchProvider = FutureProvider.autoDispose
    .family<ReportMatch?, String>((ref, token) {
      return ref.watch(reportRepositoryProvider).search(token);
    });

final reportSavedProvider = FutureProvider.autoDispose.family<bool, String>((
  ref,
  token,
) {
  return ref.watch(reportRepositoryProvider).isSaved(token);
});

class SavedReportSummary {
  const SavedReportSummary({
    required this.token,
    required this.vehicleName,
    required this.plate,
    required this.savedAt,
    required this.filled,
    required this.total,
  });

  final String token;
  final String vehicleName;
  final String plate;
  final DateTime savedAt;
  final int filled;
  final int total;
}

final savedReportsProvider =
    FutureProvider.autoDispose<List<SavedReportSummary>>((ref) async {
      final rows = await ref.watch(reportRepositoryProvider).savedReports();
      return [for (final row in rows) ?_parseSavedReport(row)];
    });

SavedReportSummary? _parseSavedReport(SavedReport row) {
  try {
    final payload = jsonDecode(row.snapshotJson) as Map<String, dynamic>;
    final vehicle = (payload['vehicle'] as Map).cast<String, Object?>();
    final completeness = (payload['completeness'] as Map)
        .cast<String, Object?>();
    return SavedReportSummary(
      token: row.token,
      vehicleName: '${vehicle['make']} ${vehicle['model']}',
      plate: vehicle['plate_roman'] as String? ?? '—',
      savedAt: row.savedAt,
      filled: completeness['filled'] as int? ?? 0,
      total: completeness['total'] as int? ?? 10,
    );
  } catch (_) {
    return null;
  }
}

abstract final class ReportExporter {
  static String qrUri(String token) =>
      'trusttrail://r/${TokenCodec.compact(token)}';

  static String summaryText(ReportMatch match) {
    final vehicle = (match.payload['vehicle'] as Map).cast<String, Object?>();
    final completeness = (match.payload['completeness'] as Map)
        .cast<String, Object?>();
    return '${vehicle['make']} ${vehicle['model']} · ${vehicle['plate_roman']}\n'
        'TrustTrail report ${match.snapshot.token}\n'
        '${completeness['filled']}/${completeness['total']} sections documented · '
        '${vehicle['latestKm']} km\n'
        'Owner-recorded history. Completion meter, not a trust score.\n'
        'Open in TrustTrail: ${qrUri(match.snapshot.token)}';
  }

  static Future<Uint8List> build(ReportMatch match) =>
      ReportPdfBuilder.build(match);

  static Future<File> save(WidgetRef ref, ReportMatch match) async {
    final bytes = await build(match);
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, 'reports'));
    await dir.create(recursive: true);
    final file = File(p.join(dir.path, '${match.snapshot.token}.pdf'));
    await file.writeAsBytes(bytes, flush: true);
    await ref
        .read(reportRepositoryProvider)
        .updatePdfPath(match.snapshot.id, file.path);
    return file;
  }

  static Future<void> sharePdf(WidgetRef ref, ReportMatch match) async {
    final bytes = await build(match);
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, 'reports'));
    await dir.create(recursive: true);
    final file = File(p.join(dir.path, '${match.snapshot.token}.pdf'));
    await file.writeAsBytes(bytes, flush: true);
    await ref
        .read(reportRepositoryProvider)
        .updatePdfPath(match.snapshot.id, file.path);
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'TrustTrail-${match.snapshot.token}.pdf',
    );
  }

  static Future<void> shareText(ReportMatch match) async {
    await SharePlus.instance.share(ShareParams(text: summaryText(match)));
  }

  static String dates(ReportMatch match) {
    final generated =
        DateTime.tryParse(match.payload['generatedAt'] as String? ?? '') ??
        match.snapshot.createdAt;
    return BsDate.both(generated);
  }
}
