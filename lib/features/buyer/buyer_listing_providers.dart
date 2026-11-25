import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/seed/demo_listings.dart';
import '../../data/repositories/report_repository.dart';
import '../../data/repositories/repositories.dart';

class BuyerListingCard {
  const BuyerListingCard({
    required this.listing,
    required this.match,
    required this.recordCount,
    required this.evidenceCount,
    required this.filled,
    required this.total,
    required this.flagCount,
    required this.gapCount,
  });

  final DemoListing listing;
  final ReportMatch match;
  final int recordCount;
  final int evidenceCount;
  final int filled;
  final int total;
  final int flagCount;
  final int gapCount;

  Map<String, Object?> get vehicle =>
      (match.payload['vehicle'] as Map).cast<String, Object?>();

  String get name => '${vehicle['make']} ${vehicle['model']}';

  String? get photoAsset {
    final raw = vehicle['photo_asset'] as String?;
    if (raw == null) return null;
    return raw.startsWith('asset:') ? raw.substring(6) : raw;
  }

  int get latestKm => vehicle['latestKm'] as int? ?? 0;
}

/// Resolves the seeded listing tokens into card data, skipping any listing
/// whose snapshot is not present locally.
final buyerListingsProvider =
    FutureProvider.autoDispose<List<BuyerListingCard>>((ref) async {
      final repo = ref.watch(reportRepositoryProvider);
      final cards = <BuyerListingCard>[];
      for (final listing in DemoListings.all) {
        final match = await repo.search(listing.token);
        if (match == null) continue;
        final payload = match.payload;
        final records = (payload['records'] as List)
            .cast<Map<String, Object?>>();
        final completeness = (payload['completeness'] as Map)
            .cast<String, Object?>();
        final odometer = (payload['odometer'] as Map).cast<String, Object?>();
        var evidence = 0;
        for (final record in records) {
          evidence += (record['evidence'] as List).length;
        }
        cards.add(
          BuyerListingCard(
            listing: listing,
            match: match,
            recordCount: records.length,
            evidenceCount: evidence,
            filled: completeness['filled'] as int,
            total: completeness['total'] as int,
            flagCount: (odometer['flags'] as List).length,
            gapCount: (odometer['gaps'] as List).length,
          ),
        );
      }
      return cards;
    });
