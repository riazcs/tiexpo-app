import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import "../data/expo.dart";
import "../theme.dart";

class ExpoCategoryCarousel extends StatelessWidget {
  const ExpoCategoryCarousel({super.key, this.heading = "Explore the show"});

  final String heading;

  static const _backgrounds = [
    paper2,
    brandCyanSoft,
    Color(0xFFE2E8F0),
    Color(0xFFEDE9FE),
  ];
  static const _accents = [brandPurple, brandCyan, brandMuted, brandPurple];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: GoogleFonts.fraunces(
            color: brandInk,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 132, // was 200 → content-fit height
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: expoCategories.length,
            itemBuilder: (context, index) => _ExpoCategoryCard(
              category: expoCategories[index],
              background: _backgrounds[index % _backgrounds.length],
              accent: _accents[index % _accents.length],
            ),
          ),
        ),
      ],
    );
  }
}

class _ExpoCategoryCard extends StatelessWidget {
  const _ExpoCategoryCard({
    required this.category,
    required this.background,
    required this.accent,
  });

  final ExpoCategory category;
  final Color background;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // no extra vertical space
        children: [
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              category.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: accent,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Name
          Text(
            category.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: brandInk,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 5),

          // Description
          Text(
            category.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: brandMuted,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}