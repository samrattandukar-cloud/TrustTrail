import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class TtTextField extends StatelessWidget {
  const TtTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.helper,
    this.errorText,
    this.keyboardType,
    this.inputFormatters,
    this.prefixIcon,
    this.suffix,
    this.maxLines = 1,
    this.minLines,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.onTap,
    this.enabled = true,
    this.readOnly = false,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.autofocus = false,
    this.initialValue,
    this.required = false,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final String? helper;
  final String? errorText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final IconData? prefixIcon;
  final Widget? suffix;
  final int maxLines;
  final int? minLines;
  final bool obscureText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool enabled;
  final bool readOnly;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final String? initialValue;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 6),
          child: Row(
            children: [
              Text(
                label,
                style: TtType.label(palette.textSecondary, size: 12.5),
              ),
              if (required)
                Text(' *', style: TtType.label(palette.error, size: 12.5)),
            ],
          ),
        ),
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          minLines: minLines,
          obscureText: obscureText,
          validator: validator,
          onChanged: onChanged,
          onTap: onTap,
          enabled: enabled,
          readOnly: readOnly,
          textCapitalization: textCapitalization,
          textInputAction: textInputAction,
          autofocus: autofocus,
          style: TtType.body(palette.textPrimary, size: 15),
          cursorColor: palette.primary,
          decoration: InputDecoration(
            hintText: hint,
            helperText: helper,
            errorText: errorText,
            prefixIcon: prefixIcon == null
                ? null
                : Icon(prefixIcon, size: 20, color: palette.textSecondary),
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}

class TtSearchField extends StatelessWidget {
  const TtSearchField({
    super.key,
    this.hint,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.trailing,
    this.textInputAction = TextInputAction.search,
  });

  final String? hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;
  final Widget? trailing;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      autofocus: autofocus,
      textInputAction: textInputAction,
      style: TtType.body(palette.textPrimary),
      cursorColor: palette.primary,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(
          Icons.search_rounded,
          size: 21,
          color: palette.textSecondary,
        ),
        suffixIcon: trailing,
      ),
    );
  }
}
