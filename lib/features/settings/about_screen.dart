import 'package:flutter/material.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/tt_card.dart';
import '../../core/widgets/tt_headers.dart';
import '../../core/widgets/tt_logo.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            TtSpace.page,
            8,
            TtSpace.page,
            TtSpace.page,
          ),
          children: [
            const TtAppHeader(title: 'TrustTrail', eyebrow: 'CIS099-2'),
            const SizedBox(height: TtSpace.x5),
            const Center(child: TtLogo(size: 64)),
            const SizedBox(height: TtSpace.x4),
            Text(
              l10n.aboutIntro,
              textAlign: TextAlign.center,
              style: TtType.body(palette.textSecondary, size: 13.5),
            ),
            const SizedBox(height: TtSpace.x5),
            _Block(
              icon: Icons.handshake_outlined,
              title: l10n.aboutLimitsTitle,
              body: l10n.aboutLimitsBody,
            ),
            _Block(
              icon: Icons.lock_outline_rounded,
              title: l10n.aboutPrivacyTitle,
              body: l10n.aboutPrivacyBody,
            ),
            _Block(
              icon: Icons.science_outlined,
              title: l10n.aboutDataTitle,
              body: l10n.aboutDataBody,
            ),
            const SizedBox(height: TtSpace.x3),
            Text(
              l10n.version,
              textAlign: TextAlign.center,
              style: TtType.caption(palette.textSecondary),
            ),
            const SizedBox(height: 4),
            Text(
              'Flutter · offline SQLite · no analytics',
              textAlign: TextAlign.center,
              style: TtType.caption(palette.textSecondary, size: 10.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TtCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: palette.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 19, color: palette.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TtType.label(palette.textPrimary, size: 13.5),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    body,
                    style: TtType.body(
                      palette.textSecondary,
                      size: 12.5,
                      height: 1.5,
                    ),
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
