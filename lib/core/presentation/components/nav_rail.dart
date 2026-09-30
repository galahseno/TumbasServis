import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/components/nav_bar.dart'
    show NavBarItem;
import 'package:tumbas_servis/core/presentation/components/ts_logo.dart';

const _navRailItems = [
  NavBarItem(icon: Icons.home_rounded, label: 'Beranda'),
  NavBarItem(icon: Icons.history_rounded, label: 'Riwayat'),
  NavBarItem(icon: Icons.two_wheeler_rounded, label: 'Garasi'),
  NavBarItem(icon: Icons.person_rounded, label: 'Profil'),
];

class NavRail extends StatelessWidget {
  const NavRail({
    required this.currentIndex,
    required this.onTap,
    super.key,
    this.extended = false,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool extended;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return NavigationRail(
      extended: extended,
      minWidth: 80,
      minExtendedWidth: 240,
      backgroundColor: scheme.surface,
      indicatorColor: scheme.primaryContainer,
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      leading: const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: TsLogo(),
      ),
      labelType: extended
          ? NavigationRailLabelType.none
          : NavigationRailLabelType.all,
      selectedIconTheme: IconThemeData(color: scheme.onPrimaryContainer),
      selectedLabelTextStyle: Theme.of(
        context,
      ).textTheme.labelMedium?.copyWith(color: scheme.onSurface),
      unselectedIconTheme: IconThemeData(color: scheme.onSurface),
      unselectedLabelTextStyle: Theme.of(
        context,
      ).textTheme.labelMedium?.copyWith(color: scheme.onSurface),
      destinations: [
        for (final item in _navRailItems)
          NavigationRailDestination(
            padding: EdgeInsets.zero,
            icon: Icon(item.icon),
            label: Text(item.label),
          ),
      ],
    );
  }
}
