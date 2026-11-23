import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/tt_buttons.dart';
import '../../core/widgets/tt_logo.dart';
import '../auth/session.dart';
import 'language_screen.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  var _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    // Push first: flipping `onboardingDone` swaps the gate's root widget, and
    // this page may be disposed before the persistence future completes.
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const LanguageScreen()));
    await ref.read(sessionProvider.notifier).completeOnboarding();
  }

  void _next() {
    if (_page == 2) {
      _finish();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final pages = [
      _OnboardPage(
        icon: Icons.timeline_rounded,
        eyebrow: '01',
        title: l10n.onboardingTitle1,
        body: l10n.onboardingBody1,
      ),
      _OnboardPage(
        icon: Icons.balance_rounded,
        eyebrow: '02',
        title: l10n.onboardingTitle2,
        body: l10n.onboardingBody2,
      ),
      _OnboardPage(
        icon: Icons.qr_code_2_rounded,
        eyebrow: '03',
        title: l10n.onboardingTitle3,
        body: l10n.onboardingBody3,
      ),
    ];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 12, 0),
              child: Row(
                children: [
                  const TtLogo(size: 38),
                  const Spacer(),
                  TextButton(onPressed: _finish, child: Text(l10n.commonSkip)),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (value) => setState(() => _page = value),
                children: pages,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < pages.length; i++)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: i == _page ? 26 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: i == _page
                                ? palette.primary
                                : palette.surfaceRaisedAlt,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: TtSpace.x5),
                  TtPrimaryButton(
                    label: _page == 2 ? l10n.getStarted : l10n.commonContinue,
                    icon: Icons.arrow_forward_rounded,
                    onPressed: _next,
                  ),
                  const SizedBox(height: TtSpace.x2),
                  Text(
                    l10n.demoBuild,
                    style: TtType.caption(palette.textSecondary),
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

class _OnboardPage extends StatelessWidget {
  const _OnboardPage({
    required this.icon,
    required this.eyebrow,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String eyebrow;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.25,
            child: Container(
              decoration: BoxDecoration(
                color: palette.navy,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -40,
                    top: -30,
                    child: _Ring(size: 190, color: palette.primary),
                  ),
                  Positioned(
                    left: -30,
                    bottom: -50,
                    child: _Ring(size: 150, color: palette.sand),
                  ),
                  Center(
                    child: Container(
                      width: 132,
                      height: 132,
                      decoration: BoxDecoration(
                        color: palette.surface.withValues(alpha: 0.10),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: palette.surface.withValues(alpha: 0.22),
                        ),
                      ),
                      child: Icon(icon, size: 62, color: palette.surface),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    top: 18,
                    child: Text(
                      eyebrow,
                      style: TtType.eyebrow(
                        palette.surface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: TtSpace.x6),
          Text(title, style: TtType.headline(palette.textPrimary)),
          const SizedBox(height: TtSpace.x2),
          Text(body, style: TtType.body(palette.textSecondary)),
        ],
      ),
    );
  }
}

class _Ring extends StatelessWidget {
  const _Ring({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.28), width: 26),
      ),
    );
  }
}
