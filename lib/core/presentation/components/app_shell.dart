import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tumbas_servis/core/presentation/components/nav_bar.dart';
import 'package:tumbas_servis/core/presentation/components/nav_rail.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < 600) {
      return Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavBar(
          currentIndex: navigationShell.currentIndex,
          onTap: _onTap,
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          NavRail(
            currentIndex: navigationShell.currentIndex,
            onTap: _onTap,
            extended: width >= 1200,
          ),
          const VerticalDivider(width: 1),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }
}
