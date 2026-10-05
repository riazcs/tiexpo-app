import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import "../data/expo.dart";
import "../theme.dart";
import "../widgets/exhibitor_directory_section.dart";

class MeetScreen extends StatelessWidget {
  const MeetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: appBackgroundGradient),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
        children: [
          const Text(
            "MEET & CONNECT",
            style: TextStyle(
              color: brandPurple,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Meet the textile future.",
            style: GoogleFonts.fraunces(
              color: brandInk,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Explore the sectors bringing textile innovators together at ${ExpoInfo.name} ${ExpoInfo.edition}.",
            style: const TextStyle(
              color: brandMuted,
              fontSize: 14,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 20),
          const ExhibitorDirectorySection(),
        ],
      ),
    );
  }
}
