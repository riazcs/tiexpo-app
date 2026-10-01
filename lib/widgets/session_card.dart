import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import "../data/expo.dart";
import "../store/agenda.dart";
import "../theme.dart";
import "../screens/session_detail.dart";

class SessionCard extends StatelessWidget {
  const SessionCard({super.key, required this.session});
  final Session session;

  @override
  Widget build(BuildContext context) {
    final names = session.speakerIds
        .map(speakerById)
        .whereType<Speaker>()
        .map((s) => s.name)
        .join(" · ");
    return ListenableBuilder(
      listenable: AgendaStore.instance,
      builder: (context, _) {
        final saved = AgendaStore.instance.has(session.id);
        return Material(
          color: const Color(0xFFFFFAF3),
          elevation: 1,
          shadowColor: ink.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => SessionDetail(id: session.id)),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 4, 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${session.type} · ${session.start}–${session.end}",
                          style: const TextStyle(
                            color: copper,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          session.title,
                          style: GoogleFonts.fraunces(
                            fontSize: 18,
                            height: 1.2,
                            color: ink,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          names.isEmpty ? session.hall : "${session.hall} · $names",
                          style: const TextStyle(color: muted, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: saved ? "Remove from agenda" : "Save to agenda",
                    onPressed: () => AgendaStore.instance.toggle(session.id),
                    icon: Icon(
                      saved ? Icons.bookmark : Icons.bookmark_border,
                      color: saved ? copper : muted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
