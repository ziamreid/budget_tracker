import 'package:flutter/material.dart';
import 'package:my_first_app/data/constants.dart';
import 'package:my_first_app/data/notifiers.dart';

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: selectedvalueNotifier,
      builder: (context, selectedPage, child) {
        return NavigationBar(
          selectedIndex: selectedPage.clamp(0, 2),
          onDestinationSelected: (int value) {
            selectedvalueNotifier.value = value;
          },
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? KConstants.cardDark
              : Colors.white,
          indicatorColor: KConstants.primary.withValues(alpha: 0.2),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_rounded),
              selectedIcon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.list_alt_rounded),
              selectedIcon: Icon(Icons.list_alt_rounded),
              label: 'Transactions',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_rounded),
              selectedIcon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        );
      },
    );
  }
}
