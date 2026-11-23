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
import '../../core/widgets/tt_headers.dart';
import '../../core/widgets/tt_status_banner.dart';
import '../../core/widgets/tt_text_field.dart';
import '../common/success_screen.dart';
import 'session.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({
    super.key,
    required this.name,
    required this.phone,
    this.email,
  });

  final String name;
  final String phone;
  final String? email;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _code = TextEditingController();
  var _busy = false;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    if (_formKey.currentState?.validate() != true) return;
    setState(() => _busy = true);
    try {
      await ref
          .read(sessionProvider.notifier)
          .register(
            name: widget.name,
            phone: widget.phone,
            email: widget.email,
          );
      if (!mounted) return;
      final l10n = context.l10n;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (context) => SuccessScreen(
            title: l10n.allSet,
            body: '${l10n.registerTitle} · ${l10n.demoBuild}',
            primaryLabel: l10n.commonContinue,
            onPrimary: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
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
              const TtAppHeader(),
              const SizedBox(height: TtSpace.x4),
              Text(l10n.otpTitle, style: TtType.headline(palette.textPrimary)),
              const SizedBox(height: TtSpace.x2),
              Text(
                l10n.otpSentTo(widget.phone),
                style: TtType.bodyMedium(palette.textSecondary),
              ),
              const SizedBox(height: TtSpace.x5),
              TtTextField(
                label: l10n.otpCodeLabel,
                hint: '123456',
                controller: _code,
                keyboardType: TextInputType.number,
                autofocus: true,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                validator: (value) =>
                    fieldErrorText(Validators.otp(value), l10n),
              ),
              const SizedBox(height: TtSpace.x3),
              TtStatusBanner(
                message: l10n.demoOtpHint,
                tone: TtBannerTone.info,
              ),
              const SizedBox(height: TtSpace.x5),
              TtPrimaryButton(
                label: l10n.verify,
                icon: Icons.lock_open_rounded,
                loading: _busy,
                onPressed: _verify,
              ),
              Center(
                child: TextButton(
                  onPressed: () => ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(l10n.demoOtpHint))),
                  child: Text(l10n.resendCode),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
