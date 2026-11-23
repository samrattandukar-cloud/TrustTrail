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
import '../../core/widgets/tt_logo.dart';
import '../../core/widgets/tt_text_field.dart';
import '../onboarding/role_screen.dart';
import 'forgot_password_screen.dart';
import 'session.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();
  var _busy = false;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_formKey.currentState?.validate() != true) return;
    setState(() => _busy = true);
    try {
      await ref.read(sessionProvider.notifier).signIn(_phone.text.trim());
      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FormatException {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.loginNoAccount)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.errorGeneric)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

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

  void _createAccount() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const RoleScreen()));
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
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: TtSpace.x4),
              const TtLogo(size: 46),
              const SizedBox(height: TtSpace.x6),
              Text(
                l10n.loginTitle,
                style: TtType.headline(palette.textPrimary),
              ),
              const SizedBox(height: TtSpace.x1),
              Text(
                l10n.tagline,
                style: TtType.bodyMedium(palette.textSecondary),
              ),
              const SizedBox(height: TtSpace.x6),
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
                validator: (value) =>
                    fieldErrorText(Validators.phone(value), l10n),
              ),
              const SizedBox(height: TtSpace.x4),
              TtPrimaryButton(
                label: l10n.sendOtp,
                icon: Icons.login_rounded,
                loading: _busy,
                onPressed: _signIn,
              ),
              const SizedBox(height: TtSpace.x2),
              TtSecondaryButton(
                label: l10n.continueDemo,
                icon: Icons.bolt_rounded,
                onPressed: _busy ? null : _demo,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const ForgotPasswordScreen(),
                    ),
                  ),
                  child: Text(l10n.forgotPassword),
                ),
              ),
              const SizedBox(height: TtSpace.x4),
              Row(
                children: [
                  Expanded(child: Divider(color: palette.border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      l10n.orDivider,
                      style: TtType.caption(palette.textSecondary),
                    ),
                  ),
                  Expanded(child: Divider(color: palette.border)),
                ],
              ),
              const SizedBox(height: TtSpace.x4),
              TtSecondaryButton(
                label: l10n.registerTitle,
                icon: Icons.person_add_alt_1_rounded,
                onPressed: _createAccount,
              ),
              const SizedBox(height: TtSpace.x4),
              Text(
                l10n.demoBuild,
                textAlign: TextAlign.center,
                style: TtType.caption(palette.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
