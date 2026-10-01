import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import "../data/expo.dart";
import "../theme.dart";

class BadgeScreen extends StatelessWidget {
  const BadgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Access")),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          Text("Visitor badge", style: GoogleFonts.fraunces(fontSize: 32)),
          const Text("Show this at the Atrium west desk and hall doors.",
              style: TextStyle(color: muted)),
          const SizedBox(height: 20),
          Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(18),
            color: const Color(0xFFFFFAF3),
            child: Column(
              children: [
                Container(
                  height: 8,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                    gradient: LinearGradient(
                      colors: [copper, pine, copper, pine],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ExpoInfo.fullName.toUpperCase(),
                          style: const TextStyle(
                            color: muted,
                            letterSpacing: 1.6,
                            fontSize: 11,
                          )),
                      const SizedBox(height: 8),
                      Text("Guest Pass", style: GoogleFonts.fraunces(fontSize: 30)),
                      Text(
                        "${ExpoInfo.datesLabel}\n${ExpoInfo.venue}, ${ExpoInfo.city}",
                        style: const TextStyle(color: muted, height: 1.4),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: List.generate(
                          40,
                          (i) => Container(
                            width: 22,
                            height: 40,
                            color: ink.withValues(alpha: ((i * 17) % 9) / 10 + 0.2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "TX-2026-GUEST",
                        style: TextStyle(
                          letterSpacing: 3,
                          fontWeight: FontWeight.w600,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
