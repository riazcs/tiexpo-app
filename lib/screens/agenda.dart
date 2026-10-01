import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import "../data/expo.dart";
import "../store/agenda.dart";
import "../theme.dart";
import "../widgets/session_card.dart";

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  int day = 1;
  bool mine = false;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AgendaStore.instance,
      builder: (context, _) {
        final list = sessions
            .where((s) => s.day == day && (!mine || AgendaStore.instance.has(s.id)))
            .toList();
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
          children: [
            const Text(
              "PROGRAMME",
              style: TextStyle(
                color: copper,
                letterSpacing: 2,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text("Agenda", style: GoogleFonts.fraunces(fontSize: 32)),
            const Text(ExpoInfo.datesLabel, style: TextStyle(color: muted)),
            const SizedBox(height: 16),
            Row(
              children: ExpoInfo.days
                  .map(
                    (d) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilledButton(
                          onPressed: () => setState(() => day = d.$1),
                          style: FilledButton.styleFrom(
                            backgroundColor: day == d.$1 ? ink : paper2,
                            foregroundColor: day == d.$1 ? paper : ink,
                          ),
                          child: Text("Day ${d.$1}\n${d.$2}", textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton(
                onPressed: () => setState(() => mine = !mine),
                style: FilledButton.styleFrom(
                  backgroundColor: mine ? copper : const Color(0xFFFFFAF3),
                  foregroundColor: mine ? paper : ink,
                ),
                child: Text(mine ? "Showing my agenda" : "Show my saved only"),
              ),
            ),
            const SizedBox(height: 16),
            if (list.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: paper2,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  mine
                      ? "Nothing saved for this day yet."
                      : "No sessions on this day.",
                  style: const TextStyle(color: muted),
                ),
              )
            else
              ...list.map(
                (s) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SessionCard(session: s),
                ),
              ),
          ],
        );
      },
    );
  }
}
