import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:url_launcher/url_launcher.dart";
import "package:webview_flutter/webview_flutter.dart";

import "../api_config.dart";
import "../data/expo.dart";
import "../services/booking_service.dart";
import "../services/company_profile_service.dart";
import "../theme.dart";
import "login.dart";

String _plainText(String html) {
  return html
      .replaceAll(RegExp(r"<[^>]*>"), " ")
      .replaceAll(RegExp(r"&nbsp;"), " ")
      .replaceAll(RegExp(r"\s+"), " ")
      .trim();
}

class ExhibitorDetail extends StatefulWidget {
  const ExhibitorDetail({super.key, required this.id, this.onLoginSuccess})
    : exhibitor = null;

  factory ExhibitorDetail.fromExhibitor({
    Key? key,
    required Exhibitor exhibitor,
    VoidCallback? onLoginSuccess,
  }) => ExhibitorDetail._(
    key: key,
    id: exhibitor.id,
    exhibitor: exhibitor,
    onLoginSuccess: onLoginSuccess,
  );

  const ExhibitorDetail._({
    super.key,
    required this.id,
    this.exhibitor,
    this.onLoginSuccess,
  });

  final String id;
  final Exhibitor? exhibitor;
  final VoidCallback? onLoginSuccess;

  @override
  State<ExhibitorDetail> createState() => _ExhibitorDetailState();
}

class _ExhibitorDetailState extends State<ExhibitorDetail> {
  static const Color accentMauve = Color(0xFFA083B3);
  Exhibitor? _liveExhibitor;
  bool _isLoadingProfile = false;
  String? _profileError;

  Exhibitor? get _initialExhibitor =>
      widget.exhibitor ?? exhibitorById(widget.id);

  String? get _companySlug {
    final slug = _initialExhibitor?.slug;
    if (slug != null && slug.isNotEmpty) return slug;
    if (_initialExhibitor != null) return null;
    return int.tryParse(widget.id) == null ? widget.id : null;
  }

  @override
  void initState() {
    super.initState();
    if (_companySlug != null) _loadCompanyProfile();
  }

  Future<void> _loadCompanyProfile() async {
    final slug = _companySlug;
    if (slug == null || slug.isEmpty) return;
    setState(() {
      _isLoadingProfile = true;
      _profileError = null;
    });

    try {
      final profile = await CompanyProfileService.load(slug: slug);
      if (!mounted) return;
      final initialExhibitor = _initialExhibitor;
      setState(() {
        _liveExhibitor = initialExhibitor == null
            ? profile
            : initialExhibitor.withProfile(profile);
        _isLoadingProfile = false;
      });
    } on Exception catch (error) {
      if (!mounted) return;
      setState(() {
        _profileError = error.toString();
        _isLoadingProfile = false;
      });
    }
  }

  String? _resolveAsset(String? path) {
    if (path == null || path.isEmpty) return null;
    final uri = Uri.tryParse(path);
    if (uri == null) return null;
    if (uri.hasScheme) return uri.toString();
    return Uri.parse(
      ApiConfig.featuredCompanyAssetsBaseUrl,
    ).resolveUri(uri).toString();
  }

  String _stripHtml(String html) {
    return _plainText(html);
  }

