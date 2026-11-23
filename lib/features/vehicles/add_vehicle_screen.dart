import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/l10n/field_errors.dart';
import '../../core/l10n/l10n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/tt_buttons.dart';
import '../../core/widgets/tt_card.dart';
import '../../core/widgets/tt_headers.dart';
import '../../core/widgets/tt_text_field.dart';
import '../../data/models/vehicle.dart';
import '../../data/repositories/repositories.dart';
import '../auth/session.dart';
import '../common/success_screen.dart';
import '../garage/garage_controller.dart';
import 'section_labels.dart';

class AddVehicleScreen extends ConsumerStatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  ConsumerState<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends ConsumerState<AddVehicleScreen> {
  final _form1 = GlobalKey<FormState>();
  final _form2 = GlobalKey<FormState>();
  final _form3 = GlobalKey<FormState>();

  final _make = TextEditingController();
  final _model = TextEditingController();
  final _year = TextEditingController(text: '2021');
  final _colour = TextEditingController();
  final _plateRoman = TextEditingController();
  final _plateDevanagari = TextEditingController();
  final _chassis = TextEditingController();
  final _engine = TextEditingController();
  final _odometer = TextEditingController();

  var _step = 0;
  var _busy = false;
  String _fuel = 'Petrol';
  String _transmission = 'Manual';
  String _province = 'Bagmati';

