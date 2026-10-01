import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import "../data/expo.dart";
import "../store/agenda.dart";
import "../theme.dart";
import "speaker_detail.dart";

class SessionDetail extends StatelessWidget {
  const SessionDetail({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    final session = sessionById(id);
    if (session == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text("Session not found.")),
      );
    }
    final day = ExpoInfo.days.firstWhere((d) => d.$1 == session.day);
    return Scaffold(
      appBar: AppBar(title: const Text("Agenda")),
      body: ListenableBuilder(
        listenable: AgendaStore.instance,
        builder: (context, _) {
          final saved = AgendaStore.instance.has(session.id);
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            children: [
              Text(
                "${session.type} · Day ${session.day} · ${day.$2}".toUpperCase(),
                style: const TextStyle(color: copper, letterSpacing: 1.4, fontSize: 11),
              ),
              const SizedBox(height: 8),
              Text(session.title, style: GoogleFonts.fraunces(fontSize: 30, height: 1.15)),
              const SizedBox(height: 8),
              Text("${session.start}–${session.end} · ${session.hall}",
                  style: const TextStyle(color: muted)),
              const SizedBox(height: 16),
              Text(session.summary, style: const TextStyle(height: 1.5, fontSize: 15)),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => AgendaStore.instance.toggle(session.id),
                icon: Icon(saved ? Icons.bookmark : Icons.bookmark_border),
                label: Text(saved ? "Saved to my agenda" : "Save to my agenda"),
                style: FilledButton.styleFrom(
                  backgroundColor: saved ? copper : ink,
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
              const SizedBox(height: 24),
              Text("Speakers", style: GoogleFonts.fraunces(fontSize: 20)),
              const SizedBox(height: 8),
              ...session.speakerIds.map((sid) {
                final sp = speakerById(sid);
                if (sp == null) return const SizedBox.shrink();
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(sp.name),
                  subtitle: Text(sp.org),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => SpeakerDetail(id: sid)),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
