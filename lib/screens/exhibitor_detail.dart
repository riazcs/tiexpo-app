import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:url_launcher/url_launcher.dart";

import "../data/expo.dart";
import "../theme.dart";

class ExhibitorDetail extends StatefulWidget {
  const ExhibitorDetail({super.key, required this.id}) : exhibitor = null;

  factory ExhibitorDetail.fromExhibitor({
    Key? key,
    required Exhibitor exhibitor,
  }) => ExhibitorDetail._(key: key, id: exhibitor.id, exhibitor: exhibitor);

  const ExhibitorDetail._({super.key, required this.id, this.exhibitor});

  final String id;
  final Exhibitor? exhibitor;

  @override
  State<ExhibitorDetail> createState() => _ExhibitorDetailState();
}

class _ExhibitorDetailState extends State<ExhibitorDetail> {
  Future<void> _openExternalLink(String value) async {
    final uri = Uri.tryParse(value);
    if (uri == null || !uri.hasScheme) return;
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open this link.")),
      );
    }
  }

  Future<void> _bookMeeting(Exhibitor exhibitor) async {
    final booking = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => _MeetingBookingSheet(companyName: exhibitor.name),
    );

    if (booking == null || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Request prepared for ${exhibitor.name}: $booking. Confirm availability with the exhibitor.",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final exhibitor = widget.exhibitor ?? exhibitorById(widget.id);
    if (exhibitor == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text("Exhibitor not found.")),
      );
    }

    final products = exhibitor.products;

    return Scaffold(
      backgroundColor: paper,
      appBar: AppBar(
        title: const Text("Company profile"),
        backgroundColor: paper,
        foregroundColor: brandInk,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: appBackgroundGradient),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: brandBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exhibitor.category.toUpperCase(),
                    style: const TextStyle(
                      color: brandPurple,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    exhibitor.name,
                    style: GoogleFonts.fraunces(
                      color: brandInk,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _ProfileMeta(
                        icon: Icons.location_on_outlined,
                        label: exhibitor.hall,
                      ),
                      _ProfileMeta(
                        icon: Icons.storefront_outlined,
                        label: "Booth ${exhibitor.booth}",
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (exhibitor.isDemo) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: paper2,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.science_outlined, color: brandPurple, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "DEMO COMPANY · Sample information, not a live exhibitor.",
                        style: TextStyle(
                          color: brandPurple,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            const _SectionHeading(title: "About the company"),
            const SizedBox(height: 8),
            Text(
              exhibitor.blurb,
              style: const TextStyle(
                color: brandMuted,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            if (exhibitor.website != null) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => _openExternalLink(exhibitor.website!),
                  icon: const Icon(Icons.open_in_new, size: 16),
                  label: const Text("Visit company website"),
                ),
              ),
            ],
            const SizedBox(height: 24),
            const _SectionHeading(title: "Company catalogue / brochure"),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: brandBorder),
              ),
              child: Row(
                children: [
                  Icon(
                    exhibitor.brochureUrl == null
                        ? Icons.menu_book_outlined
                        : Icons.description_outlined,
                    color: brandPurple,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      exhibitor.brochureUrl == null
                          ? "No company catalogue has been published yet."
                          : "View the company catalogue or brochure.",
                      style: const TextStyle(
                        color: brandMuted,
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ),
                  if (exhibitor.brochureUrl != null)
                    TextButton.icon(
                      onPressed: () =>
                          _openExternalLink(exhibitor.brochureUrl!),
                      icon: const Icon(Icons.open_in_new, size: 16),
                      label: const Text("Open"),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const _SectionHeading(title: "Company video"),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              decoration: BoxDecoration(
                color: brandInk,
                borderRadius: BorderRadius.circular(8),
              ),
              child: exhibitor.videoUrl == null
                  ? const Column(
                      children: [
                        Icon(
                          Icons.play_circle_outline_rounded,
                          color: Colors.white,
                          size: 48,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Video not published",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Company video will appear here when available.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFCBD5E1),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        const Icon(
                          Icons.play_circle_outline_rounded,
                          color: Colors.white,
                          size: 48,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Company video",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () =>
                              _openExternalLink(exhibitor.videoUrl!),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.open_in_new, size: 16),
                          label: const Text("Open video"),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 24),
            const _SectionHeading(title: "Products & solutions"),
            const SizedBox(height: 10),
            if (products.isEmpty)
              const Text(
                "Product information has not been published yet.",
                style: TextStyle(color: brandMuted),
              )
            else
              ...products.map(
                (product) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: brandBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.inventory_2_outlined, color: brandCyan),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          product,
                          style: const TextStyle(
                            color: brandInk,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            const _SectionHeading(title: "News & updates"),
            const SizedBox(height: 10),
            if (exhibitor.news.isEmpty)
              const Text(
                "No company updates have been published yet.",
                style: TextStyle(color: brandMuted),
              )
            else
              ...exhibitor.news.map(
                (news) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: brandBorder),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.article_outlined, color: brandPurple),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              news.title,
                              style: const TextStyle(
                                color: brandInk,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (news.date.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                news.date,
                                style: const TextStyle(
                                  color: brandMuted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                            if (news.body.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(
                                news.body,
                                style: const TextStyle(
                                  color: brandMuted,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
          child: FilledButton.icon(
            onPressed: () => _bookMeeting(exhibitor),
            icon: const Icon(Icons.event_available_outlined),
            label: const Text("Book a meeting slot"),
            style: FilledButton.styleFrom(
              backgroundColor: brandPurple,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.fraunces(
        color: brandInk,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _ProfileMeta extends StatelessWidget {
  const _ProfileMeta({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: paper2,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: brandPurple, size: 15),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: brandInk,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MeetingBookingSheet extends StatefulWidget {
  const _MeetingBookingSheet({required this.companyName});
  final String companyName;

  @override
  State<_MeetingBookingSheet> createState() => _MeetingBookingSheetState();
}

class _MeetingBookingSheetState extends State<_MeetingBookingSheet> {
  final _requestedTimeController = TextEditingController();
  final _queryController = TextEditingController();
  int selectedDay = 1;
  String? selectedSlot;
  bool _requestAnotherTime = false;

  List<String> get _daySlots {
    final startMinute = selectedDay == 1 ? 11 * 60 + 30 : 9 * 60;
    const endMinute = 18 * 60;
    return [
      for (var minute = startMinute; minute <= endMinute; minute += 30)
        _formatTime(minute),
    ];
  }

  String _formatTime(int minutes) {
    final hour = minutes ~/ 60;
    final minute = minutes % 60;
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    final period = hour < 12 ? "AM" : "PM";
    return "$hour12:${minute.toString().padLeft(2, "0")} $period";
  }

  @override
  void dispose() {
    _requestedTimeController.dispose();
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.85,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Meet ${widget.companyName}",
                style: GoogleFonts.fraunces(
                  color: brandInk,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Choose a preferred 30-minute time. The exhibitor will confirm availability.",
                style: TextStyle(color: brandMuted),
              ),
              const SizedBox(height: 20),
              const Text(
                "EVENT DAY",
                style: TextStyle(
                  color: brandMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ExpoInfo.days
                    .map(
                      (day) => ChoiceChip(
                        label: Text(day.$2),
                        selected: selectedDay == day.$1,
                        selectedColor: paper2,
                        onSelected: (_) => setState(() {
                          selectedDay = day.$1;
                          selectedSlot = null;
                        }),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 18),
              const Text(
                "TIME SLOT",
                style: TextStyle(
                  color: brandMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _daySlots
                    .map(
                      (slot) => ChoiceChip(
                        label: Text(slot),
                        selected: selectedSlot == slot,
                        selectedColor: paper2,
                        onSelected: (_) => setState(() {
                          selectedSlot = slot;
                          _requestAnotherTime = false;
                        }),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () => setState(() {
                  _requestAnotherTime = !_requestAnotherTime;
                  if (_requestAnotherTime) selectedSlot = null;
                }),
                icon: const Icon(Icons.edit_calendar_outlined, size: 18),
                label: const Text("No suitable slot? Request another time"),
              ),
              if (_requestAnotherTime) ...[
                const SizedBox(height: 8),
                TextField(
                  key: const ValueKey("requested-meeting-time"),
                  controller: _requestedTimeController,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    labelText: "Preferred time",
                    hintText: "For example, 4:30 PM",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.schedule_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  key: const ValueKey("meeting-query"),
                  controller: _queryController,
                  onChanged: (_) => setState(() {}),
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: "Meeting query",
                    hintText: "What would you like to discuss?",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.chat_bubble_outline),
                    alignLabelWithHint: true,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _canSubmit
                      ? () {
                          final dayLabel = ExpoInfo.days
                              .firstWhere((day) => day.$1 == selectedDay)
                              .$2;
                          final request = _requestAnotherTime
                              ? "$dayLabel, ${_requestedTimeController.text.trim()}; query: ${_queryController.text.trim()}"
                              : "$dayLabel at $selectedSlot";
                          Navigator.of(context).pop(request);
                        }
                      : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: brandPurple,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: Text(
                    _requestAnotherTime
                        ? "Prepare slot request"
                        : "Save preferred time",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool get _canSubmit => _requestAnotherTime
      ? _requestedTimeController.text.trim().isNotEmpty &&
            _queryController.text.trim().isNotEmpty
      : selectedSlot != null;
}
