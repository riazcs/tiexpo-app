import "dart:convert";

import "package:http/http.dart" as http;

import "../api_config.dart";
import "../data/expo.dart";

class ExhibitorDirectoryResult {
  const ExhibitorDirectoryResult({
    required this.exhibitors,
    required this.isDemo,
    required this.hasMorePages,
    this.message,
  });

  final List<Exhibitor> exhibitors;
  final bool isDemo;
  final bool hasMorePages;
  final String? message;
}

class ExhibitorService {
  static Future<ExhibitorDirectoryResult> load({
    int page = 1,
    http.Client? client,
  }) async {
    final apiClient = client ?? http.Client();
    try {
      final uri = Uri.parse(ApiConfig.featuredCompanies).replace(
        queryParameters: {"page": "$page"},
      );
      final response = await apiClient
          .get(uri, headers: ApiConfig.defaultHeaders)
          .timeout(const Duration(milliseconds: ApiConfig.receiveTimeoutMs));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return _failure(
          page,
          "Featured companies API returned ${response.statusCode}.",
        );
      }

      final decoded = jsonDecode(response.body);
      final exhibitors = <Exhibitor>[];
      for (final record in _extractRecords(decoded)) {
        if (record is! Map) continue;
        try {
          exhibitors.add(Exhibitor.fromJson(Map<String, dynamic>.from(record)));
        } on FormatException {
          continue;
        }
      }

      if (page == 1 && exhibitors.isEmpty) {
        return _demoResult(
          "No featured companies are available; showing sample data.",
        );
      }
      return ExhibitorDirectoryResult(
        exhibitors: List.unmodifiable(exhibitors),
        isDemo: false,
        hasMorePages: _hasMorePages(decoded, page),
      );
    } on Exception catch (error) {
      return _failure(page, "Could not load featured companies: $error");
    } finally {
      if (client == null) apiClient.close();
    }
  }

  static ExhibitorDirectoryResult _failure(int page, String message) {
    if (page == 1) return _demoResult("$message Showing sample data.");
    return ExhibitorDirectoryResult(
      exhibitors: const [],
      isDemo: false,
      hasMorePages: true,
      message: message,
    );
  }

  static ExhibitorDirectoryResult _demoResult(String message) =>
      ExhibitorDirectoryResult(
        exhibitors: demoExhibitors,
        isDemo: true,
        hasMorePages: false,
        message: message,
      );

  static List<dynamic> _extractRecords(Object? decoded) {
    if (decoded is List) return decoded;
    if (decoded is! Map) return const [];

    for (final key in const [
      "companies",
      "data",
      "exhibitors",
      "results",
      "items",
    ]) {
      final value = decoded[key];
      if (value is List) return value;
      if (value is Map) {
        final nested = _extractRecords(value);
        if (nested.isNotEmpty) return nested;
      }
    }

    if (decoded.containsKey("name") ||
        decoded.containsKey("company_name") ||
        decoded.containsKey("companyName")) {
      return [decoded];
    }
    return const [];
  }

  static Map _extractPagination(Object? decoded) {
    if (decoded is! Map) return const {};
    final pagination = decoded["pagination"];
    return pagination is Map ? pagination : const {};
  }

  static bool _hasMorePages(Object? decoded, int page) {
    final pagination = _extractPagination(decoded);
    if (pagination["has_more_pages"] == true) return true;
    final lastPage = int.tryParse("${pagination["last_page"]}");
    return lastPage != null && lastPage > page;
  }
}
