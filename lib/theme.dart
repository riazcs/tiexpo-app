import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

const ink = Color(0xFF16130F);
const paper = Color(0xFFF8FAFC);
const paper2 = Color(0xFFF3E8FF);
const brandPurple = Color(0xFF6D1E7B);
const brandCyan = Color(0xFF06B6D4);
const brandInk = Color(0xFF1E293B);
const brandMuted = Color(0xFF64748B);
const brandBorder = Color(0xFFCBD5E1);
const brandCyanSoft = Color(0xFFCFFAFE);
const copper = Color(0xFFB85C28);
const pine = Color(0xFF1D4A40);
const muted = Color(0xFF6E675C);
const loginBgTop = Color(0xFFF9F7FD);
const loginBgMiddle = Color(0xFFF0E9F8);
const loginBgBottom = Color(0xFFEAF6FB);

const appBackgroundGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    loginBgTop,
    Color(0xFFF2EDFA),
    loginBgMiddle,
    loginBgBottom,
    Color(0xFFF7FAFD),
  ],
  stops: [0, 0.24, 0.52, 0.8, 1],
);

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
    scaffoldBackgroundColor: loginBgTop,
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
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: paper,
      indicatorColor: paper2,
      height: 72,
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? brandPurple
              : brandMuted,
        ),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
        (states) => TextStyle(
          color: states.contains(WidgetState.selected)
              ? brandPurple
              : brandMuted,
          fontSize: 12,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w700
              : FontWeight.w500,
        ),
      ),
    ),
  );
}

Color toneColor(String tone) => switch (tone) {
  "pine" => pine,
  "ink" => ink,
  _ => copper,
};
