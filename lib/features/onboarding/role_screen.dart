import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/tt_buttons.dart';
import '../../core/widgets/tt_card.dart';
import '../../data/models/user.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';
import '../auth/session.dart';

class RoleScreen extends ConsumerWidget {
  const RoleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final palette = context.palette;
    final selected = ref.watch(sessionProvider).value?.role ?? UserRole.owner;

    void choose(UserRole role) =>
        ref.read(sessionProvider.notifier).selectRole(role);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: TtSpace.x4),
              Text(
                l10n.chooseRole,
                style: TtType.headline(palette.textPrimary),
              ),
              const SizedBox(height: TtSpace.x5),
              _RoleCard(
                icon: Icons.two_wheeler_rounded,
                title: l10n.ownerRole,
                body: l10n.ownerRoleBody,
                selected: selected == UserRole.owner,
                onTap: () => choose(UserRole.owner),
              ),
              const SizedBox(height: TtSpace.x3),
              _RoleCard(
                icon: Icons.fact_check_outlined,
                title: l10n.buyerRole,
                body: l10n.buyerRoleBody,
                selected: selected == UserRole.buyer,
                onTap: () => choose(UserRole.buyer),
              ),
              const Spacer(),
              TtPrimaryButton(
                label: l10n.commonContinue,
                icon: Icons.arrow_forward_rounded,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const RegisterScreen(),
                  ),
                ),
              ),
              const SizedBox(height: TtSpace.x1),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const LoginScreen(),
                    ),
                  ),
                  child: Text(l10n.loginTitle),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String body;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return TtCard(
      onTap: onTap,
      padding: const EdgeInsets.all(18),
      borderColor: selected ? palette.primary : palette.border,
      color: selected ? palette.surfaceRaised : palette.surface,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: selected ? palette.primary : palette.surfaceRaisedAlt,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: selected ? palette.onPrimary : palette.textPrimary,
              size: 26,
            ),
          ),
          const SizedBox(width: TtSpace.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TtType.title(palette.textPrimary, size: 17)),
                const SizedBox(height: 4),
                Text(body, style: TtType.bodyMedium(palette.textSecondary)),
              ],
            ),
          ),
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: selected ? palette.primary : palette.border,
          ),
        ],
      ),
    );
  }
}
