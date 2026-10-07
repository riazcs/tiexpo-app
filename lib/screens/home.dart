import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import "../data/expo.dart";
import "../theme.dart";
import "../widgets/expo_category_carousel.dart";
import "../widgets/exhibitor_directory_section.dart";
import "../widgets/glass_card.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onOpenAgenda, this.onLoginSuccess});
  final VoidCallback? onOpenAgenda;
  final VoidCallback? onLoginSuccess;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _directoryKey = GlobalKey<ExhibitorDirectorySectionState>();

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
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.extentAfter < 400) {
              _directoryKey.currentState?.loadNextPage();
            }
            return false;
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // ==================== HERO SECTION ====================
              SliverToBoxAdapter(
                child: SizedBox(
                  width: double.infinity,
                  child: Stack(
                    children: [
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
                                accentMauve.withValues(alpha: 0.22),
                                accentMauve.withValues(alpha: 0.06),
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
                                accentMauve.withValues(alpha: 0.14),
                                accentMauve.withValues(alpha: 0.04),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
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
                                accentMauve.withValues(alpha: 0.06),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),

                      GlassCard(
                        margin: const EdgeInsets.fromLTRB(18, 18, 18, 10),
                        padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
                        borderRadius: 28,
                        blur: 22,
                        tintOpacity: 0.68,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 280,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.82),
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.92,
                                      ),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: brandPurple.withValues(
                                          alpha: 0.08,
                                        ),
                                        blurRadius: 18,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Image.asset(
                                    "assets/img/logo.png",
                                    height: 124,
                                    fit: BoxFit.contain,
                                    semanticLabel:
                                        "Textile Innovation Expo 2026 logo",
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: accentMauve.withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: accentMauve.withValues(alpha: 0.28),
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

                            Text(
                              "The flagship event of TIE, formed under the TIE Steering Board to position innovation as the pathway to operational survival and next-stage growth across Bangladesh's textile and RMG sector.",
                              style: TextStyle(
                                color: brandMuted,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),

                            const SizedBox(height: 22),

                            SizedBox(
                              width: double.infinity,
                              child: GlassCard(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 14,
                                ),
                                borderRadius: 20,
                                blur: 14,
                                tintOpacity: 0.76,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 34,
                                          height: 34,
                                          decoration: BoxDecoration(
                                            color: accentMauve.withValues(
                                              alpha: 0.12,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
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
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      child: Divider(
                                        height: 1,
                                        color: accentMauve.withValues(
                                          alpha: 0.12,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 34,
                                          height: 34,
                                          decoration: BoxDecoration(
                                            color: accentMauve.withValues(
                                              alpha: 0.12,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
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
                    ExhibitorDirectorySection(
                      key: _directoryKey,
                      onLoginSuccess: widget.onLoginSuccess,
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
