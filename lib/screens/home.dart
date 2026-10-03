import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import "../data/expo.dart";
import "../store/agenda.dart";
import "../theme.dart";
import "../widgets/session_card.dart";
import "badge.dart";
import "exhibitor_detail.dart";
import "exhibitor_registration.dart"; // ← added
import "speaker_detail.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onOpenAgenda});
  final VoidCallback? onOpenAgenda;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String q = "";

  @override
  Widget build(BuildContext context) {
    final n = q.trim().toLowerCase();
    final featured = sessions.where((s) => s.day == 1).take(3).toList();
    final hitSessions = n.isEmpty
        ? const <Session>[]
        : sessions
              .where(
                (s) =>
                    s.title.toLowerCase().contains(n) ||
                    s.type.toLowerCase().contains(n),
              )
              .toList();
    final hitSpeakers = n.isEmpty
        ? const <Speaker>[]
        : speakers
              .where(
                (s) =>
                    s.name.toLowerCase().contains(n) ||
                    s.org.toLowerCase().contains(n),
              )
              .toList();
    final hitExhibitors = n.isEmpty
        ? const <Exhibitor>[]
        : exhibitors
              .where(
                (e) =>
                    e.name.toLowerCase().contains(n) ||
                    e.booth.toLowerCase().contains(n) ||
                    e.category.toLowerCase().contains(n),
              )
              .toList();

    return Container(
      decoration: const BoxDecoration(gradient: appBackgroundGradient),
      child: CustomScrollView(
        slivers: [
          // ==================== HEADER ====================
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${ExpoInfo.city} · ${ExpoInfo.edition}",
                    style: const TextStyle(
                      color: Color(0xFF7E22CE),
                      letterSpacing: 2.2,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ExpoInfo.name,
                    style: GoogleFonts.fraunces(
                      color: Color(0xFF1E293B),
                      fontSize: 40,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${ExpoInfo.fullName}\n${ExpoInfo.datesLabel} · ${ExpoInfo.venue}",
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      FilledButton.icon(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const BadgeScreen(),
                          ),
                        ),
                        icon: const Icon(
                          Icons.confirmation_number_outlined,
                          size: 18,
                        ),
                        label: const Text("My badge"),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF7E22CE),
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ListenableBuilder(
                        listenable: AgendaStore.instance,
                        builder: (context, _) => OutlinedButton(
                          onPressed: widget.onOpenAgenda,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF475569),
                            side: const BorderSide(color: Color(0xFFCBD5E1)),
                          ),
                          child: Text(
                            AgendaStore.instance.count == 0
                                ? "Agenda"
                                : "Agenda (${AgendaStore.instance.count})",
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ==================== BODY ====================
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            sliver: SliverList.list(
              children: [
                // Search
                TextField(
                  onChanged: (v) => setState(() => q = v),
                  decoration: InputDecoration(
                    hintText: "Search sessions, people, booths",
                    prefixIcon: const Icon(Icons.search, color: muted),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ========== REGISTER / BOOTH BOOKING CARD ==========
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ExhibitorRegistrationScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF06B6D4), Color(0xFF7E22CE)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF7E22CE).withOpacity(0.25),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.storefront_outlined,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Booth Booking",
                                style: GoogleFonts.fraunces(
                                  color: Colors.white,
                                  fontSize: 20,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "Register as Exhibitor · Reserve your space",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Search Results or Default Content
                if (n.isNotEmpty) ...[
                  Text("Results", style: GoogleFonts.fraunces(fontSize: 22)),
                  const SizedBox(height: 12),
                  if (hitSessions.isEmpty &&
                      hitSpeakers.isEmpty &&
                      hitExhibitors.isEmpty)
                    const Text(
                      "Nothing matches that search.",
                      style: TextStyle(color: muted),
                    ),
                  ...hitSessions.map(
                    (s) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SessionCard(session: s),
                    ),
                  ),
                  ...hitSpeakers.map(
                    (s) => ListTile(
                      title: Text(s.name),
                      subtitle: Text(s.org),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => SpeakerDetail(id: s.id),
                        ),
                      ),
                    ),
                  ),
                  ...hitExhibitors.map(
                    (e) => ListTile(
                      title: Text(e.name),
                      subtitle: Text("Booth ${e.booth}"),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ExhibitorDetail(id: e.id),
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  Text(
                    "Opening day",
                    style: GoogleFonts.fraunces(fontSize: 24),
                  ),
                  const SizedBox(height: 12),
                  ...featured.map(
                    (s) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SessionCard(session: s),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Floor notes",
                    style: GoogleFonts.fraunces(fontSize: 24),
                  ),
                  const SizedBox(height: 12),
                  ...notices.map(
                    (n0) => Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: paper2,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            n0.title,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(n0.body, style: const TextStyle(color: muted)),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
