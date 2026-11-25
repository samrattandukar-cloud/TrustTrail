import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shapes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/tt_card.dart';
import '../../core/widgets/tt_empty_state.dart';
import '../../core/widgets/tt_headers.dart';
import '../../core/widgets/tt_pills.dart';
import '../../core/widgets/tt_status_banner.dart';
import '../../data/models/user.dart';
import '../../data/repositories/repositories.dart';
import '../auth/session.dart';
import '../report/report_providers.dart';
import '../vehicles/section_labels.dart';
import '../vehicles/vehicle_photo.dart';
import 'buyer_bookmark_button.dart';
import 'buyer_listing_providers.dart';
import 'buyer_result_screen.dart';

class BrowseListingsScreen extends ConsumerWidget {
  const BrowseListingsScreen({super.key});

  Future<void> _toggleSaved(WidgetRef ref, String token, bool saved) async {
    final repo = ref.read(reportRepositoryProvider);
    if (saved) {
      await repo.removeSaved(token);
    } else {
      await repo.saveReport(token);
    }
    ref.invalidate(savedReportsProvider);
    ref.invalidate(reportSavedProvider(token));
  }

  Future<void> _open(BuildContext context, String token) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => BuyerResultScreen(token: token)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final role = ref.watch(
      sessionProvider.select((value) => value.value?.role ?? UserRole.owner),
    );
    final listings = ref.watch(buyerListingsProvider);
    final savedTokens = {
      for (final report
          in ref.watch(savedReportsProvider).value ??
              const <SavedReportSummary>[])
        report.token,
    };

    return SafeArea(
      bottom: false,
      child: listings.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: TtErrorState(
            title: l10n.errorGeneric,
            body: l10n.errorReportLoad,
            retryLabel: l10n.commonRetry,
            onRetry: () => ref.invalidate(buyerListingsProvider),
          ),
        ),
        data: (cards) => ListView(
          padding: const EdgeInsets.fromLTRB(
            TtSpace.page,
            12,
            TtSpace.page,
            TtSpace.bottomClearance,
          ),
          children: [
            TtAppHeader(
              showBack: false,
              eyebrow: role == UserRole.buyer ? l10n.modeBuyer : l10n.modeOwner,
              title: l10n.browseTitle,
              subtitle: l10n.browseSubtitle,
            ),
            const SizedBox(height: TtSpace.x4),
            TtStatusBanner(
              message: l10n.demoListingsNote,
              tone: TtBannerTone.info,
            ),
            const SizedBox(height: TtSpace.x4),
            if (cards.isEmpty)
              TtCard(
                child: TtEmptyState(
                  icon: Icons.storefront_outlined,
                  title: l10n.noListingsTitle,
                  body: l10n.noListingsBody,
                  compact: true,
                ),
              )
            else
              for (final card in cards) ...[
                _ListingCard(
                  card: card,
                  isSaved: savedTokens.contains(card.listing.token),
                  onTap: () => _open(context, card.listing.token),
                  onToggleSaved: () => _toggleSaved(
                    ref,
                    card.listing.token,
                    savedTokens.contains(card.listing.token),
                  ),
                ),
                const SizedBox(height: TtSpace.x4),
              ],
            const SizedBox(height: TtSpace.x2),
            TtStatusBanner(
              message: l10n.oneDeviceNote,
              tone: TtBannerTone.info,
            ),
          ],
        ),
      ),
    );
  }
}

class _ListingCard extends StatelessWidget {
  const _ListingCard({
    required this.card,
    required this.isSaved,
    required this.onTap,
    required this.onToggleSaved,
  });

  final BuyerListingCard card;
  final bool isSaved;
  final VoidCallback onTap;
  final VoidCallback onToggleSaved;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final vehicle = card.vehicle;
    return TtCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(TtRadius.card),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                VehiclePhoto(asset: card.photoAsset, height: 188),
                Positioned(
                  top: 10,
                  left: 10,
                  child: TtPill(
                    label: l10n.demoListingBadge,
                    compact: true,
                    foreground: palette.surface,
                    background: palette.navy.withValues(alpha: 0.82),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: BuyerBookmarkButton(
                    saved: isSaved,
                    onPressed: onToggleSaved,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Fmt.npr(card.listing.priceNpr),
                    style: TtType.title(palette.textPrimary, size: 19),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    card.name,
                    style: TtType.label(palette.textPrimary, size: 14.5),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${vehicle['year_ad']} · ${Fmt.number(card.latestKm)} km · '
                    '${fuelLabel('${vehicle['fuel']}', l10n)} · '
                    '${transmissionLabel('${vehicle['transmission']}', l10n)}',
                    style: TtType.caption(palette.textSecondary, size: 11.5),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.place_outlined,
                        size: 13,
                        color: palette.textSecondary,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          '${card.listing.area} · '
                          '${l10n.listedAgo(card.listing.listedDaysAgo)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TtType.caption(
                            palette.textSecondary,
                            size: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      TtPill(
                        label: l10n.recordsCount(card.recordCount),
                        icon: Icons.receipt_long_outlined,
                        compact: true,
                      ),
                      TtPill(
                        label: l10n.documentedOf(card.filled, card.total),
                        icon: Icons.checklist_rounded,
                        compact: true,
                        foreground: palette.primary,
                        background: palette.surfaceRaised,
                      ),
                      if (card.flagCount > 0)
                        TtPill(
                          label: l10n.glanceFlags(card.flagCount),
                          icon: Icons.speed_rounded,
                          compact: true,
                          foreground: palette.warning,
                          background: palette.warning.withValues(alpha: 0.14),
                        )
                      else if (card.gapCount > 0)
                        TtPill(
                          label: l10n.glanceGapsCount(card.gapCount),
                          icon: Icons.timeline_rounded,
                          compact: true,
                          foreground: palette.warning,
                          background: palette.warning.withValues(alpha: 0.14),
                        ),
                    ],
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
