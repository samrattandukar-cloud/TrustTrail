import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/utils/bs_date.dart';
import '../../core/utils/formatters.dart';
import '../../data/repositories/report_repository.dart';
import '../../domain/completeness.dart';

/// Builds the shareable A4 dossier. The PDF intentionally uses Roman script:
/// the pdf renderer does not shape Devanagari reliably, so the app carries a
/// line pointing to the in-app Nepali view instead of shipping garbled text.
abstract final class ReportPdfBuilder {
  static Future<Uint8List> build(ReportMatch match) async {
    final payload = match.payload;
    final vehicle = (payload['vehicle'] as Map).cast<String, Object?>();
    final records = (payload['records'] as List).cast<Map<String, Object?>>();
    final completeness = (payload['completeness'] as Map)
        .cast<String, Object?>();
    final odometer = (payload['odometer'] as Map).cast<String, Object?>();
    final gaps = (odometer['gaps'] as List).cast<Map<String, Object?>>();
    final flags = (odometer['flags'] as List).cast<Map<String, Object?>>();
    final includeCosts = payload['includeCosts'] == true;
    final includeEvidence = payload['includeEvidence'] == true;
    final generatedAt =
        DateTime.tryParse(payload['generatedAt'] as String? ?? '') ??
        match.snapshot.createdAt;

    final logo = pw.MemoryImage(
      (await rootBundle.load('assets/images/trusttrail_mark.png')).buffer
          .asUint8List(),
    );
    final bodyFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Inter.ttf'),
    );
    final headingFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/PlusJakartaSans.ttf'),
    );
    final devanagariFallback = pw.Font.ttf(
      await rootBundle.load('assets/fonts/NotoSansDevanagari.ttf'),
    );

    final navy = PdfColor.fromHex('#0F2A4A');
    final primary = PdfColor.fromHex('#226B9F');
    final muted = PdfColor.fromHex('#5B6B7A');
    final border = PdfColor.fromHex('#E1E7ED');
    final surface = PdfColor.fromHex('#F4F7FA');
    final amber = PdfColor.fromHex('#B7791F');

    pw.Widget label(String text) => pw.Text(
      text.toUpperCase(),
      style: pw.TextStyle(
        fontSize: 7.5,
        letterSpacing: 1.1,
        color: muted,
        fontWeight: pw.FontWeight.bold,
      ),
    );

    final doc = pw.Document(
      title: 'TrustTrail dossier ${match.snapshot.token}',
      author: 'TrustTrail (demo build)',
      subject: 'Owner-recorded vehicle history',
      theme: pw.ThemeData.withFont(
        base: bodyFont,
        bold: headingFont,
        fontFallback: [devanagariFallback],
      ),
    );

    pw.MemoryImage? vehicleImage;
    final photoAsset = vehicle['photo_asset'] as String?;
    if (photoAsset != null) {
      try {
        final bytes = photoAsset.startsWith('asset:')
            ? (await rootBundle.load(photoAsset.substring(6))).buffer
                  .asUint8List()
            : await File(photoAsset).readAsBytes();
        vehicleImage = pw.MemoryImage(bytes);
      } catch (_) {
        vehicleImage = null;
      }
    }

    final evidenceImages = <String, pw.MemoryImage>{};
    if (includeEvidence) {
      for (final record in records) {
        final evidence = (record['evidence'] as List? ?? const [])
            .cast<Map<String, Object?>>();
        for (final item in evidence.take(1)) {
          final path = item['file_path'] as String?;
          if (path == null) continue;
          try {
            final bytes = path.startsWith('asset:')
                ? (await rootBundle.load(path.substring(6))).buffer
                      .asUint8List()
                : await File(path).readAsBytes();
            if (bytes.length > 3 * 1024 * 1024) continue;
            evidenceImages[record['id'] as String] = pw.MemoryImage(bytes);
          } catch (_) {
            continue;
          }
        }
      }
    }

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(36, 32, 36, 32),
        header: (context) => context.pageNumber == 1
            ? pw.SizedBox()
            : pw.Container(
                alignment: pw.Alignment.centerRight,
                margin: const pw.EdgeInsets.only(bottom: 12),
                child: pw.Text(
                  'TrustTrail · ${match.snapshot.token}',
                  style: pw.TextStyle(fontSize: 8, color: muted),
                ),
              ),
        footer: (context) => pw.Container(
          margin: const pw.EdgeInsets.only(top: 12),
          padding: const pw.EdgeInsets.only(top: 8),
          decoration: pw.BoxDecoration(
            border: pw.Border(top: pw.BorderSide(color: border, width: 0.6)),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Owner-recorded · not registry-verified',
                style: pw.TextStyle(fontSize: 7.5, color: muted),
              ),
              pw.Text(
                'Page ${context.pageNumber} of ${context.pagesCount}',
                style: pw.TextStyle(fontSize: 7.5, color: muted),
              ),
            ],
          ),
        ),
        build: (context) => [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: 36,
                height: 36,
                decoration: pw.BoxDecoration(
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Image(logo, fit: pw.BoxFit.cover),
              ),
              pw.SizedBox(width: 10),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'TrustTrail',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: navy,
                      ),
                    ),
                    pw.Text(
                      'Evidence-based vehicle history · demo build',
                      style: pw.TextStyle(fontSize: 8, color: muted),
                    ),
                  ],
                ),
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  label('Report token'),
                  pw.Text(
                    match.snapshot.token,
                    style: pw.TextStyle(
                      fontSize: 13,
                      fontWeight: pw.FontWeight.bold,
                      color: primary,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 18),
          pw.Container(
            padding: const pw.EdgeInsets.all(14),
            decoration: pw.BoxDecoration(
              color: surface,
              borderRadius: pw.BorderRadius.circular(10),
              border: pw.Border.all(color: border, width: 0.7),
            ),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (vehicleImage != null)
                  pw.Container(
                    width: 150,
                    height: 96,
                    margin: const pw.EdgeInsets.only(right: 14),
                    child: pw.ClipRRect(
                      horizontalRadius: 8,
                      verticalRadius: 8,
                      child: pw.Image(vehicleImage, fit: pw.BoxFit.cover),
                    ),
                  ),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        '${vehicle['make']} ${vehicle['model']}'.trim(),
                        style: pw.TextStyle(
                          fontSize: 17,
                          fontWeight: pw.FontWeight.bold,
                          color: navy,
                        ),
                      ),
                      pw.SizedBox(height: 3),
                      pw.Text(
                        vehicle['plate_roman'] as String? ?? '—',
                        style: pw.TextStyle(
                          fontSize: 11,
                          fontWeight: pw.FontWeight.bold,
                          color: primary,
                          letterSpacing: 0.8,
                        ),
                      ),
                      pw.SizedBox(height: 6),
                      pw.Text(
                        '${vehicle['year_ad']} · ${vehicle['fuel']} · '
                        '${vehicle['transmission']} · ${vehicle['province'] ?? '—'}',
                        style: pw.TextStyle(fontSize: 8.5, color: muted),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Latest odometer: ${Fmt.number(vehicle['latestKm'] as int? ?? 0)} km · '
                        '${records.length} ${records.length == 1 ? 'record' : 'records'}',
                        style: pw.TextStyle(fontSize: 8.5, color: navy),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Generated ${BsDate.both(generatedAt)}',
                        style: pw.TextStyle(fontSize: 7.5, color: muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 16),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    label('Completion meter'),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      '${completeness['filled']} of ${completeness['total']} sections documented',
                      style: pw.TextStyle(
                        fontSize: 11,
                        fontWeight: pw.FontWeight.bold,
                        color: navy,
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'Not a trust score — a count of documented sections. Evidence is owner-uploaded.',
                      style: pw.TextStyle(fontSize: 7.5, color: muted),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      'Missing: ${(completeness['missing'] as List).isEmpty ? 'none' : (completeness['missing'] as List).map((s) => completenessLabel(s as String)).join(', ')}',
                      style: pw.TextStyle(fontSize: 8, color: amber),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(width: 16),
              pw.Container(
                width: 120,
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: border, width: 0.7),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    label('Odometer'),
                    pw.SizedBox(height: 3),
                    pw.Text(
                      '${(odometer['readings'] as List).length} '
                      '${(odometer['readings'] as List).length == 1 ? 'reading' : 'readings'}',
                      style: pw.TextStyle(fontSize: 9, color: navy),
                    ),
                    if (odometer['averageKmPerMonth'] != null)
                      pw.Text(
                        '${Fmt.number(((odometer['averageKmPerMonth'] as num).round()))} km/month avg',
                        style: pw.TextStyle(fontSize: 8, color: muted),
                      ),
                    pw.Text(
                      '${gaps.length} ${gaps.length == 1 ? 'gap' : 'gaps'} · '
                      '${flags.length} ${flags.length == 1 ? 'flag' : 'flags'}',
                      style: pw.TextStyle(fontSize: 8, color: muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 16),
          label('Recorded timeline'),
          pw.SizedBox(height: 6),
          if (records.isEmpty)
            pw.Text(
              'No records have been added yet.',
              style: pw.TextStyle(fontSize: 9, color: muted),
            )
          else
            pw.Table(
              border: pw.TableBorder(
                horizontalInside: pw.BorderSide(color: border, width: 0.5),
                bottom: pw.BorderSide(color: border, width: 0.5),
                top: pw.BorderSide(color: border, width: 0.5),
              ),
              columnWidths: {
                0: const pw.FixedColumnWidth(66),
                1: const pw.FlexColumnWidth(2.4),
                2: const pw.FlexColumnWidth(2),
                3: const pw.FixedColumnWidth(52),
                if (includeCosts) 4: const pw.FixedColumnWidth(52),
              },
              children: [
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: surface),
                  children: [
                    _cell('Date', muted, bold: true),
                    _cell('Record', muted, bold: true),
                    _cell('Workshop / evidence', muted, bold: true),
                    _cell('Odometer', muted, bold: true, right: true),
                    if (includeCosts)
                      _cell('Cost', muted, bold: true, right: true),
                  ],
                ),
                for (final record in records)
                  pw.TableRow(
                    children: [
                      _cell(
                        '${BsDate.formatAd(DateTime.parse(record['event_date'] as String), pattern: 'd MMM yy')}\n'
                        '${BsDate.formatBs(DateTime.parse(record['event_date'] as String), pattern: 'd MMM yyyy')} BS',
                        muted,
                        size: 7.2,
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 4,
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              '${record['title']}',
                              style: pw.TextStyle(
                                fontSize: 8.5,
                                fontWeight: pw.FontWeight.bold,
                                color: navy,
                              ),
                            ),
                            pw.Text(
                              '${record['category']}'.toUpperCase(),
                              style: pw.TextStyle(
                                fontSize: 6.8,
                                color: primary,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 4,
                        ),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            if (evidenceImages[record['id']] != null)
                              pw.Container(
                                width: 34,
                                height: 26,
                                margin: const pw.EdgeInsets.only(right: 5),
                                child: pw.Image(
                                  evidenceImages[record['id']]!,
                                  fit: pw.BoxFit.cover,
                                ),
                              ),
                            pw.Expanded(
                              child: pw.Text(
                                (record['evidence'] as List).isEmpty
                                    ? 'No evidence attached'
                                    : '${(record['evidence'] as List).length} attached',
                                style: pw.TextStyle(
                                  fontSize: 7.2,
                                  color: muted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _cell(
                        record['odometer_km'] == null
                            ? '—'
                            : Fmt.number(record['odometer_km'] as int),
                        navy,
                        size: 7.8,
                        right: true,
                      ),
                      if (includeCosts)
                        _cell(
                          record['cost_npr'] == null
                              ? '—'
                              : 'NPR ${Fmt.number(record['cost_npr'] as int)}',
                          navy,
                          size: 7.5,
                          right: true,
                        ),
                    ],
                  ),
              ],
            ),
          if (gaps.isNotEmpty || flags.isNotEmpty) ...[
            pw.SizedBox(height: 14),
            label('Observations'),
            pw.SizedBox(height: 4),
            for (final gap in gaps)
              pw.Bullet(
                bulletColor: amber,
                style: pw.TextStyle(fontSize: 8, color: navy),
                text:
                    'No records between '
                    '${BsDate.formatAd(DateTime.parse(gap['from'] as String))} and '
                    '${BsDate.formatAd(DateTime.parse(gap['to'] as String))} '
                    '(${((gap['months'] as num).toDouble()).toStringAsFixed(1)} months).',
              ),
            for (final flag in flags)
              pw.Bullet(
                bulletColor: PdfColor.fromHex('#C93B3B'),
                style: pw.TextStyle(fontSize: 8, color: navy),
                text: flag['issue'] == 'decrease'
                    ? 'Odometer decreased from ${Fmt.number(flag['fromKm'] as int)} km '
                          'to ${Fmt.number(flag['toKm'] as int)} km. Recorded as-is.'
                    : 'Implied usage looks high between '
                          '${BsDate.formatAd(DateTime.parse(flag['from'] as String))} and '
                          '${BsDate.formatAd(DateTime.parse(flag['to'] as String))}. '
                          'Check the readings.',
              ),
          ],
          pw.SizedBox(height: 16),
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: surface,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'How to read this dossier',
                  style: pw.TextStyle(
                    fontSize: 8.5,
                    fontWeight: pw.FontWeight.bold,
                    color: navy,
                  ),
                ),
                pw.SizedBox(height: 3),
                pw.Text(
                  'Records and evidence are supplied by the vehicle owner and stored on the owner\'s device. '
                  'TrustTrail does not connect to the Department of Transport Management or any insurer, does not '
                  'verify documents with issuing authorities, and does not sell a trust score. Gaps mean "no record '
                  'was shared", not "nothing happened". In this demo build, QR tokens resolve only on the device that '
                  'created the report — ask the seller for this PDF. Nepali plate rendering is available in the app.',
                  style: pw.TextStyle(
                    fontSize: 7.4,
                    color: muted,
                    lineSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Token ${match.snapshot.token}',
                style: pw.TextStyle(
                  fontSize: 8,
                  color: navy,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                'Generated on this device · v1.0 demo',
                style: pw.TextStyle(fontSize: 7.5, color: muted),
              ),
            ],
          ),
        ],
      ),
    );
    return doc.save();
  }

  static pw.Widget _cell(
    String text,
    PdfColor color, {
    bool bold = false,
    bool right = false,
    double size = 8,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: pw.Text(
        text,
        textAlign: right ? pw.TextAlign.right : pw.TextAlign.left,
        style: pw.TextStyle(
          fontSize: size,
          color: color,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }
}
