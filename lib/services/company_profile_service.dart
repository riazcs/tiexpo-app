import "dart:convert";

import "package:http/http.dart" as http;

import "../api_config.dart";
import "../data/expo.dart";

class CompanyProfileService {
  static Future<Exhibitor> load({
    required String slug,
    http.Client? client,
  }) async {
    final apiClient = client ?? http.Client();
    try {
      final uri = Uri.parse(
        ApiConfig.companyDetails(Uri.encodeComponent(slug)),
      );
      final response = await apiClient
          .get(uri, headers: ApiConfig.defaultHeaders)
          .timeout(const Duration(milliseconds: ApiConfig.receiveTimeoutMs));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException(
          "Company profile request failed (${response.statusCode}).",
        );
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map || decoded["company"] is! Map) {
        throw const FormatException("Company profile response is invalid.");
      }
      return Exhibitor.fromJson(Map<String, dynamic>.from(decoded));
    } finally {
      if (client == null) apiClient.close();
    }
  }
}

class HttpException implements Exception {
  const HttpException(this.message);

  final String message;

  @override
  String toString() => message;
}
