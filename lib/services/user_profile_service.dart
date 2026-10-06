import "dart:convert";

import "package:http/http.dart" as http;

import "../api_config.dart";

class UserProfileService {
  static Future<Map<String, dynamic>> load({
    required String token,
    http.Client? client,
  }) async {
    final apiClient = client ?? http.Client();
    try {
      final response = await apiClient
          .get(
            Uri.parse("${ApiConfig.baseUrl}${ApiConfig.profile}"),
            headers: ApiConfig.authHeaders(token),
          )
          .timeout(const Duration(milliseconds: ApiConfig.receiveTimeoutMs));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception("Profile request failed (${response.statusCode}).");
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map) {
        throw const FormatException("Profile response must be an object.");
      }

      final body = Map<String, dynamic>.from(decoded);
      final data = body["data"];
      final user = body["user"] ?? (data is Map ? data["user"] : null);
      if (user is Map) return Map<String, dynamic>.from(user);
      if (data is Map) return Map<String, dynamic>.from(data);
      if (body.containsKey("id") || body.containsKey("name")) return body;
      throw const FormatException("Profile response does not contain a user.");
    } finally {
      if (client == null) apiClient.close();
    }
  }
}
