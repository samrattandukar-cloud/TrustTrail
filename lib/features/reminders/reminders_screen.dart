import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/tt_buttons.dart';
import '../../core/widgets/tt_card.dart';
import '../../core/widgets/tt_empty_state.dart';
import '../../core/widgets/tt_headers.dart';
import '../../core/widgets/tt_pills.dart';
import '../../core/widgets/tt_text_field.dart';
import '../../data/models/reminder.dart';
import '../../data/repositories/repositories.dart';
import '../../domain/reminder_engine.dart';
import '../garage/garage_controller.dart';

class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final palette = context.palette;
    final garage = ref.watch(garageProvider);
    final entries = garage.value ?? const <GarageEntry>[];
    final today = DateTime.now();

    final items = <_ReminderItem>[];
    for (final entry in entries) {
      for (final reminder in entry.reminders) {
        items.add(
          _ReminderItem(
            reminder: reminder,
            vehicleName: entry.vehicle.displayName,
            assessment: assessReminder(
              type: reminder.type,
              dueDate: reminder.dueDate,
              done: reminder.isDone,
              today: today,
              targetOdometer: reminder.targetOdometer,
              currentOdometer: entry.latestKm,
            ),
          ),
        );
      }
    }
    final overdue = items
        .where(
          (item) =>
              item.assessment.status == ReminderStatus.overdue ||
              item.assessment.status == ReminderStatus.dueNow,
        )
        .toList();
    final soon = items
        .where((item) => item.assessment.status == ReminderStatus.dueSoon)
        .toList();
    final later = items
        .where((item) => item.assessment.status == ReminderStatus.upcoming)
        .toList();

    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        onRefresh: () => ref.read(garageProvider.notifier).refresh(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            TtSpace.page,
            12,
            TtSpace.page,
            TtSpace.bottomClearance,
          ),
          children: [
            TtAppHeader(
              eyebrow: l10n.remindersTitle,
              title: l10n.remindersTitle,
              subtitle: l10n.remindersIntro,
              actions: [
                TtCircleIconButton(
                  icon: Icons.add_rounded,
                  tooltip: l10n.remindersTitle,
                  onPressed: () => _addReminder(context, ref, entries),
                ),
              ],
            ),
            const SizedBox(height: TtSpace.x4),
            if (garage.isLoading && items.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (items.isEmpty)
              TtCard(
                child: TtEmptyState(
                  icon: Icons.notifications_none_rounded,
                  title: l10n.noReminders,
                  body: l10n.noRemindersBody,
                  compact: true,
                  action: entries.isEmpty
                      ? null
                      : TtPrimaryButton(
                          label: l10n.addReminder,
                          icon: Icons.add_rounded,
                          onPressed: () => _addReminder(context, ref, entries),
                          expand: false,
                        ),
                ),
              )
            else ...[
              if (overdue.isNotEmpty) ...[
                TtSectionHeader(title: l10n.overdueGroup),
                const SizedBox(height: 6),
                for (final item in overdue) ...[
                  _ReminderCard(item: item),
                  const SizedBox(height: 8),
                ],
                const SizedBox(height: TtSpace.x3),
              ],
              if (soon.isNotEmpty) ...[
                TtSectionHeader(title: l10n.thisMonth),
                const SizedBox(height: 6),
                for (final item in soon) ...[
                  _ReminderCard(item: item),
                  const SizedBox(height: 8),
                ],
                const SizedBox(height: TtSpace.x3),
              ],
              if (later.isNotEmpty) ...[
                TtSectionHeader(title: l10n.laterGroup),
                const SizedBox(height: 6),
                for (final item in later) ...[
                  _ReminderCard(item: item),
                  const SizedBox(height: 8),
                ],
              ],
            ],
            const SizedBox(height: TtSpace.x4),
            Text(
              l10n.reminderSummary(items.length, entries.length),
              textAlign: TextAlign.center,
              style: TtType.caption(palette.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addReminder(
    BuildContext context,
    WidgetRef ref,
    List<GarageEntry> entries,
  ) async {
    if (entries.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.emptyGarageTitle)));
      return;
    }
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: _AddReminderSheet(entries: entries),
      ),
    );
  }
}

class _ReminderItem {
  const _ReminderItem({
    required this.reminder,
    required this.vehicleName,
    required this.assessment,
  });

  final Reminder reminder;
  final String vehicleName;
  final ReminderAssessment assessment;
}

class _ReminderCard extends ConsumerWidget {
  const _ReminderCard({required this.item});

  final _ReminderItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.palette;
    final l10n = context.l10n;
    final status = item.assessment.status;
    final tone =
        status == ReminderStatus.overdue || status == ReminderStatus.dueNow
        ? palette.error
        : status == ReminderStatus.dueSoon
        ? palette.warning
        : palette.primary;
    final icon = switch (item.reminder.type) {
      ReminderType.insurance => Icons.verified_user_outlined,
      ReminderType.roadTax => Icons.account_balance_outlined,
      ReminderType.pollution => Icons.eco_outlined,
      ReminderType.service => Icons.build_outlined,
    };
    final days = item.assessment.daysUntil;
    final timing = days == null
        ? ''
        : days < 0
        ? l10n.reminderOverdueBy(-days)
        : days == 0
        ? l10n.reminderDueToday
        : l10n.reminderDueIn(days);
    final km = item.assessment.kmUntil;

