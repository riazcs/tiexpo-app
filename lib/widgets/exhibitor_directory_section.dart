import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import "../data/expo.dart";
import "../services/exhibitor_service.dart";
import "../theme.dart";
import "../screens/exhibitor_detail.dart";

class ExhibitorDirectorySection extends StatefulWidget {
  const ExhibitorDirectorySection({super.key});

  @override
  ExhibitorDirectorySectionState createState() =>
      ExhibitorDirectorySectionState();
}

class ExhibitorDirectorySectionState extends State<ExhibitorDirectorySection> {
  String _query = "";
  String _selectedCategory = "All";
  List<Exhibitor> _exhibitors = demoExhibitors;
  String? _directoryMessage = "Loading live exhibitor directory...";
  bool _usingDemoData = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future<void> refresh() async {
    setState(() => _isLoading = true);
    final result = await ExhibitorService.load();
    if (!mounted) return;
    setState(() {
      _exhibitors = result.exhibitors;
      _usingDemoData = result.isDemo;
      _directoryMessage = result.message;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final normalizedQuery = _query.trim().toLowerCase();
    final filteredExhibitors = _exhibitors.where((exhibitor) {
      final matchesQuery =
          normalizedQuery.isEmpty ||
          exhibitor.name.toLowerCase().contains(normalizedQuery) ||
          exhibitor.booth.toLowerCase().contains(normalizedQuery) ||
          exhibitor.category.toLowerCase().contains(normalizedQuery) ||
          exhibitor.tags.any(
            (tag) => tag.toLowerCase().contains(normalizedQuery),
          );
      final matchesCategory =
          _selectedCategory == "All" ||
          _matchesCategory(exhibitor, _selectedCategory);
      return matchesQuery && matchesCategory;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Exhibitor directory",
              style: GoogleFonts.fraunces(
                color: brandInk,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "${filteredExhibitors.length} LISTED",
              style: const TextStyle(
                color: muted,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: _usingDemoData ? paper2 : brandCyanSoft,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: _usingDemoData ? const Color(0xFFE9D5FF) : brandBorder,
            ),
          ),
          child: Row(
            children: [
              if (_isLoading)
                const SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Icon(
                  _usingDemoData
                      ? Icons.info_outline
                      : Icons.cloud_done_outlined,
                  size: 17,
                  color: _usingDemoData ? brandPurple : brandCyan,
                ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _isLoading
                      ? "Loading live exhibitor data..."
                      : _usingDemoData
                      ? "DEMO DATA · ${_directoryMessage ?? 'Showing sample companies.'}"
                      : "LIVE DIRECTORY · ${filteredExhibitors.length} companies from the API",
                  style: TextStyle(
                    color: _usingDemoData ? brandPurple : brandInk,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (!_isLoading)
                IconButton(
                  tooltip: "Refresh company directory",
                  onPressed: refresh,
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.refresh, size: 18),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          onChanged: (value) => setState(() => _query = value),
          decoration: InputDecoration(
            hintText: "Search companies",
            prefixIcon: const Icon(Icons.search, color: brandMuted),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: brandBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: brandPurple, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ["All", "Materials", "Technology", "Circularity"].map((
              category,
            ) {
              final isSelected = _selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  selectedColor: brandPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: isSelected ? brandPurple : brandBorder,
                    ),
                  ),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : brandInk,
                    fontWeight: FontWeight.w600,
                  ),
                  onSelected: (_) => setState(() {
                    _selectedCategory = category;
                  }),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
        if (filteredExhibitors.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "No exhibitors match this search. Try another term or category.",
              style: TextStyle(color: brandMuted),
            ),
          )
        else
          ...filteredExhibitors
              .take(6)
              .map(
                (exhibitor) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: paper2,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.apartment, color: brandPurple),
                    ),
                    title: Text(
                      exhibitor.name,
                      style: const TextStyle(
                        color: brandInk,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      "${exhibitor.category}  ·  ${exhibitor.hall}  ·  Booth ${exhibitor.booth}",
                      style: const TextStyle(fontSize: 12, color: brandMuted),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward,
                      size: 17,
                      color: brandCyan,
                    ),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            ExhibitorDetail.fromExhibitor(exhibitor: exhibitor),
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  bool _matchesCategory(Exhibitor exhibitor, String category) {
    final searchable = "${exhibitor.category} ${exhibitor.tags.join(" ")}"
        .toLowerCase();
    final terms = switch (category) {
      "Materials" => ["fiber", "knit", "silk", "textile", "wearable", "color"],
      "Technology" => [
        "machinery",
        "loom",
        "software",
        "cad",
        "knit",
        "wearable",
      ],
      "Circularity" => [
        "recycl",
        "circular",
        "water",
        "finish",
        "climate",
        "flax",
      ],
      _ => const <String>[],
    };
    return terms.any(searchable.contains);
  }
}
