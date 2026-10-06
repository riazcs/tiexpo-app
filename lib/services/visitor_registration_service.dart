import 'dart:convert';

import 'package:http/http.dart' as http;

import '../api_config.dart';

class VisitorRegistrationService {
  static Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String company,
    required String jobTitle,
    required String event,
    required String notes,
    http.Client? client,
  }) async {
    final apiClient = client ?? http.Client();
    try {
      final response = await apiClient
          .post(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.register}'),
            headers: ApiConfig.defaultHeaders,
            body: jsonEncode({
              'type': 'visitor_registration',
              'name': name,
              'email': email,
              'phone': phone,
              'company': company,
              'job_title': jobTitle,
              'event': event,
              'notes': notes,
            }),
          )
          .timeout(const Duration(milliseconds: ApiConfig.receiveTimeoutMs));

      final body = _decodeResponse(response.body);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(_errorMessage(body, response.statusCode));
      }
      if (body['success'] != true) {
        throw Exception(_errorMessage(body, response.statusCode));
      }
    } finally {
      if (client == null) apiClient.close();
    }
  }

  static Map<String, dynamic> _decodeResponse(String responseBody) {
    final decoded = jsonDecode(responseBody);
    if (decoded is! Map) {
      throw const FormatException('Registration response must be an object.');
    }
    return Map<String, dynamic>.from(decoded);
  }

  static String _errorMessage(Map<String, dynamic> body, int statusCode) {
    final errors = body['errors'];
    if (errors is Map) {
      final messages = <String>[];
      for (final entry in errors.entries) {
        final value = entry.value;
        if (value is List) {
          messages.addAll(value.whereType<String>());
        } else if (value is String) {
          messages.add(value);
        }
      }
      if (messages.isNotEmpty) return messages.join('\n');
    }

    final message = body['message'] ?? body['error'];
    if (message is String && message.isNotEmpty) return message;
    return 'Visitor registration failed ($statusCode).';
  }
}
