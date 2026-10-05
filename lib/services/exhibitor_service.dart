import "dart:convert";

import "package:http/http.dart" as http;

import "../api_config.dart";
import "../data/expo.dart";

class ExhibitorDirectoryResult {
  const ExhibitorDirectoryResult({
    required this.exhibitors,
    required this.isDemo,
    this.message,
  });

  final List<Exhibitor> exhibitors;
  final bool isDemo;
  final String? message;
}

class ExhibitorService {
  static Future<ExhibitorDirectoryResult> load({http.Client? client}) async {
    final apiClient = client ?? http.Client();
    try {
      final response = await apiClient
          .get(
            Uri.parse("${ApiConfig.baseUrl}${ApiConfig.exhibitors}"),
            headers: ApiConfig.defaultHeaders,
          )
          .timeout(const Duration(milliseconds: ApiConfig.receiveTimeoutMs));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return _demoResult(
          "Exhibitor API returned ${response.statusCode}; showing sample data.",
        );
      }

      final decoded = jsonDecode(response.body);
      final records = _extractRecords(decoded);
      final exhibitors = <Exhibitor>[];
      for (final record in records) {
        if (record is! Map) continue;
        try {
          exhibitors.add(Exhibitor.fromJson(Map<String, dynamic>.from(record)));
        } on FormatException {
          continue;
        }
      }

      if (exhibitors.isEmpty) {
        return _demoResult("No live exhibitors yet; showing sample data.");
      }
      return ExhibitorDirectoryResult(
        exhibitors: List.unmodifiable(exhibitors),
        isDemo: false,
      );
    } catch (_) {
      return _demoResult(
        "Could not reach the exhibitor API; showing sample data.",
      );
    } finally {
      if (client == null) apiClient.close();
    }
  }

  static ExhibitorDirectoryResult _demoResult(String message) =>
      ExhibitorDirectoryResult(
        exhibitors: demoExhibitors,
        isDemo: true,
        message: message,
      );

  static List<dynamic> _extractRecords(Object? decoded) {
    if (decoded is List) return decoded;
    if (decoded is! Map) return const [];

    for (final key in const ["data", "exhibitors", "results", "items"]) {
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
}
