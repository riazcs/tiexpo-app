import "package:flutter/material.dart";

import "../api_config.dart";
import "../data/expo.dart";
import "../services/exhibitor_service.dart";
import "../theme.dart";
import "../screens/exhibitor_detail.dart";
import "glass_card.dart";

class ExhibitorDirectorySection extends StatefulWidget {
  const ExhibitorDirectorySection({
    super.key,
    this.onLoginSuccess,
  });

  final VoidCallback? onLoginSuccess;

  @override
  ExhibitorDirectorySectionState createState() =>
      ExhibitorDirectorySectionState();
}

class ExhibitorDirectorySectionState extends State<ExhibitorDirectorySection> {
  String _query = "";
  String _selectedCategory = "All";
  List<Exhibitor> _exhibitors = const [];
  String? _directoryMessage = "Loading live exhibitor directory...";
  String? _paginationMessage;
  bool _usingDemoData = true;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMorePages = false;
  int _nextPage = 1;
  int _requestVersion = 0;

  static const Color accentMauve = Color(0xFFA083B3);

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future<void> refresh() async {
    final requestVersion = ++_requestVersion;
    setState(() {
      _isLoading = true;
      _isLoadingMore = false;
      _hasMorePages = false;
      _nextPage = 1;
      _paginationMessage = null;
    });
    final result = await ExhibitorService.load(page: 1);
    if (!mounted || requestVersion != _requestVersion) return;
    setState(() {
      _exhibitors = result.exhibitors;
      _usingDemoData = result.isDemo;
      _directoryMessage = result.message;
      _hasMorePages = result.hasMorePages;
      _nextPage = 2;
      _isLoading = false;
    });
  }

  Future<void> loadNextPage() async {
    if (_isLoading ||
        _isLoadingMore ||
        !_hasMorePages ||
        _paginationMessage != null) {
      return;
    }

    final requestVersion = _requestVersion;
    final requestedPage = _nextPage;
    setState(() {
      _isLoadingMore = true;
      _paginationMessage = null;
    });
    final result = await ExhibitorService.load(page: requestedPage);
    if (!mounted || requestVersion != _requestVersion) return;

    setState(() {
      if (result.message != null && result.exhibitors.isEmpty) {
        _paginationMessage = result.message;
      } else {
        final existingIds = _exhibitors.map((e) => e.id).toSet();
        _exhibitors = [
          ..._exhibitors,
          ...result.exhibitors.where((e) => existingIds.add(e.id)),
        ];
        _nextPage = requestedPage + 1;
        _hasMorePages = result.hasMorePages;
      }
      _isLoadingMore = false;
    });
  }

