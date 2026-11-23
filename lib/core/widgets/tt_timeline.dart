import 'package:flutter/material.dart';

import '../../data/models/vehicle_record.dart';
import '../../domain/timeline_builder.dart';
import '../l10n/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_shapes.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../utils/bs_date.dart';
import '../utils/formatters.dart';
import 'tt_card.dart';
import 'tt_pills.dart';
import '../../features/records/category_style.dart';

class TtTimeline extends StatelessWidget {
  const TtTimeline({
    super.key,
    required this.records,
    this.evidenceCounts = const {},
    this.onTap,
  });

  final List<VehicleRecord> records;
  final Map<String, int> evidenceCounts;
  final ValueChanged<VehicleRecord>? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final groups = groupByBsYear<VehicleRecord>(
      records,
      (record) => record.eventDate,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var groupIndex = 0; groupIndex < groups.length; groupIndex++) ...[
          if (groupIndex > 0) const SizedBox(height: TtSpace.x4),
          Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 4),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: palette.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  BsDate.yearLabel(
                    groups[groupIndex].items.first.eventDate,
                    nepali: context.isNepali,
                  ),
                  style: TtType.eyebrow(palette.textSecondary),
                ),
                const SizedBox(width: 10),
                Expanded(child: Divider(color: palette.border, height: 1)),
              ],
            ),
          ),
          for (var index = 0; index < groups[groupIndex].items.length; index++)
            _Milestone(
              record: groups[groupIndex].items[index],
              evidenceCount:
                  evidenceCounts[groups[groupIndex].items[index].id] ?? 0,
              isLast: index == groups[groupIndex].items.length - 1,
              onTap: onTap,
            ),
        ],
      ],
    );
  }
}

class _Milestone extends StatelessWidget {
  const _Milestone({
    required this.record,
    required this.evidenceCount,
    required this.isLast,
    this.onTap,
  });

  final VehicleRecord record;
  final int evidenceCount;
  final bool isLast;
  final ValueChanged<VehicleRecord>? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = context.l10n;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 22,
            child: Column(
              children: [
                Container(width: 1.5, height: 10, color: palette.border),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: palette.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: palette.primary, width: 2),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 1.5,
                    color: isLast ? Colors.transparent : palette.border,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TtCard(
                padding: const EdgeInsets.all(13),
                onTap: onTap == null ? null : () => onTap!(record),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: palette.surfaceRaised,
                            borderRadius: TtRadius.fieldBorder,
                          ),
                          child: Icon(
                            record.category.icon,
                            size: 18,
                            color: palette.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                record.title,
                                style: TtType.label(
                                  palette.textPrimary,
                                  size: 13.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                BsDate.both(
                                  record.eventDate,
                                  nepali: context.isNepali,
                                ),
                                style: TtType.caption(
                                  palette.textSecondary,
                                  size: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (record.costNpr != null)
                          Text(
                            Fmt.npr(record.costNpr),
                            style: TtType.data(palette.textPrimary, size: 11.5),
                          ),
                      ],
                    ),
                    const SizedBox(height: 9),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        TtPill(
                          label: record.category.label(l10n),
                          compact: true,
                          foreground: palette.primary,
                          background: palette.surfaceRaised,
                        ),
                        if (record.odometerKm != null)
                          TtPill(
                            label: Fmt.km(record.odometerKm!),
                            compact: true,
                            icon: Icons.speed_rounded,
                          ),
                        if (evidenceCount > 0)
                          TtPill(
                            label: l10n.evidenceAttachedShort(evidenceCount),
                            compact: true,
                            icon: Icons.attach_file_rounded,
                            foreground: palette.success,
                            background: palette.success.withValues(alpha: 0.12),
                          )
                        else if (record.source == RecordSource.ownerRecorded)
                          const SelfReportedPill(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
