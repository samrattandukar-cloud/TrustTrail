import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'tt_card.dart';

Future<T?> showTtSheet<T>(
  BuildContext context, {
  required Widget child,
  bool dismissible = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    isDismissible: dismissible,
    enableDrag: dismissible,
    useSafeArea: true,
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(sheetContext).size.height * 0.9,
          ),
          child: SingleChildScrollView(child: child),
        ),
      );
    },
  );
}

class TtSheetHandle extends StatelessWidget {
  const TtSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.palette.border,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

Future<bool> showTtConfirmSheet(
  BuildContext context, {
  required String title,
  required String body,
  required String confirmLabel,
  String? cancelLabel,
  bool destructive = false,
}) async {
  final palette = context.palette;
  final result = await showTtSheet<bool>(
    context,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(child: TtSheetHandle()),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            body,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: palette.textSecondary),
          ),
          const SizedBox(height: 20),
          FilledButton(
            style: destructive
                ? FilledButton.styleFrom(backgroundColor: palette.error)
                : null,
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmLabel),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              cancelLabel ??
                  MaterialLocalizations.of(context).cancelButtonLabel,
            ),
          ),
        ],
      ),
    ),
  );
  return result ?? false;
}

class TtInfoTile extends StatelessWidget {
  const TtInfoTile({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.trailing,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return TtCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: palette.textSecondary),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 2),
                Text(value, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
