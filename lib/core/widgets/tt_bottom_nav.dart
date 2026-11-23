import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class TtBottomNav extends StatelessWidget {
  const TtBottomNav({
    super.key,
    required this.index,
    required this.onSelect,
    required this.labels,
    required this.icons,
  });

  final int index;
  final ValueChanged<int> onSelect;
  final List<String> labels;
  final List<IconData> icons;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(top: BorderSide(color: palette.border)),
        boxShadow: [
          BoxShadow(
            color: palette.shadow,
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: 6,
        bottom: bottomInset > 0 ? bottomInset : 6,
      ),
      child: SizedBox(
        height: 58,
        child: Row(
          children: [
            _NavItem(
              label: labels[0],
              icon: icons[0],
              selected: index == 0,
              onTap: () => onSelect(0),
            ),
            _NavItem(
              label: labels[1],
              icon: icons[1],
              selected: index == 1,
              onTap: () => onSelect(1),
            ),
            const SizedBox(width: 68),
            _NavItem(
              label: labels[2],
              icon: icons[2],
              selected: index == 2,
              onTap: () => onSelect(2),
            ),
            _NavItem(
              label: labels[3],
              icon: icons[3],
              selected: index == 3,
              onTap: () => onSelect(3),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final color = selected ? palette.primary : palette.textSecondary;
    return Expanded(
      child: Semantics(
        selected: selected,
        button: true,
        label: label,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 23, color: color),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TtType.label(color, size: 10.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
