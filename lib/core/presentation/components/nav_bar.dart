import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class NavBarItem {
  const NavBarItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

const _navBarItems = [
  NavBarItem(icon: Icons.home_rounded, label: 'Beranda'),
  NavBarItem(icon: Icons.history_rounded, label: 'Riwayat'),
  NavBarItem(icon: Icons.two_wheeler_rounded, label: 'Garasi'),
  NavBarItem(icon: Icons.person_rounded, label: 'Profil'),
];

class NavBar extends StatelessWidget {
  const NavBar({required this.currentIndex, required this.onTap, super.key});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 12 + MediaQuery.paddingOf(context).bottom,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: ext.glassTintStrong,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: ext.glassBorder),
              boxShadow: ext.glassShadow,
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(height: 1, color: ext.glassSheenTop),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(height: 1, color: ext.glassSheenBottom),
                ),
                Positioned.fill(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var i = 0; i < _navBarItems.length; i++)
                        Expanded(
                          child: _NavBarTab(
                            item: _navBarItems[i],
                            selected: i == currentIndex,
                            onTap: () => onTap(i),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarTab extends StatefulWidget {
  const _NavBarTab({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final NavBarItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_NavBarTab> createState() => _NavBarTabState();
}

class _NavBarTabState extends State<_NavBarTab> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final scheme = Theme.of(context).colorScheme;
    final labelColor = widget.selected
        ? scheme.onPrimaryContainer
        : scheme.onSurface;

    return Focus(
      onFocusChange: (value) => setState(() => _focused = value),
      child: Semantics(
        button: true,
        selected: widget.selected,
        label: widget.item.label,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: widget.selected ? scheme.primaryContainer : null,
                  borderRadius: BorderRadius.circular(999),
                  border: _focused
                      ? Border.all(color: ext.focusRing, width: 2)
                      : null,
                ),
                child: Icon(widget.item.icon, size: 24, color: labelColor),
              ),
              const SizedBox(height: 2),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.item.label,
                    maxLines: 1,
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.copyWith(color: labelColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
