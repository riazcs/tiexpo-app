import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import "../data/expo.dart";
import "../theme.dart";
import "speaker_detail.dart";

class SpeakersScreen extends StatelessWidget {
  const SpeakersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
      children: [
        const Text(
          "VOICES",
          style: TextStyle(
            color: copper,
            letterSpacing: 2,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text("Speakers", style: GoogleFonts.fraunces(fontSize: 32)),
        Text("${speakers.length} researchers, mill leads, and makers.",
            style: const TextStyle(color: muted)),
        const SizedBox(height: 16),
        ...speakers.map(
          (s) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              tileColor: const Color(0xFFFFFAF3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              leading: CircleAvatar(
                backgroundColor: toneColor(s.tone),
                foregroundColor: paper,
                child: Text(s.initials),
              ),
              title: Text(s.name),
              subtitle: Text("${s.title} · ${s.org}"),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => SpeakerDetail(id: s.id)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