  Future<void> retryNextPage() async {
    if (_paginationMessage == null) return;
    setState(() => _paginationMessage = null);
    await loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final normalizedQuery = _query.trim().toLowerCase();
    final categories = _exhibitors
        .map((e) => e.category)
        .where((c) => c.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    final filteredExhibitors = _exhibitors.where((exhibitor) {
      final matchesQuery = normalizedQuery.isEmpty ||
          exhibitor.name.toLowerCase().contains(normalizedQuery) ||
          exhibitor.booth.toLowerCase().contains(normalizedQuery) ||
          exhibitor.category.toLowerCase().contains(normalizedQuery) ||
          exhibitor.tags.any((t) => t.toLowerCase().contains(normalizedQuery));
      final matchesCategory = _selectedCategory == "All" ||
          exhibitor.category == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status bar
        GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          borderRadius: 14,
          blur: 12,
          tintOpacity: 0.72,
          child: Row(
            children: [
              if (_isLoading)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: brandPurple,
                  ),
                )
              else
                Icon(
                  _usingDemoData
                      ? Icons.info_outline_rounded
                      : Icons.cloud_done_outlined,
                  size: 18,
                  color: _usingDemoData ? brandPurple : brandCyan,
                ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _isLoading
                      ? "Loading companies..."
                      : _usingDemoData
                          ? "DEMO · ${_directoryMessage ?? 'Sample data'}"
                          : "${filteredExhibitors.length} companies",
                  style: TextStyle(
                    color: _usingDemoData ? brandPurple : brandInk,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (!_isLoading)
                IconButton(
                  tooltip: "Refresh",
                  onPressed: refresh,
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Search
        TextField(
          onChanged: (v) => setState(() => _query = v),
          decoration: InputDecoration(
            hintText: "Search companies, booth, category...",
            hintStyle: TextStyle(color: brandMuted.withOpacity(0.7), fontSize: 14),
            prefixIcon: const Icon(Icons.search_rounded, color: brandMuted, size: 22),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.7),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.9)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.9)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: brandPurple, width: 1.5),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Category chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ["All", ...categories].map((category) {
              final isSelected = _selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  showCheckmark: false,
                  selectedColor: brandPurple,
                  backgroundColor: Colors.white.withValues(alpha: 0.55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected
                          ? brandPurple
                          : Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : brandInk,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                  ),
                  onSelected: (_) =>
                      setState(() => _selectedCategory = category),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 14),

        // List
        if (filteredExhibitors.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 28),
            child: Center(
              child: Text(
                _isLoading
                    ? "Loading featured companies..."
                    : "No companies match this search.",
                style: const TextStyle(color: brandMuted, fontSize: 14),
              ),
            ),
          )
        else
          ...filteredExhibitors.map(
            (exhibitor) => _CompanyGlassCard(
              exhibitor: exhibitor,
              onLoginSuccess: widget.onLoginSuccess,
            ),
          ),

        // Pagination (OUTSIDE the cards)
        if (_paginationMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            child: GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              borderRadius: 14,
              child: Row(
                children: [
                  const Icon(Icons.cloud_off_outlined, color: brandPurple, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _paginationMessage!,
                      style: const TextStyle(color: brandInk, fontSize: 12.5),
                    ),
                  ),
                  TextButton(
                    onPressed: retryNextPage,
                    child: const Text("Retry"),
                  ),
                ],
              ),
            ),
          )
        else if (_isLoadingMore)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: brandPurple,
                ),
              ),
            ),
          )
        else if (_hasMorePages && !_isLoading)
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            child: Center(
              child: TextButton.icon(
                onPressed: loadNextPage,
                icon: const Icon(Icons.expand_more_rounded),
                label: const Text("Load more companies"),
                style: TextButton.styleFrom(foregroundColor: brandPurple),
              ),
            ),
          ),
      ],
    );
  }
}

// ==================== MODERN GLASS COMPANY CARD ====================
class _CompanyGlassCard extends StatelessWidget {
  const _CompanyGlassCard({
    required this.exhibitor,
    this.onLoginSuccess,
  });

  final Exhibitor exhibitor;
  final VoidCallback? onLoginSuccess;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      borderRadius: 18,
      blur: 16,
      tintOpacity: 0.68,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ExhibitorDetail.fromExhibitor(
                exhibitor: exhibitor,
                onLoginSuccess: onLoginSuccess,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Logo
                _CompanyLogo(logoUrl: exhibitor.logoUrl),
                const SizedBox(width: 14),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exhibitor.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: brandInk,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Category pill
                      if (exhibitor.category.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: brandPurple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: brandPurple.withOpacity(0.18),
                            ),
                          ),
                          child: Text(
                            exhibitor.category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: brandPurple,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      // Booth (if available)
                      if (exhibitor.booth.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.storefront_outlined,
                              size: 13,
                              color: brandMuted.withOpacity(0.8),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Booth ${exhibitor.booth}",
                              style: TextStyle(
                                color: brandMuted.withOpacity(0.9),
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Chevron
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.75),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: brandPurple,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CompanyLogo extends StatelessWidget {
  const _CompanyLogo({required this.logoUrl});

  final String? logoUrl;

  @override
  Widget build(BuildContext context) {
    final imageUri = _imageUri(logoUrl);
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.95)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: imageUri == null
            ? const Icon(Icons.apartment_rounded, color: brandPurple, size: 26)
            : Image.network(
                imageUri,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.apartment_rounded,
                  color: brandPurple,
                  size: 26,
                ),
              ),
      ),
    );
  }

  String? _imageUri(String? value) {
    if (value == null || value.isEmpty) return null;
    final uri = Uri.tryParse(value);
    if (uri == null) return null;
    if (uri.hasScheme) return uri.toString();
    return Uri.parse(ApiConfig.featuredCompanyAssetsBaseUrl)
        .resolveUri(uri)
        .toString();
  }
}