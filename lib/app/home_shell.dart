import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/l10n/l10n.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/utils/token_codec.dart';
import '../core/widgets/tt_bottom_nav.dart';
import '../data/models/user.dart';
import '../features/auth/session.dart';
import '../features/buyer/browse_listings_screen.dart';
import '../features/buyer/buyer_result_screen.dart';
import '../features/buyer/buyer_search_screen.dart';
import '../features/buyer/saved_reports_screen.dart';
import '../features/buyer/scan_screen.dart';
import '../features/garage/garage_controller.dart';
import '../features/garage/garage_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/records/record_form_screen.dart';
import '../features/reminders/reminders_screen.dart';
import '../features/vehicles/add_vehicle_screen.dart';

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  var _index = 0;
  var _reportSelecting = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final role = ref.watch(
      sessionProvider.select((value) => value.value?.role ?? UserRole.owner),
    );
    final isBuyer = role == UserRole.buyer;
    ref.listen(
      sessionProvider.select((value) => value.value?.role ?? UserRole.owner),
      (previous, next) {
        if (previous == next) return;
        // Each role has its own page set, so restart from the first tab.
        setState(() {
          _index = 0;
          _reportSelecting = false;
        });
      },
    );

    final pages = isBuyer
        ? [
            const BrowseListingsScreen(),
            const BuyerSearchScreen(),
            SavedReportsScreen(
              embedded: true,
              onSelectingChanged: (selecting) {
                if (_reportSelecting != selecting) {
                  setState(() => _reportSelecting = selecting);
                }
              },
            ),
            ProfileScreen(onOpenSaved: () => setState(() => _index = 2)),
          ]
        : [
            GarageScreen(
              onOpenReminders: _openReminders,
              onOpenProfile: () => setState(() => _index = 3),
            ),
            const BrowseListingsScreen(),
            const BuyerSearchScreen(),
            ProfileScreen(
              onOpenReminders: _openReminders,
              onOpenSaved: _openSavedReports,
            ),
          ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      floatingActionButton: _index == pages.length - 1 || _reportSelecting
          ? null
          : FloatingActionButton(
              onPressed: isBuyer ? _scan : _add,
              backgroundColor: palette.primary,
              foregroundColor: Colors.white,
              elevation: 3,
              shape: const CircleBorder(),
              tooltip: isBuyer ? l10n.scanQr : l10n.addRecord,
              child: Icon(
                isBuyer ? Icons.qr_code_scanner_rounded : Icons.add_rounded,
                size: 26,
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: TtBottomNav(
        index: _index,
        onSelect: (value) => setState(() => _index = value),
        labels: isBuyer
            ? [l10n.navBrowse, l10n.navSearch, l10n.navSaved, l10n.navProfile]
            : [l10n.navGarage, l10n.navBrowse, l10n.navSearch, l10n.navProfile],
        icons: isBuyer
            ? [
                Icons.storefront_outlined,
                Icons.search_rounded,
                Icons.bookmark_outline_rounded,
                Icons.person_outline_rounded,
              ]
            : [
                Icons.directions_car_outlined,
                Icons.storefront_outlined,
                Icons.search_rounded,
                Icons.person_outline_rounded,
              ],
      ),
    );
  }

  Future<void> _openReminders() {
    return Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const RemindersScreen()));
  }

  Future<void> _openSavedReports() {
    return Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const SavedReportsScreen()));
  }

  Future<void> _scan() async {
    final code = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(builder: (_) => const ScanScreen()),
    );
    if (code == null || code.isEmpty || !mounted) return;
    final token = TokenCodec.tryParse(code);
    if (token == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.lookupMissTitle)));
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => BuyerResultScreen(token: token)),
    );
  }

  Future<void> _add() async {
    final l10n = context.l10n;
    final palette = context.palette;
    final choice = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.post_add_rounded, color: palette.primary),
                title: Text(l10n.addRecord),
                subtitle: Text(l10n.garageSubtitle),
                onTap: () => Navigator.pop(context, 'record'),
              ),
              ListTile(
                leading: Icon(
                  Icons.directions_car_rounded,
                  color: palette.primary,
                ),
                title: Text(l10n.addVehicle),
                onTap: () => Navigator.pop(context, 'vehicle'),
              ),
            ],
          ),
        ),
      ),
    );
    if (choice == null || !mounted) return;

    if (choice == 'vehicle') {
      await Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => const AddVehicleScreen()));
      ref.invalidate(garageProvider);
      return;
    }

    final entries = ref.read(garageProvider).value ?? const <GarageEntry>[];
    if (entries.isEmpty) {
      await Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => const AddVehicleScreen()));
      ref.invalidate(garageProvider);
      return;
    }
    if (entries.length == 1) {
      await _openRecordForm(entries.first.vehicle.id);
      return;
    }

    final vehicleId = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                l10n.selectVehicle,
                style: TtType.title(palette.textPrimary, size: 18),
              ),
            ),
            for (final entry in entries)
              ListTile(
                leading: Icon(
                  Icons.two_wheeler_rounded,
                  color: palette.primary,
                ),
                title: Text(entry.vehicle.displayName),
                subtitle: Text(entry.vehicle.plateRoman),
                onTap: () => Navigator.pop(context, entry.vehicle.id),
              ),
          ],
        ),
      ),
    );
    if (vehicleId != null && mounted) {
      await _openRecordForm(vehicleId);
    }
  }

  Future<void> _openRecordForm(String vehicleId) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RecordFormScreen(vehicleId: vehicleId),
      ),
    );
    ref.invalidate(garageProvider);
  }
}
