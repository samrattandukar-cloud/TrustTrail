import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
import 'login_screen.dart';
import 'otp_screen.dart';
import 'session.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  var _consent = false;
  var _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() => _consentTouched = true);
    if (!_consent) return;
    if (_formKey.currentState?.validate() != true) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => OtpScreen(
          name: _name.text.trim(),
          phone: _phone.text.trim(),
          email: _email.text.trim().isEmpty ? null : _email.text.trim(),
        ),
      ),
    );
  }

  var _consentTouched = false;

  Future<void> _demo() async {
    setState(() => _busy = true);
    try {
      await ref.read(sessionProvider.notifier).signInDemo();
      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
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
              const TtAppHeader(),
              const SizedBox(height: TtSpace.x4),
              Text(
                l10n.registerTitle,
                style: TtType.headline(palette.textPrimary),
              ),
              const SizedBox(height: TtSpace.x1),
              Text(
                '${l10n.demoBuild} ${l10n.ownerRoleBody}',
                style: TtType.caption(palette.textSecondary),
              ),
              const SizedBox(height: TtSpace.x5),
              TtTextField(
                label: l10n.fullName,
                hint: 'Sujan Bajracharya',
                controller: _name,
                prefixIcon: Icons.person_outline_rounded,
                textCapitalization: TextCapitalization.words,
                required: true,
                validator: (value) => fieldErrorText(
                  Validators.requiredText(value, minLength: 2),
                  l10n,
                ),
              ),
              const SizedBox(height: TtSpace.x3),
              TtTextField(
                label: l10n.phoneNumber,
                hint: '98XXXXXXXX',
                controller: _phone,
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s-]')),
                  LengthLimitingTextInputFormatter(17),
                ],
                required: true,
                validator: (value) =>
                    fieldErrorText(Validators.phone(value), l10n),
              ),
              const SizedBox(height: TtSpace.x3),
              TtTextField(
                label: l10n.emailOptional,
                hint: 'you@example.com',
                controller: _email,
                prefixIcon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: TtSpace.x3),
              TtCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: CheckboxListTile(
                  value: _consent,
                  onChanged: (value) => setState(() {
                    _consent = value ?? false;
                    _consentTouched = true;
                  }),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    l10n.consent,
                    style: TtType.bodyMedium(palette.textPrimary),
                  ),
                ),
              ),
              if (_consentTouched && !_consent)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Text(
                    l10n.requiredField,
                    style: TtType.caption(palette.error),
                  ),
                ),
              const SizedBox(height: TtSpace.x5),
              TtPrimaryButton(
                label: l10n.sendOtp,
                icon: Icons.sms_outlined,
                loading: _busy,
                onPressed: _submit,
              ),
              const SizedBox(height: TtSpace.x2),
              TtSecondaryButton(
                label: l10n.continueDemo,
                icon: Icons.bolt_rounded,
                onPressed: _busy ? null : _demo,
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
