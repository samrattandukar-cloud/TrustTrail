import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/tt_logo.dart';
import 'report_preview_screen.dart';

class ReportGeneratingScreen extends StatefulWidget {
  const ReportGeneratingScreen({super.key, required this.token});

  final String token;

  @override
  State<ReportGeneratingScreen> createState() => _ReportGeneratingScreenState();
}

class _ReportGeneratingScreenState extends State<ReportGeneratingScreen> {
  Timer? _timer1;
  Timer? _timer2;
  Timer? _timer3;
  var _step = 0;

  @override
  void initState() {
    super.initState();
    _timer1 = Timer(const Duration(milliseconds: 380), () {
      if (mounted) setState(() => _step = 1);
    });
    _timer2 = Timer(const Duration(milliseconds: 820), () {
      if (mounted) setState(() => _step = 2);
    });
    _timer3 = Timer(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => ReportPreviewScreen(token: widget.token),
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer1?.cancel();
    _timer2?.cancel();
    _timer3?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final steps = [
      l10n.genStepSnapshot,
      l10n.genStepSections,
      l10n.genStepToken,
      l10n.genStepReady,
    ];
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const TtLogo(size: 54),
              const SizedBox(height: TtSpace.x6),
              Text(
                l10n.reportGenerating,
                textAlign: TextAlign.center,
                style: TtType.headline(palette.textPrimary),
              ),
              const SizedBox(height: TtSpace.x2),
              Text(
                l10n.demoTokenNote,
                textAlign: TextAlign.center,
                style: TtType.caption(palette.textSecondary),
              ),
              const SizedBox(height: TtSpace.x6),
              for (var i = 0; i < steps.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: i <= _step
                            ? Icon(
                                Icons.check_circle_rounded,
                                key: ValueKey('done$i'),
                                color: palette.success,
                                size: 20,
                              )
                            : Icon(
                                Icons.radio_button_unchecked_rounded,
                                key: ValueKey('todo$i'),
                                color: palette.border,
                                size: 20,
                              ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        steps[i],
                        style: TtType.bodyMedium(
                          i <= _step
                              ? palette.textPrimary
                              : palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation(palette.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