  bool _hasCompanyFacts(Exhibitor exhibitor) =>
      exhibitor.address != null ||
      exhibitor.establishedYear != null ||
      exhibitor.employeeCount != null ||
      exhibitor.targetMarket != null ||
      exhibitor.mainProducts != null;

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
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    var token = prefs.getString("auth_token");
    var userId = prefs.getString("auth_user_id");
    if (token == null || token.isEmpty || userId == null || userId.isEmpty) {
      final authenticated = await Navigator.of(context).push<bool>(
        MaterialPageRoute<bool>(
          builder: (_) => LoginScreen(
            onLoginSuccess: widget.onLoginSuccess,
            returnToCallerOnSuccess: true,
          ),
        ),
      );
      if (!mounted || authenticated != true) return;
      final updatedPrefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      token = updatedPrefs.getString("auth_token");
      userId = updatedPrefs.getString("auth_user_id");
      if (token == null || token.isEmpty || userId == null || userId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please sign in again before booking a meeting."),
          ),
        );
        return;
      }
    }

    if (!mounted) return;
    final booking = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _MeetingBookingSheet(
        companyName: exhibitor.name,
        companyId: exhibitor.id,
      ),
    );

    if (booking == null || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Booking request sent for ${exhibitor.name}: $booking"),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final exhibitor = _liveExhibitor ?? _initialExhibitor;
    if (exhibitor == null) {
      return Scaffold(
        backgroundColor: paper,
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: brandInk,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        body: Center(
          child: _isLoadingProfile
              ? const CircularProgressIndicator(color: brandPurple)
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Could not load this company profile."),
                    if (_profileError != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _profileError!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: brandMuted),
                      ),
                    ],
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: _loadCompanyProfile,
                      child: const Text("Retry"),
                    ),
                  ],
                ),
        ),
      );
    }

    final logoUrl = _resolveAsset(exhibitor.logoUrl);
    final coverUrl = _resolveAsset(exhibitor.coverUrl);
    final aboutText = _stripHtml(exhibitor.blurb);
    final products = exhibitor.products.take(2).toList();
    final videoUrls = exhibitor.videoUrls.isNotEmpty
        ? exhibitor.videoUrls.take(2).toList()
        : exhibitor.videoUrl == null
        ? const <String>[]
        : [exhibitor.videoUrl!].take(2).toList();
    final news = exhibitor.news.take(2).toList();

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
        actions: [
          if (_isLoadingProfile)
            const Padding(
              padding: EdgeInsets.only(right: 18),
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: brandPurple,
                  ),
                ),
              ),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFE8E4EE)),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: appBackgroundGradient),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
          children: [
            // ========== COVER + LOGO ==========
            const SizedBox(height: 12),
            _GlassCard(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cover
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: SizedBox(
                      height: 140,
                      width: double.infinity,
                      child: coverUrl != null
                          ? Image.network(
                              coverUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _coverPlaceholder(),
                            )
                          : _coverPlaceholder(),
                    ),
                  ),
                  // Logo + identity
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Transform.translate(
                          offset: const Offset(0, -28),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: accentMauve.withOpacity(0.12),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(13),
                                  child: logoUrl != null
                                      ? Image.network(
                                          logoUrl,
                                          fit: BoxFit.contain,
                                          errorBuilder: (_, __, ___) =>
                                              const Icon(
                                                Icons.apartment_rounded,
                                                color: brandPurple,
                                                size: 32,
                                              ),
                                        )
                                      : const Icon(
                                          Icons.apartment_rounded,
                                          color: brandPurple,
                                          size: 32,
                                        ),
                                ),
                              ),
                              const Spacer(),
                              if (exhibitor.category.isNotEmpty)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 6),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: brandPurple.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    exhibitor.category.toUpperCase(),
                                    style: const TextStyle(
                                      color: brandPurple,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0, -16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exhibitor.name,
                                style: GoogleFonts.fraunces(
                                  color: brandInk,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  height: 1.15,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  if (exhibitor.hall.isNotEmpty)
                                    _ProfileMeta(
                                      icon: Icons.location_on_outlined,
                                      label: exhibitor.hall,
                                    ),
                                  if (exhibitor.booth.isNotEmpty)
                                    _ProfileMeta(
                                      icon: Icons.storefront_outlined,
                                      label: "Booth ${exhibitor.booth}",
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (_profileError != null) ...[
              const SizedBox(height: 10),
              _GlassCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.cloud_off_outlined, color: brandPurple),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        "Could not refresh this company profile. Showing the available directory information.",
                        style: TextStyle(
                          color: brandInk,
                          fontSize: 12,
                          height: 1.35,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _loadCompanyProfile,
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            ],

            if (exhibitor.isDemo) ...[
              const SizedBox(height: 10),
              _GlassCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
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

            // ========== INNOVATION STORY ==========
            const _SectionHeading(title: "Innovation story"),
            const SizedBox(height: 10),
            _GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exhibitor.mainProducts != null
                        ? "${exhibitor.name}'s innovation focus includes ${exhibitor.mainProducts}."
                        : "Explore ${exhibitor.name}'s work in the ${exhibitor.category} sector.",
                    style: const TextStyle(
                      color: brandMuted,
                      fontSize: 14.5,
                      height: 1.55,
                    ),
                  ),
                  if (exhibitor.tags.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: exhibitor.tags
                          .take(4)
                          .map(
                            (tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: paper2.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(
                                  color: brandPurple,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 22),

            // ========== ABOUT ==========
            const _SectionHeading(title: "About the company"),
            const SizedBox(height: 10),
            _GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    aboutText.isNotEmpty
                        ? aboutText
                        : "This company has not published an about description yet.",
                    style: const TextStyle(
                      color: brandMuted,
                      fontSize: 14.5,
                      height: 1.55,
                    ),
                  ),
                  if (exhibitor.website != null &&
                      exhibitor.website!.isNotEmpty) ...[
                    const SizedBox(height: 14),
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

            if (_hasCompanyFacts(exhibitor)) ...[
              const SizedBox(height: 22),
              const _SectionHeading(title: "Company at a glance"),
              const SizedBox(height: 10),
              _GlassCard(
                child: Column(
                  children: [
                    if (exhibitor.address != null)
                      _CompanyFact(
                        icon: Icons.location_on_outlined,
                        label: "Address",
                        value: exhibitor.address!,
                      ),
                    if (exhibitor.establishedYear != null)
                      _CompanyFact(
                        icon: Icons.history_rounded,
                        label: "Established",
                        value: exhibitor.establishedYear!,
                      ),
                    if (exhibitor.employeeCount != null)
                      _CompanyFact(
                        icon: Icons.groups_2_outlined,
                        label: "Company size",
                        value: exhibitor.employeeCount!,
                      ),
                    if (exhibitor.targetMarket != null)
                      _CompanyFact(
                        icon: Icons.public_outlined,
                        label: "Target market",
                        value: exhibitor.targetMarket!,
                      ),
                    if (exhibitor.mainProducts != null)
                      _CompanyFact(
                        icon: Icons.category_outlined,
                        label: "Main products",
                        value: exhibitor.mainProducts!,
                      ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 22),

            // ========== BROCHURE ==========
            const _SectionHeading(title: "Company catalogue"),
            const SizedBox(height: 10),
            _GlassCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
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
                          ? "No catalogue published yet."
                          : "View company catalogue / brochure.",
                      style: const TextStyle(
                        color: brandMuted,
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ),
                  if (exhibitor.brochureUrl != null)
                    TextButton(
                      onPressed: () => _openExternalLink(
                        _resolveAsset(exhibitor.brochureUrl) ??
                            exhibitor.brochureUrl!,
                      ),
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
            if (videoUrls.isEmpty)
              const _GlassCard(
                child: Row(
                  children: [
                    Icon(
                      Icons.play_circle_outline_rounded,
                      color: brandPurple,
                      size: 28,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Company videos will appear here when available.",
                        style: TextStyle(color: brandMuted, fontSize: 13.5),
                      ),
                    ),
                  ],
                ),
              )
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  final cardWidth = (constraints.maxWidth - 10) / 2;
                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (var index = 0; index < videoUrls.length; index++)
                        SizedBox(
                          width: cardWidth,
                          child: _CompanyVideoCard(
                            url: videoUrls[index],
                            label: "Company video ${index + 1}",
                            onOpen: () => _openExternalLink(videoUrls[index]),
                          ),
                        ),
                    ],
                  );
                },
              ),

            const SizedBox(height: 22),

            // ========== PRODUCTS ==========
            const _SectionHeading(title: "Products & solutions"),
            const SizedBox(height: 10),
            if (products.isEmpty)
              const _GlassCard(
                child: Text(
                  "Product information has not been published yet.",
                  style: TextStyle(color: brandMuted, fontSize: 13.5),
                ),
              )
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  final cardWidth = (constraints.maxWidth - 10) / 2;
                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (var index = 0; index < products.length; index++)
                        SizedBox(
                          width: cardWidth,
                          child: _ProductCard(
                            name: products[index],
                            imageUrl: index < exhibitor.productDetails.length
                                ? exhibitor.productDetails[index].imageUrl
                                : null,
                            description: index < exhibitor.productDetails.length
                                ? exhibitor.productDetails[index].description
                                : null,
                          ),
                        ),
                    ],
                  );
                },
              ),

            const SizedBox(height: 22),

            // ========== NEWS ==========
            const _SectionHeading(title: "News & updates"),
            const SizedBox(height: 10),
            if (news.isEmpty)
              const _GlassCard(
                child: Text(
                  "No company updates have been published yet.",
                  style: TextStyle(color: brandMuted, fontSize: 13.5),
                ),
              )
            else
              ...news.map(
                (news) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _GlassCard(
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
              ),

            const SizedBox(height: 12),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          border: const Border(top: BorderSide(color: Color(0xFFE8E4EE))),
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

  Widget _coverPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            brandPurple.withOpacity(0.35),
            accentMauve.withOpacity(0.25),
            const Color(0xFFDE1B85).withOpacity(0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.business_rounded,
          size: 40,
          color: Colors.white.withOpacity(0.45),
        ),
      ),
    );
  }
}

