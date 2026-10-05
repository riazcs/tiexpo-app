import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import "../data/expo.dart";
import "../theme.dart";

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: appBackgroundGradient),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(22, 28, 22, 40),
        children: [
          const Text(
            "ABOUT THE EVENT",
            style: TextStyle(
              color: brandPurple,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "${ExpoInfo.name}, ${ExpoInfo.edition}",
            style: GoogleFonts.fraunces(
              color: brandInk,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "A meeting place for textile makers, technology leaders, and the people shaping the industry's next chapter.",
            style: TextStyle(color: brandMuted, fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: brandBorder),
            ),
            child: Column(
              children: [
                _EventDetail(
                  icon: Icons.calendar_today_outlined,
                  label: "DATES",
                  value: ExpoInfo.datesLabel,
                ),
                const Divider(height: 24),
                _EventDetail(
                  icon: Icons.location_on_outlined,
                  label: "VENUE",
                  value: "${ExpoInfo.venue}, ${ExpoInfo.city}",
                ),
                const Divider(height: 24),
                _EventDetail(
                  icon: Icons.category_outlined,
                  label: "FOCUS",
                  value: "Materials, manufacturing, and circularity",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EventDetail extends StatelessWidget {
  const _EventDetail({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: brandCyan, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: brandMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: brandInk,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
