import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import "../data/expo.dart";
import "../theme.dart";
import "glass_card.dart";

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
    return SizedBox(
      width: 220,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showCategoryDetails(context),
          child: GlassCard(
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            borderRadius: 20,
            blur: 14,
            tintOpacity: 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
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
          ),
        ),
      ),
    );
  }

  Future<void> _showCategoryDetails(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SafeArea(
        top: false,
        child: DraggableScrollableSheet(
          initialChildSize: 0.58,
          minChildSize: 0.42,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) => Container(
            decoration: const BoxDecoration(
              color: paper,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: brandBorder,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: background,
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: Icon(
                        Icons.auto_awesome_outlined,
                        color: accent,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.title.toUpperCase(),
                            style: TextStyle(
                              color: accent,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            category.name,
                            style: GoogleFonts.fraunces(
                              color: brandInk,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  category.description,
                  style: const TextStyle(
                    color: brandMuted,
                    fontSize: 15,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "WHAT YOU'LL DISCOVER",
                  style: TextStyle(
                    color: brandInk,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: category.tags
                      .map(
                        (tag) => Chip(
                          label: Text(tag),
                          backgroundColor: background.withValues(alpha: 0.7),
                          side: BorderSide(
                            color: accent.withValues(alpha: 0.18),
                          ),
                          labelStyle: TextStyle(
                            color: accent,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: brandBorder.withValues(alpha: 0.6),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.event_available_outlined,
                        color: brandPurple,
                        size: 21,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ExpoInfo.datesLabel,
                              style: TextStyle(
                                color: brandInk,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              "${ExpoInfo.venueShort} · ${ExpoInfo.city}, ${ExpoInfo.country}",
                              style: TextStyle(color: brandMuted, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
