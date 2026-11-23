import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/l10n/field_errors.dart';
import '../../core/l10n/l10n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/tt_buttons.dart';
import '../../core/widgets/tt_headers.dart';
import '../../core/widgets/tt_text_field.dart';
import '../../data/models/vehicle_record.dart';
import '../../data/repositories/repositories.dart';
import '../common/success_screen.dart';
import '../garage/garage_controller.dart';
import '../vehicles/vehicle_bundle.dart';
import 'category_style.dart';
import 'record_detail_screen.dart';

class RecordFormScreen extends ConsumerStatefulWidget {
  const RecordFormScreen({super.key, required this.vehicleId, this.existing});

  final String vehicleId;
  final VehicleRecord? existing;

  @override
  ConsumerState<RecordFormScreen> createState() => _RecordFormScreenState();
}

class _RecordFormScreenState extends ConsumerState<RecordFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title = TextEditingController(
    text: widget.existing?.title ?? '',
  );
  late final TextEditingController _workshop = TextEditingController(
    text: widget.existing?.workshop ?? '',
  );
  late final TextEditingController _odometer = TextEditingController(
    text: widget.existing?.odometerKm?.toString() ?? '',
  );
  late final TextEditingController _cost = TextEditingController(
    text: widget.existing?.costNpr?.toString() ?? '',
  );
  late final TextEditingController _documentNo = TextEditingController(
    text: widget.existing?.documentNo ?? '',
  );
  late final TextEditingController _notes = TextEditingController(
    text: widget.existing?.description ?? '',
  );

  late RecordCategory _category =
      widget.existing?.category ?? RecordCategory.service;
  late RecordSource _source =
      widget.existing?.source ?? RecordSource.ownerRecorded;
  late DateTime _date = widget.existing?.eventDate ?? DateTime.now();
  var _busy = false;

  bool get _isEditing => widget.existing != null;

  @override
  void dispose() {
    for (final controller in [
      _title,
      _workshop,
      _odometer,
      _cost,
      _documentNo,
      _notes,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (_formKey.currentState?.validate() != true) return;
    setState(() => _busy = true);
    try {
      final repo = ref.read(recordRepositoryProvider);
      final record = VehicleRecord(
        id: widget.existing?.id ?? const Uuid().v4(),
        vehicleId: widget.vehicleId,
        category: _category,
        title: _title.text.trim(),
        description: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
        eventDate: _date,
        odometerKm: int.tryParse(_odometer.text.trim()),
        workshop: _workshop.text.trim().isEmpty ? null : _workshop.text.trim(),
        costNpr: int.tryParse(_cost.text.trim()),
        documentNo: _documentNo.text.trim().isEmpty
            ? null
            : _documentNo.text.trim(),
        source: _source,
        createdAt: widget.existing?.createdAt ?? DateTime.now(),
      );
      if (_isEditing) {
        await repo.update(record);
      } else {
        await repo.insert(record);
      }
      ref.invalidate(vehicleBundleProvider(widget.vehicleId));
      ref.invalidate(garageProvider);
      ref.invalidate(garageSummaryProvider);
      if (!mounted) return;

      if (_isEditing) {
        Navigator.of(context).pop();
        return;
      }
      final l10n = context.l10n;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (context) => SuccessScreen(
            title: l10n.recordSaved,
            body:
                '${record.title} · ${Fmt.dateWithBs(record.eventDate, nepali: context.isNepali)}',
            primaryLabel: l10n.attachEvidence,
            onPrimary: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) =>
                    RecordDetailScreen(recordId: record.id, justSaved: true),
              ),
            ),
            secondaryLabel: l10n.commonDone,
            onSecondary: () => Navigator.of(context).pop(),
          ),
        ),
      );
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

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(TtSpace.page),
            children: [
              TtAppHeader(title: _isEditing ? l10n.commonEdit : l10n.addRecord),
              const SizedBox(height: TtSpace.x3),
              _FieldLabel(l10n.category),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final category in RecordCategory.values)
                    ChoiceChip(
                      selected: _category == category,
                      onSelected: (_) => setState(() => _category = category),
                      avatar: Icon(
                        category.icon,
                        size: 16,
                        color: _category == category
                            ? palette.onPrimary
                            : palette.textSecondary,
                      ),
                      label: Text(category.label(l10n)),
                    ),
                ],
              ),
              const SizedBox(height: TtSpace.x4),
              TtTextField(
                label: l10n.recordTitle,
                hint: 'Full service at 18,240 km',
                controller: _title,
                textCapitalization: TextCapitalization.sentences,
                required: true,
                validator: (value) => fieldErrorText(
                  Validators.requiredText(value, minLength: 3),
                  l10n,
                ),
              ),
              const SizedBox(height: TtSpace.x3),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: l10n.date,
                    prefixIcon: const Icon(Icons.event_outlined, size: 20),
                  ),
                  child: Text(
                    Fmt.dateWithBs(_date, nepali: context.isNepali),
                    style: TtType.body(palette.textPrimary),
                  ),
                ),
              ),
              const SizedBox(height: TtSpace.x3),
              TtTextField(
                label: l10n.odometerKm,
                hint: '18240',
                controller: _odometer,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) => fieldErrorText(
                  value == null || value.trim().isEmpty
                      ? null
                      : Validators.positiveInt(value, allowZero: true),
                  l10n,
                ),
              ),
              const SizedBox(height: TtSpace.x3),
              TtTextField(
                label: l10n.workshop,
                hint: 'Sajha Auto Works',
                controller: _workshop,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: TtSpace.x3),
              TtTextField(
                label: l10n.cost,
                hint: '1250',
                controller: _cost,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) => fieldErrorText(
                  value == null || value.trim().isEmpty
                      ? null
                      : Validators.positiveInt(value, allowZero: true),
                  l10n,
                ),
              ),
              const SizedBox(height: TtSpace.x3),
              TtTextField(
                label: l10n.documentNo,
                hint: 'INV-2026-0412',
                controller: _documentNo,
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: TtSpace.x3),
              _FieldLabel(l10n.source),
              DropdownButtonFormField<RecordSource>(
                initialValue: _source,
                isExpanded: true,
                items: [
                  for (final source in RecordSource.values)
                    DropdownMenuItem(
                      value: source,
                      child: Text(_sourceLabel(source, l10n)),
                    ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _source = value);
                },
              ),
              const SizedBox(height: TtSpace.x3),
              TtTextField(
                label: l10n.notes,
                hint: 'Parts replaced, observations…',
                controller: _notes,
                maxLines: 3,
                minLines: 2,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: TtSpace.x5),
              TtPrimaryButton(
                label: l10n.saveRecord,
                icon: Icons.check_rounded,
                loading: _busy,
                onPressed: _save,
              ),
              const SizedBox(height: TtSpace.x4),
            ],
          ),
        ),
      ),
    );
  }

  String _sourceLabel(RecordSource source, AppLocalizations l10n) =>
      switch (source) {
        RecordSource.ownerRecorded => l10n.sourceOwner,
        RecordSource.workshopReceipt => l10n.sourceWorkshop,
        RecordSource.officialDocument => l10n.sourceOfficial,
      };
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 6),
      child: Text(
        text,
        style: TtType.label(context.palette.textSecondary, size: 12.5),
      ),
    );
  }
}
