import 'package:flutter/material.dart';

class AppStyles {
  // Theme: green, white and purple
  static const Color primaryColor = Color(0xFFFFFFFF); // white background
  static const Color secondaryColor = Color(0xFF3A6F43); // green accent
  static const Color accentPurple = Color(0xFF6A4BCF); // purple accent
  static const Color darkColor =
      Color(0xFF1B2330); // dark text/background contrast
  static const Color textColor = Color(0xFF0F1724); // primary text
  static const Color cardColor =
      Color(0xFFF7F8FB); // subtle off-white for cards
  static const Color buttonColor = Color(0xFF357C3C); // green button (kept)

  static const TextStyle headline1 = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle bodyText1 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: textColor,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const String fontFamily = 'Roboto';

  // Chat bubble colors aligned to green/purple theme
  static const Color userBubbleColor = accentPurple; // purple for user messages
  static const Color botBubbleColor =
      Color(0xFFEFF3FF); // very light purple/white for bot
  static const Color userTextColor = Colors.white;
  static const Color botTextColor = textColor;
  static const Color sendButtonColor = secondaryColor; // green send button
}
