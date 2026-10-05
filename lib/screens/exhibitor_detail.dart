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
  static const Color accentMauve = Color(0xFFA083B3);

  Future<void> _openExternalLink(String value) async {
    final uri = Uri.tryParse(value);
    if (uri == null || !uri.hasScheme) return;
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Could not open this link."),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  Future<void> _bookMeeting(Exhibitor exhibitor) async {
    final booking = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _MeetingBookingSheet(companyName: exhibitor.name),
    );

    if (booking == null || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Request prepared for ${exhibitor.name}: $booking. Confirm availability with the exhibitor.",
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final exhibitor = widget.exhibitor ?? exhibitorById(widget.id);
    if (exhibitor == null) {
      return Scaffold(
        backgroundColor: paper,
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: brandInk,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        body: const Center(child: Text("Exhibitor not found.")),
      );
    }

    final products = exhibitor.products;

    return Scaffold(
      backgroundColor: paper,
      appBar: AppBar(
        title: const Text(
          "Company profile",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
        backgroundColor: Colors.white,
        foregroundColor: brandInk,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFE8E4EE)),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: appBackgroundGradient),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          children: [
            // ========== PROFILE HEADER ==========
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE8E4EE)),
                boxShadow: [
                  BoxShadow(
                    color: accentMauve.withOpacity(0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: brandPurple.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      exhibitor.category.toUpperCase(),
                      style: const TextStyle(
                        color: brandPurple,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    exhibitor.name,
                    style: GoogleFonts.fraunces(
                      color: brandInk,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 14),
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

            // Demo banner
            if (exhibitor.isDemo) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: brandPurple.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: brandPurple.withOpacity(0.15)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.science_outlined, color: brandPurple, size: 18),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "DEMO COMPANY · Sample information, not a live exhibitor.",
                        style: TextStyle(
                          color: brandPurple,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 22),

            // ========== ABOUT ==========
            const _SectionHeading(title: "About the company"),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE8E4EE)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exhibitor.blurb,
                    style: const TextStyle(
                      color: brandMuted,
                      fontSize: 14.5,
                      height: 1.5,
                    ),
                  ),
                  if (exhibitor.website != null) ...[
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: () => _openExternalLink(exhibitor.website!),
                      style: TextButton.styleFrom(
                        foregroundColor: brandPurple,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: const Icon(Icons.open_in_new, size: 16),
                      label: const Text(
                        "Visit company website",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 22),

            // ========== BROCHURE ==========
            const _SectionHeading(title: "Company catalogue / brochure"),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE8E4EE)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: brandPurple.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      exhibitor.brochureUrl == null
                          ? Icons.menu_book_outlined
                          : Icons.description_outlined,
                      color: brandPurple,
                      size: 22,
                    ),
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
                    TextButton(
                      onPressed: () =>
                          _openExternalLink(exhibitor.brochureUrl!),
                      style: TextButton.styleFrom(
                        foregroundColor: brandPurple,
                        textStyle: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      child: const Text("Open"),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // ========== VIDEO ==========
            const _SectionHeading(title: "Company video"),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E1B2E), Color(0xFF2D2640)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: exhibitor.videoUrl == null
                  ? const Column(
                      children: [
                        Icon(
                          Icons.play_circle_outline_rounded,
                          color: Colors.white54,
                          size: 44,
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
                            color: Color(0xFF94A3B8),
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
                        const SizedBox(height: 10),
                        TextButton.icon(
                          onPressed: () =>
                              _openExternalLink(exhibitor.videoUrl!),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.white.withOpacity(0.12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.open_in_new, size: 16),
                          label: const Text("Open video"),
                        ),
                      ],
                    ),
            ),

            const SizedBox(height: 22),

            // ========== PRODUCTS ==========
            const _SectionHeading(title: "Products & solutions"),
            const SizedBox(height: 10),
            if (products.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE8E4EE)),
                ),
                child: const Text(
                  "Product information has not been published yet.",
                  style: TextStyle(color: brandMuted, fontSize: 13.5),
                ),
              )
            else
              ...products.map(
                (product) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE8E4EE)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: brandCyan.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.inventory_2_outlined,
                          color: brandCyan,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          product,
                          style: const TextStyle(
                            color: brandInk,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 22),

            // ========== NEWS ==========
            const _SectionHeading(title: "News & updates"),
            const SizedBox(height: 10),
            if (exhibitor.news.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE8E4EE)),
                ),
                child: const Text(
                  "No company updates have been published yet.",
                  style: TextStyle(color: brandMuted, fontSize: 13.5),
                ),
              )
            else
              ...exhibitor.news.map(
                (news) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE8E4EE)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: brandPurple.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.article_outlined,
                          color: brandPurple,
                          size: 18,
                        ),
                      ),
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
                                fontSize: 14.5,
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
                                  fontSize: 13,
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

            const SizedBox(height: 12),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: const Color(0xFFE8E4EE))),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: FilledButton.icon(
              onPressed: () => _bookMeeting(exhibitor),
              icon: const Icon(Icons.event_available_outlined, size: 20),
              label: const Text(
                "Book a meeting slot",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: brandPurple,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(52),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
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
        fontSize: 20,
        fontWeight: FontWeight.w700,
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
        color: const Color(0xFFF5F3F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE8E4EE)),
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

  InputDecoration _fieldDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFFA083B3), size: 20),
      filled: true,
      fillColor: const Color(0xFFF8F7FC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE8E4EE)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE8E4EE)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: brandPurple, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.85,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Meet ${widget.companyName}",
                style: GoogleFonts.fraunces(
                  color: brandInk,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Choose a preferred 30-minute time. The exhibitor will confirm availability.",
                style: TextStyle(
                  color: brandMuted,
                  fontSize: 13.5,
                  height: 1.4,
                ),
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
                        selectedColor: brandPurple.withOpacity(0.12),
                        checkmarkColor: brandPurple,
                        labelStyle: TextStyle(
                          color: selectedDay == day.$1 ? brandPurple : brandInk,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        side: BorderSide(
                          color: selectedDay == day.$1
                              ? brandPurple.withOpacity(0.35)
                              : const Color(0xFFE8E4EE),
                        ),
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
                runSpacing: 6,
                children: _daySlots
                    .map(
                      (slot) => ChoiceChip(
                        label: Text(slot),
                        selected: selectedSlot == slot,
                        selectedColor: brandPurple.withOpacity(0.12),
                        checkmarkColor: brandPurple,
                        labelStyle: TextStyle(
                          color: selectedSlot == slot ? brandPurple : brandInk,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.5,
                        ),
                        side: BorderSide(
                          color: selectedSlot == slot
                              ? brandPurple.withOpacity(0.35)
                              : const Color(0xFFE8E4EE),
                        ),
                        onSelected: (_) => setState(() {
                          selectedSlot = slot;
                          _requestAnotherTime = false;
                        }),
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => setState(() {
                  _requestAnotherTime = !_requestAnotherTime;
                  if (_requestAnotherTime) selectedSlot = null;
                }),
                icon: const Icon(Icons.edit_calendar_outlined, size: 18),
                label: const Text("No suitable slot? Request another time"),
                style: TextButton.styleFrom(foregroundColor: brandPurple),
              ),

              if (_requestAnotherTime) ...[
                const SizedBox(height: 4),
                TextField(
                  controller: _requestedTimeController,
                  onChanged: (_) => setState(() {}),
                  decoration: _fieldDecoration(
                    label: "Preferred time",
                    hint: "For example, 4:30 PM",
                    icon: Icons.schedule_outlined,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _queryController,
                  onChanged: (_) => setState(() {}),
                  maxLines: 2,
                  decoration: _fieldDecoration(
                    label: "Meeting query",
                    hint: "What would you like to discuss?",
                    icon: Icons.chat_bubble_outline,
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
                    disabledBackgroundColor: brandPurple.withOpacity(0.35),
                    minimumSize: const Size.fromHeight(52),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    _requestAnotherTime
                        ? "Prepare slot request"
                        : "Save preferred time",
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
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
