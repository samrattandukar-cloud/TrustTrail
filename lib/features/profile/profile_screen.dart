import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../core/prefs/app_prefs.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/tt_card.dart';
import '../../core/widgets/tt_headers.dart';
import '../../core/widgets/tt_logo.dart';
import '../../core/widgets/tt_pills.dart';
import '../../data/models/user.dart';
import '../auth/session.dart';
import '../garage/garage_controller.dart';
import '../report/report_providers.dart';
import '../settings/settings_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key, this.onOpenReminders, this.onOpenSaved});

  final VoidCallback? onOpenReminders;
  final VoidCallback? onOpenSaved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final palette = context.palette;
    final session = ref.watch(sessionProvider).value;
    final user = session?.user;
    final role = session?.role ?? UserRole.owner;
    final isOwner = role == UserRole.owner;
    final summary = isOwner ? ref.watch(garageSummaryProvider).value : null;
    final savedCount = isOwner
        ? 0
        : ref.watch(savedReportsProvider).value?.length ?? 0;
    final recentCount = isOwner
        ? 0
        : ref
                  .read(sharedPrefsProvider)
                  .getStringList(PrefKeys.recentSearches)
                  ?.length ??
              0;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          TtSpace.page,
          12,
          TtSpace.page,
          TtSpace.bottomClearance,
        ),
        children: [
          TtAppHeader(
            showBack: false,
            eyebrow: l10n.account,
            title: l10n.profileTitle,
          ),
          const SizedBox(height: TtSpace.x4),
          TtCard(
            child: Row(
              children: [
                TtAvatar(name: user?.name ?? 'T', size: 58),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? l10n.continueDemo,
                        style: TtType.title(palette.textPrimary, size: 20),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user?.phone ?? '+977 98…',
                        style: TtType.body(palette.textSecondary, size: 13),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          TtPill(
                            label: isOwner ? l10n.modeOwner : l10n.modeBuyer,
                            icon: isOwner
                                ? Icons.directions_car_outlined
                                : Icons.search_rounded,
                            foreground: palette.primary,
                            background: palette.primary.withValues(alpha: 0.1),
                          ),
                          if (user?.isDemo ?? false)
                            TtPill(
                              label: l10n.demoBuild,
                              icon: Icons.science_outlined,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: TtSpace.x4),
          TtSectionHeader(title: isOwner ? l10n.stats : l10n.yourActivity),
          const SizedBox(height: 8),
          if (isOwner)
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    value: '${summary?.vehicles ?? 0}',
                    label: l10n.statVehicles,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatCard(
                    value: '${summary?.records ?? 0}',
                    label: l10n.statRecords,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatCard(
                    value: '${summary?.reports ?? 0}',
                    label: l10n.statReports,
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    value: '$savedCount',
                    label: l10n.savedReports,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatCard(
                    value: '$recentCount',
                    label: l10n.recentSearches,
                  ),
                ),
              ],
            ),
          const SizedBox(height: TtSpace.x4),
          TtSectionHeader(title: l10n.switchRole),
          const SizedBox(height: 8),
          SegmentedButton<UserRole>(
            segments: [
              ButtonSegment(
                value: UserRole.owner,
                label: Text(l10n.modeOwner),
                icon: const Icon(Icons.directions_car_outlined, size: 18),
              ),
              ButtonSegment(
                value: UserRole.buyer,
                label: Text(l10n.modeBuyer),
                icon: const Icon(Icons.search_rounded, size: 18),
              ),
            ],
            selected: {role},
            onSelectionChanged: (selection) async {
              await ref
                  .read(sessionProvider.notifier)
                  .switchRole(selection.first);
              ref.invalidate(garageProvider);
              ref.invalidate(garageSummaryProvider);
            },
          ),
          const SizedBox(height: TtSpace.x4),
          TtCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _MenuRow(
                  icon: Icons.bookmark_border_rounded,
                  title: l10n.savedReports,
                  subtitle: l10n.savedReportsHint,
                  onTap: onOpenSaved,
                ),
                Divider(height: 1, color: palette.border),
                if (isOwner) ...[
                  _MenuRow(
                    icon: Icons.notifications_none_rounded,
                    title: l10n.remindersTitle,
                    subtitle: l10n.noRemindersBody,
                    onTap: onOpenReminders,
                  ),
                  Divider(height: 1, color: palette.border),
                ],
                _MenuRow(
                  icon: Icons.tune_rounded,
                  title: l10n.settingsTitle,
                  subtitle: '${l10n.appearance} · ${l10n.language}',
                  onTap: () => _push(context, const SettingsScreen()),
                ),
              ],
            ),
          ),
          const SizedBox(height: TtSpace.x4),
          OutlinedButton.icon(
            onPressed: () async {
              await ref.read(sessionProvider.notifier).signOut();
              ref.invalidate(garageProvider);
            },
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: Text(l10n.logout),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              foregroundColor: palette.error,
              side: BorderSide(color: palette.error.withValues(alpha: 0.4)),
            ),
          ),
        ],
      ),
    );
  }

  void _push(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return TtCard(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      child: Column(
        children: [
          Text(value, style: TtType.data(palette.textPrimary, size: 22)),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TtType.caption(palette.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14),
      leading: Icon(icon, color: palette.primary, size: 21),
      title: Text(title, style: TtType.label(palette.textPrimary, size: 13.5)),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TtType.caption(palette.textSecondary, size: 11),
      ),
      trailing: Icon(Icons.chevron_right_rounded, color: palette.textSecondary),
    );
  }
}
