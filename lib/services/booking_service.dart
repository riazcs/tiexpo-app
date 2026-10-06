import "dart:convert";

import "package:http/http.dart" as http;

import "../api_config.dart";

class BookingService {
  static Future<void> create({
    required String token,
    required String userId,
    required String companyId,
    required String timeSlot,
    required String query,
    http.Client? client,
  }) async {
    final apiClient = client ?? http.Client();
    try {
      final response = await apiClient
          .post(
            Uri.parse("${ApiConfig.baseUrl}${ApiConfig.bookings}"),
            headers: ApiConfig.authHeaders(token),
            body: jsonEncode({
              "user_id": userId,
              "company_id": companyId,
              "time_slot": timeSlot,
              "query": query,
            }),
          )
          .timeout(const Duration(milliseconds: ApiConfig.receiveTimeoutMs));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(_errorMessage(response));
      }
    } finally {
      if (client == null) apiClient.close();
    }
  }

  static String _errorMessage(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map) {
        final message = decoded["message"] ?? decoded["error"];
        if (message is String && message.isNotEmpty) return message;
      }
    } on FormatException {
      // Use the status code when the server response is not JSON.
    }
    return "Booking request failed (${response.statusCode}).";
  }
}