    return TtCard(
      padding: const EdgeInsets.all(13),
      borderColor: status == ReminderStatus.overdue
          ? palette.error.withValues(alpha: 0.4)
          : palette.border,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: tone.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: tone, size: 20),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.reminder.title,
                  style: TtType.label(palette.textPrimary, size: 13.5),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.vehicleName} · '
                  '${Fmt.dateWithBs(item.reminder.dueDate, nepali: context.isNepali)}',
                  style: TtType.caption(palette.textSecondary, size: 11),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    if (timing.isNotEmpty)
                      TtPill(
                        label: timing,
                        compact: true,
                        foreground: tone,
                        background: tone.withValues(alpha: 0.12),
                      ),
                    if (km != null)
                      TtPill(
                        label: km <= 0
                            ? l10n.reminderServiceDue
                            : l10n.reminderKmToTarget(Fmt.number(km)),
                        icon: Icons.speed_rounded,
                        compact: true,
                      ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            tooltip: l10n.commonEdit,
            onSelected: (value) async {
              final repo = ref.read(reminderRepositoryProvider);
              if (value == 'done') {
                await repo.setState(item.reminder.id, ReminderState.done);
              } else if (value == 'snooze') {
                await repo.update(
                  item.reminder.copyWith(
                    state: ReminderState.due,
                    dueDate: item.reminder.dueDate.add(
                      const Duration(days: 30),
                    ),
                  ),
                );
              }
              ref.invalidate(garageProvider);
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'done', child: Text(l10n.markDone)),
              PopupMenuItem(value: 'snooze', child: Text(l10n.snooze30)),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddReminderSheet extends ConsumerStatefulWidget {
  const _AddReminderSheet({required this.entries});

  final List<GarageEntry> entries;

  @override
  ConsumerState<_AddReminderSheet> createState() => _AddReminderSheetState();
}

class _AddReminderSheetState extends ConsumerState<_AddReminderSheet> {
  final _title = TextEditingController();
  final _odometer = TextEditingController();
  late String _vehicleId = widget.entries.first.vehicle.id;
  var _type = ReminderType.insurance;
  var _date = DateTime.now().add(const Duration(days: 30));
  var _busy = false;

  @override
  void dispose() {
    _title.dispose();
    _odometer.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _busy = true);
    try {
      final latest = widget.entries
          .firstWhere((entry) => entry.vehicle.id == _vehicleId)
          .latestKm;
      final target = int.tryParse(_odometer.text.trim());
      await ref
          .read(reminderRepositoryProvider)
          .insert(
            Reminder(
              id: const Uuid().v4(),
              vehicleId: _vehicleId,
              type: _type,
              title: _title.text.trim().isEmpty
                  ? _typeLabel(_type, context.l10n)
                  : _title.text.trim(),
              dueDate: _date,
              targetOdometer: _type == ReminderType.service
                  ? target ?? latest + 2500
                  : null,
            ),
          );
      ref.invalidate(garageProvider);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.errorGeneric)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.remindersTitle,
              style: TtType.title(palette.textPrimary, size: 20),
            ),
            const SizedBox(height: TtSpace.x4),
            Text(l10n.navGarage, style: TtType.label(palette.textSecondary)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _vehicleId,
              items: [
                for (final entry in widget.entries)
                  DropdownMenuItem(
                    value: entry.vehicle.id,
                    child: Text(
                      '${entry.vehicle.displayName} · ${entry.vehicle.plateRoman}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _vehicleId = value);
              },
            ),
            const SizedBox(height: TtSpace.x3),
            TtTextField(
              label: l10n.recordTitle,
              hint: l10n.reminderNewTitle,
              controller: _title,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: TtSpace.x3),
            Text(l10n.category, style: TtType.label(palette.textSecondary)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final type in ReminderType.values)
                  ChoiceChip(
                    selected: _type == type,
                    label: Text(_typeLabel(type, l10n)),
                    onSelected: (_) => setState(() => _type = type),
                  ),
              ],
            ),
            const SizedBox(height: TtSpace.x3),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now().add(const Duration(days: 3650)),
                );
                if (picked != null) setState(() => _date = picked);
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: l10n.selectDate,
                  prefixIcon: const Icon(Icons.event_outlined),
                ),
                child: Text(Fmt.dateWithBs(_date, nepali: context.isNepali)),
              ),
            ),
            if (_type == ReminderType.service) ...[
              const SizedBox(height: TtSpace.x3),
              TtTextField(
                label: '${l10n.odometerKm} target',
                hint: '18580',
                controller: _odometer,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ],
            const SizedBox(height: TtSpace.x4),
            TtPrimaryButton(
              label: l10n.commonSave,
              icon: Icons.check_rounded,
              loading: _busy,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }

  String _typeLabel(ReminderType type, AppLocalizations l10n) => switch (type) {
    ReminderType.insurance => l10n.categoryInsurance,
    ReminderType.roadTax => l10n.categoryTax,
    ReminderType.pollution => l10n.categoryPollution,
    ReminderType.service => l10n.categoryService,
  };
}
