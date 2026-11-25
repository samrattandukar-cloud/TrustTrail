import 'seed_data.dart';

/// Display-only marketplace details for the buyer demo. Prices, sellers and
/// areas are fictitious and are never written to the database.
class DemoListing {
  const DemoListing({
    required this.token,
    required this.priceNpr,
    required this.seller,
    required this.area,
    required this.listedDaysAgo,
  });

  final String token;
  final int priceNpr;
  final String seller;
  final String area;
  final int listedDaysAgo;
}

abstract final class DemoListings {
  static const shine = DemoListing(
    token: DemoSeeder.shineToken,
    priceNpr: 178000,
    seller: 'Sujan Bajracharya',
    area: 'Bhaktapur',
    listedDaysAgo: 1,
  );
  static const fzs = DemoListing(
    token: DemoSeeder.fzsToken,
    priceNpr: 189000,
    seller: 'Bikash Shrestha',
    area: 'Lalitpur',
    listedDaysAgo: 3,
  );
  static const grand = DemoListing(
    token: DemoSeeder.grandToken,
    priceNpr: 1450000,
    seller: 'Bikash Shrestha',
    area: 'Kathmandu',
    listedDaysAgo: 9,
  );

  static const all = <DemoListing>[shine, fzs, grand];

  static DemoListing? byToken(String token) {
    for (final listing in all) {
      if (listing.token == token) return listing;
    }
    return null;
  }
}
