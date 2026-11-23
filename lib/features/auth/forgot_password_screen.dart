import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/tt_buttons.dart';
import '../../core/widgets/tt_headers.dart';
import '../../core/widgets/tt_status_banner.dart';
import 'session.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final palette = context.palette;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(TtSpace.page),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TtAppHeader(),
              const SizedBox(height: TtSpace.x4),
              Text(
                l10n.forgotPassword,
                style: TtType.headline(palette.textPrimary),
              ),
              const SizedBox(height: TtSpace.x3),
              Text(
                l10n.forgotPasswordBody,
                style: TtType.body(palette.textSecondary),
              ),
              const SizedBox(height: TtSpace.x4),
              TtStatusBanner(
                message: l10n.demoOtpNote,
                tone: TtBannerTone.info,
              ),
              const Spacer(),
              TtPrimaryButton(
                label: l10n.continueDemo,
                icon: Icons.bolt_rounded,
                onPressed: () async {
                  await ref.read(sessionProvider.notifier).signInDemo();
                  if (!context.mounted) return;
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
              const SizedBox(height: TtSpace.x2),
              TtSecondaryButton(
                label: l10n.commonBack,
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
