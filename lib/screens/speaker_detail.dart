import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import "../data/expo.dart";
import "../theme.dart";
import "../widgets/session_card.dart";

class SpeakerDetail extends StatelessWidget {
  const SpeakerDetail({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    final speaker = speakerById(id);
    if (speaker == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text("Speaker not found.")),
      );
    }
    final talks = sessionsForSpeaker(speaker.id);
    return Scaffold(
      appBar: AppBar(title: const Text("Speakers")),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: toneColor(speaker.tone),
                foregroundColor: paper,
                child: Text(speaker.initials, style: const TextStyle(fontSize: 18)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(speaker.name, style: GoogleFonts.fraunces(fontSize: 26)),
                    Text("${speaker.title}\n${speaker.org}",
                        style: const TextStyle(color: muted)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(speaker.bio, style: const TextStyle(height: 1.5, fontSize: 15)),
          const SizedBox(height: 24),
          Text("On the floor", style: GoogleFonts.fraunces(fontSize: 20)),
          const SizedBox(height: 10),
          ...talks.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SessionCard(session: s),
            ),
          ),
        ],
      ),
    );
  }
}
