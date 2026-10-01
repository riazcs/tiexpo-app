import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

const ink = Color(0xFF16130F);
const paper = Color(0xFFF4EFE6);
const paper2 = Color(0xFFEBE4D6);
const copper = Color(0xFFB85C28);
const pine = Color(0xFF1D4A40);
const muted = Color(0xFF6E675C);

ThemeData tiexpoTheme() {
  final text = GoogleFonts.outfitTextTheme(
    ThemeData.light().textTheme.apply(bodyColor: ink, displayColor: ink),
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: copper,
      onPrimary: paper,
      secondary: pine,
      onSecondary: paper,
      surface: paper,
      onSurface: ink,
    ),
    scaffoldBackgroundColor: paper,
    textTheme: text,
    appBarTheme: AppBarTheme(
      backgroundColor: paper,
      foregroundColor: ink,
      elevation: 0,
      titleTextStyle: GoogleFonts.fraunces(
        color: ink,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Color(0xFFFFFAF3),
      indicatorColor: Color(0xFFE8D5C4),
      height: 72,
    ),
  );
}

Color toneColor(String tone) => switch (tone) {
      "pine" => pine,
      "ink" => ink,
      _ => copper,
    };
