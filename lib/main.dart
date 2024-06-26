import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/expenses.dart';

var kColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 187, 0));

var kDarkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 123, 88, 0));
var isDarkMode = ThemeMode.system;

void main() {
  // WidgetsFlutterBinding.ensureInitialized(); -----to lock potrait orientation
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  // ]).then((fn) {
  runApp(MaterialApp(
    darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: kDarkColorScheme.primaryContainer,
            foregroundColor: kDarkColorScheme.onPrimaryContainer,
            titleTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            )),
        cardTheme: const CardTheme().copyWith(
            color: kDarkColorScheme.primaryContainer,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15)),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                backgroundColor: kDarkColorScheme.primaryContainer,
                foregroundColor: kDarkColorScheme.onPrimaryContainer))),
    theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: kColorScheme.onPrimaryContainer,
            foregroundColor: kColorScheme.primaryContainer,
            titleTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            )),
        cardTheme: const CardTheme().copyWith(
            color: kColorScheme.primaryContainer,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15)),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                backgroundColor: kColorScheme.primaryContainer,
                foregroundColor: kColorScheme.onPrimaryContainer))),
    home: Expenses(isDarkMode),
    themeMode: isDarkMode,
  ));
  // });
}
