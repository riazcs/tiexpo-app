import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import "../data/expo.dart";
import "../theme.dart";

class ExhibitorDetail extends StatelessWidget {
  const ExhibitorDetail({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    final e = exhibitorById(id);
    if (e == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text("Exhibitor not found.")),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Halls")),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          Text(e.category.toUpperCase(),
              style: const TextStyle(color: copper, letterSpacing: 1.6, fontSize: 11)),
          Text(e.name, style: GoogleFonts.fraunces(fontSize: 32)),
          const SizedBox(height: 8),
          Text(e.blurb, style: const TextStyle(height: 1.5, fontSize: 15)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: paper2,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text("${e.hall} · Booth ${e.booth}",
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: e.tags
                .map((t) => Chip(label: Text(t), backgroundColor: const Color(0xFFFFFAF3)))
                .toList(),
          ),
        ],
      ),
    );
  }
}
