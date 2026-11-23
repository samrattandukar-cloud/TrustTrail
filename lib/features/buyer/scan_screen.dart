import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/tt_buttons.dart';
import '../../core/widgets/tt_status_banner.dart';
import '../../core/widgets/tt_text_field.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final _controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
  );
  var _handled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    final raw = capture.barcodes.isEmpty
        ? null
        : capture.barcodes.first.rawValue;
    if (raw == null || raw.isEmpty) return;
    _handled = true;
    _controller.stop();
    Navigator.of(context).pop(raw);
  }

  Future<void> _manual() async {
    final controller = TextEditingController();
    final code = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.searchHint),
        content: TtTextField(
          label: context.l10n.searchHint,
          hint: 'TT-FZS-2026',
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: Text(context.l10n.searchButton),
          ),
        ],
      ),
    );
    controller.dispose();
    if (code != null && code.isNotEmpty && mounted) {
      Navigator.of(context).pop(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            errorBuilder: (context, error) => Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.no_photography_outlined,
                      color: Colors.white70,
                      size: 56,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      context.l10n.scanCameraError,
                      textAlign: TextAlign.center,
                      style: TtType.body(Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    children: [
                      TtCircleIconButton(
                        icon: Icons.close_rounded,
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                      const Spacer(),
                      TtCircleIconButton(
                        icon: Icons.flash_on_rounded,
                        tooltip: l10n.scanTorch,
                        onPressed: () => _controller.toggleTorch(),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Center(
                  child: Container(
                    width: 230,
                    height: 230,
                    decoration: BoxDecoration(
                      border: Border.all(color: palette.primary, width: 3),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(l10n.scanQr, style: TtType.title(Colors.white, size: 17)),
                const SizedBox(height: 4),
                Text(
                  l10n.scanHintBody,
                  textAlign: TextAlign.center,
                  style: TtType.caption(Colors.white70),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    0,
                    16,
                    16 + MediaQuery.viewPaddingOf(context).bottom,
                  ),
                  child: Column(
                    children: [
                      TtSecondaryButton(
                        label: l10n.scanManualEntry,
                        icon: Icons.keyboard_rounded,
                        onPressed: _manual,
                      ),
                      const SizedBox(height: 10),
                      TtStatusBanner(
                        message: l10n.scanPermissionNote,
                        tone: TtBannerTone.info,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
