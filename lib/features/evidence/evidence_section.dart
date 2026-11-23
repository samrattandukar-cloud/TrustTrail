import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/tt_buttons.dart';
import '../../core/widgets/tt_empty_state.dart';
import '../../data/models/evidence.dart';
import '../../data/repositories/repositories.dart';
import '../records/record_detail_controller.dart';
import '../vehicles/vehicle_bundle.dart';
import 'evidence_image.dart';
import 'evidence_service.dart';
import 'evidence_viewer_screen.dart';

class EvidenceSection extends ConsumerStatefulWidget {
  const EvidenceSection({
    super.key,
    required this.recordId,
    required this.vehicleId,
    required this.evidence,
    this.readOnly = false,
  });

  final String recordId;
  final String vehicleId;
  final List<Evidence> evidence;
  final bool readOnly;

  @override
  ConsumerState<EvidenceSection> createState() => _EvidenceSectionState();
}

class _EvidenceSectionState extends ConsumerState<EvidenceSection> {
  var _busy = false;

  Future<void> _pick(EvidenceSource source) async {
    setState(() => _busy = true);
    try {
      final evidence = await EvidenceService.pick(
        recordId: widget.recordId,
        source: source,
      );
      if (evidence == null) return;
      await ref.read(evidenceRepositoryProvider).insert(evidence);
      ref.invalidate(recordDetailProvider(widget.recordId));
      ref.invalidate(vehicleBundleProvider(widget.vehicleId));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.uploadFailed)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _sheet() async {
    final l10n = context.l10n;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: Text(l10n.evidenceFromCamera),
                onTap: () {
                  Navigator.of(context).pop();
                  _pick(EvidenceSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(l10n.evidenceFromGallery),
                onTap: () {
                  Navigator.of(context).pop();
                  _pick(EvidenceSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf_outlined),
                title: Text(l10n.evidenceFromFile),
                onTap: () {
                  Navigator.of(context).pop();
                  _pick(EvidenceSource.file);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final items = widget.evidence;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.evidenceTitle,
                style: TtType.section(palette.textPrimary),
              ),
            ),
            if (!widget.readOnly)
              TextButton.icon(
                onPressed: _busy ? null : _sheet,
                icon: _busy
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.add_rounded, size: 18),
                label: Text(l10n.attachEvidence),
              ),
          ],
        ),
        const SizedBox(height: TtSpace.x1),
        if (items.isEmpty)
          TtEmptyState(
            icon: Icons.attach_file_rounded,
            title: l10n.evidenceEmptyTitle,
            body: l10n.evidenceEmptyBody,
            compact: true,
            action: widget.readOnly
                ? null
                : TtSecondaryButton(
                    label: l10n.attachEvidence,
                    icon: Icons.upload_file_rounded,
                    onPressed: _busy ? null : _sheet,
                    expand: false,
                  ),
          )
        else
          SizedBox(
            height: 112,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length + (widget.readOnly ? 0 : 1),
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                if (index == items.length) {
                  return InkWell(
                    onTap: _busy ? null : _sheet,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 96,
                      decoration: BoxDecoration(
                        color: palette.surfaceRaised,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: palette.border),
                      ),
                      child: Icon(
                        Icons.add_a_photo_outlined,
                        color: palette.primary,
                      ),
                    ),
                  );
                }
                final item = items[index];
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => EvidenceViewerScreen(
                        evidence: items,
                        initialIndex: index,
                      ),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 96,
                      height: 112,
                      child: item.isPdf
                          ? Container(
                              color: palette.surfaceRaised,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.picture_as_pdf_rounded,
                                    color: palette.error,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'PDF',
                                    style: TtType.label(
                                      palette.textSecondary,
                                      size: 10,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : EvidenceImage(path: item.filePath, cacheWidth: 260),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
