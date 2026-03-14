import 'package:flutter/material.dart';
import 'package:my_first_app/data/constants.dart';
import 'package:my_first_app/data/notifiers.dart';
import 'package:my_first_app/views/pages/welcome_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:provider/provider.dart';
import 'package:my_first_app/data/budget_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => BudgetProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    initThemeMode();
    super.initState();
  }

  void initThemeMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? saved = prefs.getBool(KConstants.themeModeKey);
    isDarkModeNotifier.value = saved ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Budget Tracker',
          home: const WelcomePage(),
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: ColorScheme.light(
              primary: KConstants.primary,
              secondary: KConstants.accent,
              surface: KConstants.surfaceLight,
              onPrimary: Colors.white,
              onSurface: KConstants.surfaceDark,
            ),
            scaffoldBackgroundColor: const Color(0xFFF1F5F9),
            appBarTheme: AppBarTheme(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.transparent,
              foregroundColor: KConstants.surfaceDark,
              titleTextStyle: const TextStyle(
                color: KConstants.surfaceDark,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            cardTheme: CardThemeData(
              elevation: 0,
              color: KConstants.cardLight,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            textTheme: Typography.material2021().black.merge(
              const TextTheme(
                headlineLarge: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.5),
                headlineMedium: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.5),
                titleLarge: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.dark(
              primary: KConstants.primary,
              secondary: KConstants.accent,
              surface: KConstants.surfaceDark,
              onPrimary: Colors.white,
              onSurface: Colors.white,
            ),
            scaffoldBackgroundColor: const Color(0xFF0A0F1A),
            appBarTheme: AppBarTheme(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              titleTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            cardTheme: CardThemeData(
              elevation: 0,
              color: KConstants.cardDark,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            textTheme: Typography.material2021().white.merge(
              const TextTheme(
                headlineLarge: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.5),
                headlineMedium: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.5),
                titleLarge: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
        );
      },
    );
  }
}