// ---------- Shared glass card ----------
class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.78),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.95)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFA083B3).withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
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
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                color: brandInk,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompanyFact extends StatelessWidget {
  const _CompanyFact({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: brandPurple, size: 19),
          const SizedBox(width: 10),
          SizedBox(
            width: 92,
            child: Text(
              label,
              style: const TextStyle(
                color: brandMuted,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: brandInk,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.name, this.imageUrl, this.description});

  final String name;
  final String? imageUrl;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final resolvedUrl = ApiConfig.resolveAssetUrl(imageUrl);
    final cleanDescription = description == null
        ? ""
        : _plainText(description!);
    return _GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: SizedBox(
              height: 112,
              width: double.infinity,
              child: resolvedUrl == null
                  ? const _ProductImagePlaceholder()
                  : Image.network(
                      resolvedUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const _ProductImagePlaceholder(),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(11, 11, 11, 13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: brandInk,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    height: 1.25,
                  ),
                ),
                if (cleanDescription.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Text(
                    cleanDescription,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: brandMuted,
                      fontSize: 11,
                      height: 1.35,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductImagePlaceholder extends StatelessWidget {
  const _ProductImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF5EAF8), Color(0xFFE6F4F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(Icons.inventory_2_outlined, color: brandPurple, size: 34),
      ),
    );
  }
}

class _CompanyVideoCard extends StatelessWidget {
  const _CompanyVideoCard({
    required this.url,
    required this.label,
    required this.onOpen,
  });

  final String url;
  final String label;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final videoId = _youtubeVideoId(url);
    return _GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: videoId == null
                  ? _VideoLinkPreview(onOpen: onOpen)
                  : _YoutubeIframe(videoId: videoId),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 9, 10, 10),
            child: Row(
              children: [
                const Icon(
                  Icons.play_circle_fill_rounded,
                  color: brandPurple,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: brandInk,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoLinkPreview extends StatelessWidget {
  const _VideoLinkPreview({required this.onOpen});

  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF201A2E),
      child: InkWell(
        onTap: onOpen,
        child: const Center(
          child: Icon(
            Icons.play_circle_fill_rounded,
            color: Colors.white,
            size: 42,
          ),
        ),
      ),
    );
  }
}

class _YoutubeIframe extends StatefulWidget {
  const _YoutubeIframe({required this.videoId});

  final String videoId;

  @override
  State<_YoutubeIframe> createState() => _YoutubeIframeState();
}

class _YoutubeIframeState extends State<_YoutubeIframe> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    final html =
        '''
<!doctype html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
  <style>
    html, body { margin: 0; padding: 0; width: 100%; height: 100%; background: #17131f; overflow: hidden; }
    iframe { width: 100%; height: 100%; border: 0; }
  </style>
</head>
<body>
  <iframe
    src="https://www.youtube-nocookie.com/embed/${widget.videoId}?playsinline=1&rel=0"
    title="Company video"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    referrerpolicy="strict-origin-when-cross-origin"
    allowfullscreen>
  </iframe>
</body>
</html>
''';
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF17131F))
      ..loadHtmlString(html, baseUrl: "https://www.youtube-nocookie.com");
  }

  @override
  Widget build(BuildContext context) => WebViewWidget(controller: _controller);
}

