import 'package:flutter/material.dart';

class AppStyles {
  static const Color primaryColor = Colors.deepOrange;

  static const TextStyle headerTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );

  static final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    foregroundColor: Colors.white
  );

  static const EdgeInsets containerPadding = EdgeInsets.all(16);

  static final ThemeData theme = ThemeData(
    colorScheme: ColorScheme.dark(primary: primaryColor)
  );
}