  @override
  void dispose() {
    for (final controller in [
      _make,
      _model,
      _year,
      _colour,
      _plateRoman,
      _plateDevanagari,
      _chassis,
      _engine,
      _odometer,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  bool _validStep() {
    final key = switch (_step) {
      0 => _form1,
      1 => _form2,
      _ => _form3,
    };
    return key.currentState?.validate() ?? false;
  }

  void _next() {
    if (!_validStep()) return;
    if (_step < 2) {
      setState(() => _step += 1);
    } else {
      _save();
    }
  }

  Future<void> _save() async {
    final user = ref.read(sessionProvider).value?.user;
    if (user == null) return;
    setState(() => _busy = true);
    try {
      final vehicle = Vehicle(
        id: const Uuid().v4(),
        ownerId: user.id,
        make: _make.text.trim(),
        model: _model.text.trim(),
        yearAd: int.parse(_year.text.trim()),
        plateRoman: _plateRoman.text.trim().toUpperCase(),
        plateDevanagari: _plateDevanagari.text.trim(),
        province: _province,
        fuel: _fuel,
        transmission: _transmission,
        color: _colour.text.trim().isEmpty ? null : _colour.text.trim(),
        chassisMasked: _chassis.text.trim().isEmpty
            ? null
            : _chassis.text.trim(),
        engineMasked: _engine.text.trim().isEmpty ? null : _engine.text.trim(),
        initialOdometer: int.tryParse(_odometer.text.trim()) ?? 0,
        createdAt: DateTime.now(),
      );
      await ref.read(vehicleRepositoryProvider).insert(vehicle);
      ref.invalidate(garageProvider);
      ref.invalidate(garageSummaryProvider);
      if (!mounted) return;
      final l10n = context.l10n;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (context) => SuccessScreen(
            title: l10n.vehicleAdded,
            body:
                '${vehicle.displayName} · ${vehicle.plateRoman}\n'
                '${l10n.noRecordsBody}',
            primaryLabel: l10n.viewTimeline,
            onPrimary: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                TtSpace.page,
                12,
                TtSpace.page,
                0,
              ),
              child: Column(
                children: [
                  const TtAppHeader(title: ''),
                  const SizedBox(height: TtSpace.x2),
                  Row(
                    children: [
                      for (var i = 0; i < 3; i++) ...[
                        if (i > 0) const SizedBox(width: 6),
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: i <= _step
                                  ? palette.primary
                                  : palette.surfaceRaisedAlt,
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        [
                          l10n.vehicleBasics,
                          l10n.registration,
                          l10n.review,
                        ][_step],
                        style: TtType.title(palette.textPrimary, size: 18),
                      ),
                      const Spacer(),
                      Text(
                        l10n.stepOf(_step + 1, 3),
                        style: TtType.caption(palette.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: switch (_step) {
                  0 => _basicsStep(l10n, palette),
                  1 => _registrationStep(l10n, palette),
                  _ => _reviewStep(l10n, palette),
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                TtSpace.page,
                8,
                TtSpace.page,
                16,
              ),
              child: Row(
                children: [
                  if (_step > 0) ...[
                    Expanded(
                      child: TtSecondaryButton(
                        label: l10n.commonBack,
                        onPressed: () => setState(() => _step -= 1),
                      ),
                    ),
                    const SizedBox(width: TtSpace.x2),
                  ],
                  Expanded(
                    flex: 2,
                    child: TtPrimaryButton(
                      label: _step == 2 ? l10n.saveVehicle : l10n.commonNext,
                      icon: _step == 2
                          ? Icons.check_rounded
                          : Icons.arrow_forward_rounded,
                      loading: _busy,
                      onPressed: _next,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _basicsStep(AppLocalizations l10n, TtPalette palette) {
    return Form(
      key: _form1,
      child: ListView(
        padding: const EdgeInsets.all(TtSpace.page),
        children: [
          TtTextField(
            label: l10n.make,
            hint: 'Honda',
            controller: _make,
            textCapitalization: TextCapitalization.words,
            required: true,
            validator: (value) =>
                fieldErrorText(Validators.requiredText(value), l10n),
          ),
          const SizedBox(height: TtSpace.x3),
          TtTextField(
            label: l10n.model,
            hint: 'Shine 125',
            controller: _model,
            textCapitalization: TextCapitalization.words,
            required: true,
            validator: (value) =>
                fieldErrorText(Validators.requiredText(value), l10n),
          ),
          const SizedBox(height: TtSpace.x3),
          TtTextField(
            label: l10n.year,
            hint: '2021',
            controller: _year,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
            required: true,
            validator: (value) => fieldErrorText(Validators.year(value), l10n),
          ),
          const SizedBox(height: TtSpace.x3),
          _Dropdown(
            label: l10n.fuel,
            value: _fuel,
            items: const ['Petrol', 'Diesel', 'Electric', 'Hybrid', 'CNG'],
            labelOf: (item) => fuelLabel(item, l10n),
            onChanged: (value) => setState(() => _fuel = value),
          ),
          const SizedBox(height: TtSpace.x3),
          _Dropdown(
            label: l10n.transmission,
            value: _transmission,
            items: const ['Manual', 'Automatic', 'AMT', 'CVT'],
            labelOf: (item) => transmissionLabel(item, l10n),
            onChanged: (value) => setState(() => _transmission = value),
          ),
          const SizedBox(height: TtSpace.x3),
          TtTextField(
            label: l10n.colour,
            hint: l10n.colourHint,
            controller: _colour,
            textCapitalization: TextCapitalization.words,
          ),
        ],
      ),
    );
  }

  Widget _registrationStep(AppLocalizations l10n, TtPalette palette) {
    return Form(
      key: _form2,
      child: ListView(
        padding: const EdgeInsets.all(TtSpace.page),
        children: [
          TtTextField(
            label: l10n.plateRoman,
            hint: 'BA 2 PA 1234',
            controller: _plateRoman,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [LengthLimitingTextInputFormatter(14)],
            required: true,
            validator: (value) => fieldErrorText(
              Validators.requiredText(value, minLength: 4),
              l10n,
            ),
          ),
          const SizedBox(height: TtSpace.x3),
          TtTextField(
            label: l10n.plateDevanagari,
            hint: 'बा २ प १२३४',
            controller: _plateDevanagari,
            helper: l10n.devanagariHelper,
          ),
          const SizedBox(height: TtSpace.x3),
          _Dropdown(
            label: l10n.province,
            value: _province,
            items: const [
              'Koshi',
              'Madhesh',
              'Bagmati',
              'Gandaki',
              'Lumbini',
              'Karnali',
              'Sudurpashchim',
            ],
            labelOf: (item) => provinceLabel(item, l10n),
            onChanged: (value) => setState(() => _province = value),
          ),
          const SizedBox(height: TtSpace.x3),
          TtTextField(
            label: l10n.chassis,
            hint: l10n.chassisHint,
            controller: _chassis,
            textCapitalization: TextCapitalization.characters,
          ),
          const SizedBox(height: TtSpace.x3),
          TtTextField(
            label: l10n.engineNo,
            hint: 'JA12E123456',
            controller: _engine,
            textCapitalization: TextCapitalization.characters,
          ),
          const SizedBox(height: TtSpace.x3),
          TtTextField(
            label: l10n.initialOdometer,
            hint: '18240',
            controller: _odometer,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            required: true,
            validator: (value) => fieldErrorText(
              Validators.positiveInt(value, allowZero: true),
              l10n,
            ),
          ),
        ],
      ),
    );
  }

  Widget _reviewStep(AppLocalizations l10n, TtPalette palette) {
    final rows = <(String, String)>[
      (l10n.make, _make.text.trim()),
      (l10n.model, _model.text.trim()),
      (l10n.year, _year.text.trim()),
      (l10n.plateRoman, _plateRoman.text.trim().toUpperCase()),
      (
        l10n.plateDevanagari,
        _plateDevanagari.text.trim().isEmpty
            ? '—'
            : _plateDevanagari.text.trim(),
      ),
      (l10n.province, provinceLabel(_province, l10n)),
      (l10n.fuel, fuelLabel(_fuel, l10n)),
      (l10n.transmission, transmissionLabel(_transmission, l10n)),
      (l10n.chassis, _chassis.text.trim().isEmpty ? '—' : _chassis.text.trim()),
      (l10n.engineNo, _engine.text.trim().isEmpty ? '—' : _engine.text.trim()),
      (
        l10n.initialOdometer,
        _odometer.text.trim().isEmpty ? '0' : _odometer.text.trim(),
      ),
    ];
    return Form(
      key: _form3,
      child: ListView(
        padding: const EdgeInsets.all(TtSpace.page),
        children: [
          TtCard(
            child: Column(
              children: [
                for (var i = 0; i < rows.length; i++) ...[
                  if (i > 0) Divider(height: 18, color: palette.border),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          rows[i].$1,
                          style: TtType.caption(palette.textSecondary),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          rows[i].$2,
                          textAlign: TextAlign.right,
                          style: TtType.label(palette.textPrimary, size: 12.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: TtSpace.x4),
          Text(
            l10n.addVehicleEvidenceNote,
            style: TtType.caption(palette.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _Dropdown extends StatelessWidget {
  const _Dropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.labelOf,
  });

  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final String Function(String)? labelOf;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 6),
          child: Text(
            label,
            style: TtType.label(palette.textSecondary, size: 12.5),
          ),
        ),
        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          items: [
            for (final item in items)
              DropdownMenuItem(
                value: item,
                child: Text(labelOf?.call(item) ?? item),
              ),
          ],
          onChanged: (next) {
            if (next != null) onChanged(next);
          },
          style: TtType.body(palette.textPrimary, size: 15),
          decoration: const InputDecoration(),
        ),
      ],
    );
  }
}
