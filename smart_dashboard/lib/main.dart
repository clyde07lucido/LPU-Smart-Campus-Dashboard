import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'utils/colors.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // One shared theme = no need to repeat AppBar/button styles on every screen.
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    );

    return MaterialApp(
      title: 'LPU Smart Campus Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: lpuRed).copyWith(
          primary: lpuRed,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: lpuRed,
          foregroundColor: lpuWhite,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: lpuWhite,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: lpuRed,
            foregroundColor: lpuWhite,
            minimumSize: const Size.fromHeight(48),
            shape: buttonShape,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: lpuRed,
            minimumSize: const Size.fromHeight(48),
            shape: buttonShape,
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}