String? _youtubeVideoId(String source) {
  final uri = Uri.tryParse(source);
  if (uri == null) return null;
  final host = uri.host.toLowerCase();
  if (host == "youtu.be") {
    final id = uri.pathSegments.isEmpty ? null : uri.pathSegments.first;
    return id != null && RegExp(r"^[\w-]{11}$").hasMatch(id) ? id : null;
  }
  if (host != "youtube.com" &&
      host != "www.youtube.com" &&
      host != "m.youtube.com" &&
      host != "youtube-nocookie.com" &&
      host != "www.youtube-nocookie.com") {
    return null;
  }
  final id =
      uri.queryParameters["v"] ??
      (uri.pathSegments.length >= 2 &&
              const {"embed", "shorts", "live"}.contains(uri.pathSegments[0])
          ? uri.pathSegments[1]
          : null);
  return id != null && RegExp(r"^[\w-]{11}$").hasMatch(id) ? id : null;
}

// Keep your existing _MeetingBookingSheet as-is (already solid)

class _MeetingBookingSheet extends StatefulWidget {
  const _MeetingBookingSheet({
    required this.companyName,
    required this.companyId,
  });
  final String companyName;
  final String companyId;

  @override
  State<_MeetingBookingSheet> createState() => _MeetingBookingSheetState();
}

