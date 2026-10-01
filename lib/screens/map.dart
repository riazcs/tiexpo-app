import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import "../data/expo.dart";
import "../theme.dart";
import "exhibitor_detail.dart";

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
      children: [
        const Text(
          "VENUE",
          style: TextStyle(
            color: copper,
            letterSpacing: 2,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text("Floor map", style: GoogleFonts.fraunces(fontSize: 32)),
        const Text("Bangabandhu Textile Hall", style: TextStyle(color: muted)),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            color: ink,
            height: 180,
            padding: const EdgeInsets.all(12),
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.8,
              children: const [
                _HallTile("Hall A", pine),
                _HallTile("Hall B", copper),
                _HallTile("Atrium", Color(0xFF2A241D)),
                _HallTile("Forum", Color(0xFF8C3F18)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text("Booths", style: GoogleFonts.fraunces(fontSize: 20)),
        const SizedBox(height: 8),
        ...exhibitors.map(
          (e) => ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(e.name),
            subtitle: Text(e.hall),
            trailing: Text(e.booth, style: const TextStyle(color: copper)),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => ExhibitorDetail(id: e.id)),
            ),
          ),
        ),
      ],
    );
  }
}

class _HallTile extends StatelessWidget {
  const _HallTile(this.label, this.color);
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      alignment: Alignment.center,
      child: Text(label, style: const TextStyle(color: paper, fontWeight: FontWeight.w600)),
    );
  }
}
