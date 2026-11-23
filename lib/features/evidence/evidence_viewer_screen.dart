import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/tt_buttons.dart';
import '../../data/models/evidence.dart';
import 'evidence_image.dart';

class EvidenceViewerScreen extends StatefulWidget {
  const EvidenceViewerScreen({
    super.key,
    required this.evidence,
    this.initialIndex = 0,
  });

  final List<Evidence> evidence;
  final int initialIndex;

  @override
  State<EvidenceViewerScreen> createState() => _EvidenceViewerScreenState();
}

class _EvidenceViewerScreenState extends State<EvidenceViewerScreen> {
  late final PageController _controller = PageController(
    initialPage: widget.initialIndex,
  );
  late int _index = widget.initialIndex;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = context.l10n;
    final item = widget.evidence[_index];
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          '${_index + 1} / ${widget.evidence.length}',
          style: TtType.label(Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.evidence.length,
              onPageChanged: (value) => setState(() => _index = value),
              itemBuilder: (context, index) {
                final current = widget.evidence[index];
                if (current.isPdf) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.picture_as_pdf_rounded,
                            size: 84,
                            color: Colors.white70,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            current.label ?? 'PDF document',
                            textAlign: TextAlign.center,
                            style: TtType.body(Colors.white),
                          ),
                          const SizedBox(height: 20),
                          TtSecondaryButton(
                            label: l10n.commonShare,
                            icon: Icons.ios_share_rounded,
                            onPressed: () => _sharePdf(current),
                            expand: false,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 5,
                  child: Center(
                    child: EvidenceImage(
                      path: current.filePath,
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
              TtSpace.page,
              12,
              TtSpace.page,
              12 + MediaQuery.viewPaddingOf(context).bottom,
            ),
            color: Colors.black,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.label ?? l10n.evidenceTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TtType.caption(Colors.white70),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  tooltip: l10n.commonShare,
                  onPressed: () => _sharePdf(item),
                  icon: Icon(Icons.ios_share_rounded, color: palette.surface),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sharePdf(Evidence item) async {
    if (item.isAsset) return;
    await SharePlus.instance.share(ShareParams(files: [XFile(item.filePath)]));
  }
}