class _MeetingBookingSheetState extends State<_MeetingBookingSheet> {
  final _queryController = TextEditingController();
  static const _bookingDays = <(int, String, int, int)>[
    (1, "Thu 12 Nov", 11 * 60 + 30, 18 * 60),
    (2, "Fri 13 Nov", 11 * 60, 18 * 60),
    (3, "Sat 14 Nov", 11 * 60, 17 * 60),
  ];

  int selectedDay = 1;
  String? selectedSlot;
  bool _isSubmitting = false;
  String? _errorMessage;

  List<String> get _daySlots {
    final schedule = _bookingDays.firstWhere((day) => day.$1 == selectedDay);
    final startMinute = schedule.$3;
    final endMinute = schedule.$4;
    return [
      for (var minute = startMinute; minute < endMinute; minute += 30)
        "${_formatTime(minute)} - ${_formatTime(minute + 30)}",
    ];
  }

  String _formatTime(int minutes) {
    final hour = minutes ~/ 60;
    final minute = minutes % 60;
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    final period = hour < 12 ? "AM" : "PM";
    return "$hour12.${minute.toString().padLeft(2, "0")} $period";
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  Future<void> _submitBooking() async {
    if (!_canSubmit || _isSubmitting) return;
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");
      final userId = prefs.getString("auth_user_id");
      if (token == null || token.isEmpty || userId == null || userId.isEmpty) {
        throw Exception("Please sign in again before booking a meeting.");
      }

      final dayLabel = _bookingDays
          .firstWhere((day) => day.$1 == selectedDay)
          .$2;
      final timeSlot = "$dayLabel $selectedSlot";
      await BookingService.create(
        token: token,
        userId: userId,
        companyId: widget.companyId,
        timeSlot: timeSlot,
        query: _queryController.text.trim(),
      );

      if (mounted) Navigator.of(context).pop(timeSlot);
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = error.toString().replaceFirst("Exception: ", "");
        });
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
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
                children: _bookingDays
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
                          _errorMessage = null;
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
                          _errorMessage = null;
                        }),
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 12),
              TextField(
                controller: _queryController,
                onChanged: (_) => setState(() => _errorMessage = null),
                maxLines: 3,
                decoration: _fieldDecoration(
                  label: "Why do you want to meet?",
                  hint: "What would you like to discuss?",
                  icon: Icons.chat_bubble_outline,
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _canSubmit && !_isSubmitting
                      ? _submitBooking
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
                    _isSubmitting ? "Sending booking..." : "Book meeting",
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

  bool get _canSubmit =>
      selectedSlot != null && _queryController.text.trim().isNotEmpty;
}
