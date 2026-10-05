import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:tiexpo/theme.dart";

import "../data/expo.dart";
import "../theme.dart";
import "../widgets/expo_category_carousel.dart";
import "../widgets/exhibitor_directory_section.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onOpenAgenda});
  final VoidCallback? onOpenAgenda;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _directoryKey = GlobalKey<ExhibitorDirectorySectionState>();

  // Accent from your request
  static const Color accentMauve = Color(0xFFA083B3);

  Future<void> _refreshDirectory() async {
    await _directoryKey.currentState?.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: appBackgroundGradient),
      child: RefreshIndicator(
        onRefresh: _refreshDirectory,
        color: accentMauve,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // ==================== HERO SECTION ====================
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: paper,
                  border: const Border(
                    bottom: BorderSide(color: Color(0xFFE8E4EE), width: 1),
                  ),
                ),
                child: Stack(
                  children: [
                    // ---- Soft background effects (#a083b3) ----
                    Positioned(
                      top: -60,
                      right: -40,
                      child: Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              accentMauve.withOpacity(0.22),
                              accentMauve.withOpacity(0.06),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -30,
                      left: -50,
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              accentMauve.withOpacity(0.14),
                              accentMauve.withOpacity(0.04),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Subtle top wash
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              accentMauve.withOpacity(0.06),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ---- Content ----
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 28, 22, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: accentMauve.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: accentMauve.withOpacity(0.28),
                              ),
                            ),
                            child: Text(
                              "BANGLADESH'S PREMIER TEXTILE EVENT",
                              style: TextStyle(
                                color: brandPurple,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.9,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Headline
                          Text(
                            "The Future of Textile\nInnovation is Here.",
                            style: GoogleFonts.fraunces(
                              color: brandInk,
                              fontSize: 28,
                              height: 1.12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Description
                          Text(
                            "The flagship event of TIE, formed under the TIE Steering Board to position innovation as the pathway to operational survival and next-stage growth across Bangladesh's textile and RMG sector.",
                            style: TextStyle(
                              color: brandMuted,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 22),

                          // Meta card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.75),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: accentMauve.withOpacity(0.18),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: accentMauve.withOpacity(0.06),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 34,
                                      height: 34,
                                      decoration: BoxDecoration(
                                        color: accentMauve.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.calendar_today_outlined,
                                        color: accentMauve,
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        ExpoInfo.datesLabel.toUpperCase(),
                                        style: const TextStyle(
                                          color: brandInk,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.6,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: Divider(
                                    height: 1,
                                    color: accentMauve.withOpacity(0.12),
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 34,
                                      height: 34,
                                      decoration: BoxDecoration(
                                        color: accentMauve.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.location_on_outlined,
                                        color: accentMauve,
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        "${ExpoInfo.venue}, ${ExpoInfo.city}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: brandMuted,
                                          fontSize: 13,
                                          height: 1.35,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
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

            // ==================== BODY CONTENT ====================
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              sliver: SliverList.list(
                children: [
                  const ExpoCategoryCarousel(),
                  const SizedBox(height: 28),
                  ExhibitorDirectorySection(key: _directoryKey),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}