import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import "../data/expo.dart";
import "../theme.dart";
import "exhibitor_detail.dart";

class ExhibitorsScreen extends StatefulWidget {
  const ExhibitorsScreen({super.key});

  @override
  State<ExhibitorsScreen> createState() => _ExhibitorsScreenState();
}

class _ExhibitorsScreenState extends State<ExhibitorsScreen> {
  String hall = "All";

  @override
  Widget build(BuildContext context) {
    final halls = ["All", ...{for (final e in exhibitors) e.hall}];
    final list = exhibitors.where((e) => hall == "All" || e.hall == hall).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
      children: [
        const Text(
          "EXHIBITORS",
          style: TextStyle(
            color: copper,
            letterSpacing: 2,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text("Halls", style: GoogleFonts.fraunces(fontSize: 32)),
        const Text("Live looms, dye houses, and fiber labs.",
            style: TextStyle(color: muted)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: halls
              .map(
                (h) => ChoiceChip(
                  label: Text(h),
                  selected: hall == h,
                  onSelected: (_) => setState(() => hall = h),
                  selectedColor: ink,
                  labelStyle: TextStyle(color: hall == h ? paper : ink),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 16),
        ...list.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              tileColor: const Color(0xFFFFFAF3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              title: Text(e.name, style: GoogleFonts.fraunces(fontSize: 18)),
              subtitle: Text("${e.category} · ${e.hall}\n${e.blurb}"),
              isThreeLine: true,
              trailing: Text(e.booth, style: const TextStyle(color: copper)),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ExhibitorDetail(id: e.id)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
