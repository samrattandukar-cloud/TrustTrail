import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shapes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/bs_date.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/tt_buttons.dart';
import '../../core/widgets/tt_card.dart';
import '../../core/widgets/tt_empty_state.dart';
import '../../core/widgets/tt_headers.dart';
import '../../core/widgets/tt_pills.dart';
import '../../data/local/seed/demo_listings.dart';
import '../../data/repositories/report_repository.dart';
import '../../data/repositories/repositories.dart';
import '../records/category_style.dart';
import '../records/record_detail_screen.dart';
import '../report/report_dossier.dart';
import '../report/report_providers.dart';
import '../report/report_share_screen.dart';
import '../vehicles/section_labels.dart';
import '../vehicles/vehicle_photo.dart';
import 'buyer_bookmark_button.dart';

class BuyerResultScreen extends ConsumerStatefulWidget {
  const BuyerResultScreen({super.key, required this.token});

  final String token;

  @override
  ConsumerState<BuyerResultScreen> createState() => _BuyerResultScreenState();
}

class _BuyerResultScreenState extends ConsumerState<BuyerResultScreen> {
  String? _category;
  var _busy = false;

  Future<void> _sharePdf(ReportMatch match) async {
    setState(() => _busy = true);
    try {
      await ReportExporter.sharePdf(ref, match);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.errorGeneric)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _toggleSaved(bool saved) async {
    final repo = ref.read(reportRepositoryProvider);
    if (saved) {
      await repo.removeSaved(widget.token);
    } else {
      await repo.saveReport(widget.token);
    }
    ref.invalidate(reportSavedProvider(widget.token));
    ref.invalidate(savedReportsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final async = ref.watch(reportMatchProvider(widget.token));
    final saved = ref.watch(reportSavedProvider(widget.token)).value ?? false;

    return Scaffold(
      body: SafeArea(
        child: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: TtErrorState(
              title: l10n.errorGeneric,
              body: l10n.errorReportOpen,
              retryLabel: l10n.commonRetry,
              onRetry: () => ref.invalidate(reportMatchProvider(widget.token)),
            ),
          ),
          data: (match) {
            if (match == null) {
              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(TtSpace.page),
                    child: TtAppHeader(title: ''),
                  ),
                  TtEmptyState(
                    icon: Icons.search_off_rounded,
                    title: l10n.lookupMissTitle,
                    body: l10n.lookupMissBody,
                    action: TtSecondaryButton(
                      label: l10n.commonBack,
                      onPressed: () => Navigator.of(context).maybePop(),
                      expand: false,
                    ),
                  ),
                ],
              );
            }
            final payload = match.payload;
            final vehicle = (payload['vehicle'] as Map).cast<String, Object?>();
            final records = (payload['records'] as List)
                .cast<Map<String, Object?>>();
            final completeness = (payload['completeness'] as Map)
                .cast<String, Object?>();
            final odometer = (payload['odometer'] as Map)
                .cast<String, Object?>();
            final categories = <String>{
              for (final record in records) record['category'] as String,
            }.toList()..sort();
            final listing = DemoListings.byToken(widget.token);

            return ListView(
              padding: const EdgeInsets.all(TtSpace.page),
              children: [
                TtAppHeader(
                  eyebrow: l10n.vehicleHistory,
                  title: '${vehicle['make']} ${vehicle['model']}',
                  subtitle:
                      '${vehicle['plate_roman']} · ${match.snapshot.token}',
                  actions: [
                    TtCircleIconButton(
                      icon: Icons.ios_share_rounded,
                      tooltip: l10n.shareReport,
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              ReportShareScreen(token: widget.token),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TtSpace.x3),
                _ReportHero(
                  match: match,
                  listing: listing,
                  saved: saved,
                  onToggleSaved: () => _toggleSaved(saved),
                ),
                const SizedBox(height: TtSpace.x3),
                Row(
                  children: [
                    Expanded(
                      child: TtSecondaryButton(
                        label: saved ? l10n.removeSaved : l10n.saveReport,
                        icon: saved
                            ? Icons.bookmark_remove_outlined
                            : Icons.bookmark_add_outlined,
                        onPressed: () => _toggleSaved(saved),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TtPrimaryButton(
                        label: l10n.downloadPdf,
                        icon: Icons.picture_as_pdf_rounded,
                        loading: _busy,
                        onPressed: () => _sharePdf(match),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TtSpace.x4),
                TtSectionHeader(title: l10n.historyAtAGlance),
                const SizedBox(height: TtSpace.x2),
                _HistoryAtAGlance(
                  records: records,
                  completeness: completeness,
                  odometer: odometer,
                ),
                const SizedBox(height: TtSpace.x2),
                Text(
                  l10n.glanceComputedNote,
                  style: TtType.caption(palette.textSecondary, size: 10.5),
                ),
                const SizedBox(height: TtSpace.x4),
                if (categories.length > 1) ...[
                  SizedBox(
                    height: 38,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ChoiceChip(
                          label: Text(l10n.viewAll),
                          selected: _category == null,
                          onSelected: (_) => setState(() => _category = null),
                        ),
                        const SizedBox(width: 6),
                        for (final category in categories) ...[
                          ChoiceChip(
                            label: Text(categoryLabel(category, l10n)),
                            selected: _category == category,
                            onSelected: (_) =>
                                setState(() => _category = category),
                          ),
                          const SizedBox(width: 6),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: TtSpace.x2),
                ],
                ReportDossier(
                  match: match,
                  categoryFilter: _category,
                  showVehicleCard: false,
                  showCompletenessCard: false,
                  onRecordTap: (record) => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => RecordDetailScreen(
                        recordId: record['id'] as String,
                        readOnly: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: TtSpace.x3),
                Text(
                  l10n.completionNotScore,
                  textAlign: TextAlign.center,
                  style: TtType.caption(palette.textSecondary),
                ),
                const SizedBox(height: TtSpace.x4),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ReportHero extends StatelessWidget {
  const _ReportHero({
    required this.match,
    required this.listing,
    required this.saved,
    required this.onToggleSaved,
  });

  final ReportMatch match;
  final DemoListing? listing;
  final bool saved;
  final VoidCallback onToggleSaved;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final payload = match.payload;
    final vehicle = (payload['vehicle'] as Map).cast<String, Object?>();
    final records = (payload['records'] as List).cast<Map<String, Object?>>();
    final completeness = (payload['completeness'] as Map)
        .cast<String, Object?>();
    final odometer = (payload['odometer'] as Map).cast<String, Object?>();
    final generated =
        DateTime.tryParse(payload['generatedAt'] as String? ?? '') ??
        match.snapshot.createdAt;
    final rawPhoto = vehicle['photo_asset'] as String?;
    final photo = rawPhoto == null
        ? null
        : rawPhoto.startsWith('asset:')
        ? rawPhoto.substring(6)
        : rawPhoto;
    final latestKm = vehicle['latestKm'] as int? ?? 0;
    final filled = completeness['filled'] as int? ?? 0;
    final total = completeness['total'] as int? ?? 10;
    final flags = (odometer['flags'] as List).length;
    final gaps = (odometer['gaps'] as List).length;
    var evidence = 0;
    for (final record in records) {
      evidence += (record['evidence'] as List).length;
    }

    return TtCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(TtRadius.card),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                VehiclePhoto(asset: photo, height: 204),
                Positioned(
                  top: 8,
                  right: 8,
                  child: BuyerBookmarkButton(
                    saved: saved,
                    onPressed: onToggleSaved,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (listing != null) ...[
                    Text(
                      Fmt.npr(listing!.priceNpr),
                      style: TtType.title(palette.textPrimary, size: 23),
                    ),
                    const SizedBox(height: 2),
                  ],
                  Text(
                    '${vehicle['year_ad']} · ${Fmt.number(latestKm)} km · '
                    '${fuelLabel('${vehicle['fuel']}', l10n)} · '
                    '${transmissionLabel('${vehicle['transmission']}', l10n)}',
                    style: TtType.caption(palette.textSecondary, size: 12),
                  ),
                  if (listing != null) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline_rounded,
                          size: 14,
                          color: palette.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            l10n.reportHeroListedBy(listing!.seller),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TtType.caption(
                              palette.textSecondary,
                              size: 11.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.place_outlined,
                          size: 14,
                          color: palette.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${listing!.area} · '
                            '${l10n.listedAgo(listing!.listedDaysAgo)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TtType.caption(
                              palette.textSecondary,
                              size: 11.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      TtPill(
                        label: l10n.documentedOf(filled, total),
                        icon: Icons.checklist_rounded,
                        compact: true,
                        foreground: palette.primary,
                        background: palette.surfaceRaised,
                      ),
                      TtPill(
                        label: l10n.recordsCount(records.length),
                        icon: Icons.receipt_long_outlined,
                        compact: true,
                      ),
                      if (evidence > 0)
                        TtPill(
                          label: l10n.evidenceAttachedShort(evidence),
                          icon: Icons.attach_file_rounded,
                          compact: true,
                          foreground: palette.success,
                          background: palette.success.withValues(alpha: 0.12),
                        ),
                      if (flags > 0)
                        TtPill(
                          label: l10n.glanceFlags(flags),
                          icon: Icons.speed_rounded,
                          compact: true,
                          foreground: palette.warning,
                          background: palette.warning.withValues(alpha: 0.14),
                        )
                      else if (gaps > 0)
                        TtPill(
                          label: l10n.glanceGapsCount(gaps),
                          icon: Icons.timeline_rounded,
                          compact: true,
                          foreground: palette.warning,
                          background: palette.warning.withValues(alpha: 0.14),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      TtPill(
                        label: match.snapshot.token,
                        icon: Icons.qr_code_2_rounded,
                        foreground: palette.primary,
                        background: palette.surfaceRaised,
                      ),
                      Text(
                        l10n.generatedOn(
                          BsDate.both(generated, nepali: context.isNepali),
                        ),
                        style: TtType.caption(
                          palette.textSecondary,
                          size: 10.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryAtAGlance extends StatelessWidget {
  const _HistoryAtAGlance({
    required this.records,
    required this.completeness,
    required this.odometer,
  });

  final List<Map<String, Object?>> records;
  final Map<String, Object?> completeness;
  final Map<String, Object?> odometer;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final filled = completeness['filled'] as int? ?? 0;
    final total = completeness['total'] as int? ?? 10;
    final percent = completeness['percent'] as int? ?? 0;
    final readings = (odometer['readings'] as List).length;
    final flags = (odometer['flags'] as List).length;
    final gaps = (odometer['gaps'] as List).length;
    final ownership = records
        .where((record) => record['category'] == 'ownership')
        .length;
    var evidence = 0;
    for (final record in records) {
      evidence += (record['evidence'] as List).length;
    }

    final tiles = [
      _GlanceTileData(
        icon: Icons.fact_check_outlined,
        label: l10n.glanceChecklist,
        value: '$filled/$total',
        note: l10n.documentedPercent(percent),
        tone: _GlanceTone.primary,
      ),
      _GlanceTileData(
        icon: Icons.receipt_long_outlined,
        label: l10n.glanceRecords,
        value: '${records.length}',
        note: l10n.ownerRecorded,
        tone: _GlanceTone.neutral,
      ),
      _GlanceTileData(
        icon: Icons.attach_file_rounded,
        label: l10n.glanceEvidence,
        value: '$evidence',
        note: evidence == 0
            ? l10n.evidenceNone
            : l10n.evidenceAttachedShort(evidence),
        tone: evidence == 0 ? _GlanceTone.neutral : _GlanceTone.success,
      ),
      _GlanceTileData(
        icon: Icons.speed_rounded,
        label: l10n.glanceOdometer,
        value: '$readings',
        note: flags == 0 ? l10n.glanceNoIssues : l10n.glanceFlags(flags),
        tone: flags == 0 ? _GlanceTone.success : _GlanceTone.warning,
      ),
      _GlanceTileData(
        icon: Icons.timeline_rounded,
        label: l10n.glanceGaps,
        value: '$gaps',
        note: gaps == 0 ? l10n.glanceNoGaps : l10n.glanceGapsCount(gaps),
        tone: gaps == 0 ? _GlanceTone.success : _GlanceTone.warning,
      ),
      _GlanceTileData(
        icon: Icons.people_outline_rounded,
        label: l10n.glanceOwnership,
        value: '$ownership',
        note: l10n.glanceOwnershipSub,
        tone: _GlanceTone.neutral,
      ),
    ];

    return TtCard(
      padding: const EdgeInsets.all(10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = (constraints.maxWidth - 8) / 2;
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final tile in tiles) _GlanceTile(data: tile, width: width),
            ],
          );
        },
      ),
    );
  }
}

enum _GlanceTone { primary, success, warning, neutral }

class _GlanceTileData {
  const _GlanceTileData({
    required this.icon,
    required this.label,
    required this.value,
    required this.note,
    required this.tone,
  });

  final IconData icon;
  final String label;
  final String value;
  final String note;
  final _GlanceTone tone;
}

class _GlanceTile extends StatelessWidget {
  const _GlanceTile({required this.data, required this.width});

  final _GlanceTileData data;
  final double width;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final color = switch (data.tone) {
      _GlanceTone.primary => palette.primary,
      _GlanceTone.success => palette.success,
      _GlanceTone.warning => palette.warning,
      _GlanceTone.neutral => palette.textSecondary,
    };
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: palette.surfaceRaised,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(data.icon, size: 15, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  data.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TtType.caption(palette.textSecondary, size: 10.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(data.value, style: TtType.data(palette.textPrimary, size: 18)),
          const SizedBox(height: 2),
          Text(
            data.note,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TtType.caption(color, size: 10),
          ),
        ],
      ),
    );
  }
}
