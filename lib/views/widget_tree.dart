import 'package:flutter/material.dart';
import 'package:my_first_app/data/constants.dart';
import 'package:my_first_app/data/notifiers.dart';
import 'package:my_first_app/views/pages/add_transaction_page.dart';
import 'package:my_first_app/views/pages/home_page.dart';
import 'package:my_first_app/views/pages/settings_page.dart';
import 'package:my_first_app/views/pages/transactions_page.dart';
import 'package:my_first_app/views/pages/welcome_page.dart';
import 'package:my_first_app/widgets/navbar_widget.dart' show NavbarWidget;
import 'package:shared_preferences/shared_preferences.dart';

final List<Widget> pages = [
  const HomePage(),
  const TransactionsPage(embedded: true),
  const SettingsPage(title: 'Settings'),
];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Tracker'),
        centerTitle: true,
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: isDarkModeNotifier,
            builder: (context, isDarkMode, child) {
              return IconButton(
                icon: Icon(isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded),
                onPressed: () async {
                  isDarkModeNotifier.value = !isDarkModeNotifier.value;
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setBool(KConstants.themeModeKey, isDarkModeNotifier.value);
                },
              );
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(title: 'Settings'),
                ),
              );
            },
            icon: const Icon(Icons.settings_rounded),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF059669),
                    Color(0xFF0D9488),
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white24,
                      child: const Icon(Icons.person_rounded, size: 28, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Budget Tracker',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Track every dollar',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard_rounded),
              title: const Text('Dashboard'),
              onTap: () {
                selectedvalueNotifier.value = 0;
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_alt_rounded),
              title: const Text('Transactions'),
              onTap: () {
                selectedvalueNotifier.value = 1;
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_rounded),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(title: 'Settings'),
                  ),
                );
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout_rounded),
              title: const Text('Log out'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WelcomePage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: selectedvalueNotifier,
        builder: (context, value, child) {
          if (value == 1) {
            return const TransactionsPage();
          }
          return pages.elementAt(value);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransactionPage(),
            ),
          );
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add'),
        backgroundColor: KConstants.primary,
      ),
      bottomNavigationBar: NavbarWidget(),
    );
  }
}
