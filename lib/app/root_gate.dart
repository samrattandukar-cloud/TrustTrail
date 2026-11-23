import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/l10n/l10n.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../core/widgets/tt_empty_state.dart';
import '../core/widgets/tt_logo.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/session.dart';
import '../features/onboarding/onboarding_screen.dart';
import 'home_shell.dart';

class RootGate extends ConsumerWidget {
  const RootGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final session = ref.watch(sessionProvider);

    return session.when(
      loading: () => const _Splash(),
      error: (error, stack) => Scaffold(
        body: SafeArea(
          child: Center(
            child: TtErrorState(
              title: l10n.errorGeneric,
              body: l10n.errorSessionRestore,
              retryLabel: l10n.commonRetry,
              onRetry: () => ref.invalidate(sessionProvider),
            ),
          ),
        ),
      ),
      data: (state) {
        if (!state.onboardingDone) return const OnboardingScreen();
        if (!state.signedIn) return const LoginScreen();
        return const HomeShell();
      },
    );
  }
}

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: const Color(0xFF0F2A4A),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F2A4A), Color(0xFF164A74), Color(0xFF226B9F)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -70,
              top: -40,
              child: _Ring(
                size: 230,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
            Positioned(
              left: -90,
              bottom: -80,
              child: _Ring(
                size: 280,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const TtLogo(size: 76, dark: true),
                  const SizedBox(height: TtSpace.x4),
                  Text(
                    l10n.splashTagline,
                    style: TtType.body(
                      Colors.white.withValues(alpha: 0.82),
                      size: 14,
                    ),
                  ),
                  const SizedBox(height: TtSpace.x6),
                  SizedBox(
                    width: 26,
                    height: 26,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 28,
              child: Text(
                l10n.splashDemoNote,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: TtFonts.body,
                  fontSize: 10.5,
                  color: Color(0x99FFFFFF),
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
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
        border: Border.all(color: color, width: 22),
      ),
    );
  }
}
