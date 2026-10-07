import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_config.dart';

class VisitorRegistrationService {
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String company,
    required String jobTitle,
    required String event,
    required String notes,
    // required String recaptchaToken,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.register}');

    final body = {
      'type': 'visitor_registration', // required for correct route
      'name': name,
      'email': email,
      'phone': phone.isEmpty ? null : phone,
      'event': event,
      'company': company.isEmpty ? null : company, // NOT company_name
      'job_title': jobTitle.isEmpty ? null : jobTitle,
      'notes': notes.isEmpty ? null : notes,
      // 'recaptcha_token': recaptchaToken,
    };

    final response = await http
        .post(uri, headers: ApiConfig.defaultHeaders, body: jsonEncode(body))
        .timeout(const Duration(milliseconds: ApiConfig.receiveTimeoutMs));

    final decoded = response.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message =
          decoded['message']?.toString() ??
          decoded['error']?.toString() ??
          'Registration failed (${response.statusCode})';
      final errors = decoded['errors'];
      if (errors is Map && errors.isNotEmpty) {
        final first = errors.values.first;
        if (first is List && first.isNotEmpty) {
          throw Exception(first.first.toString());
        }
      }
      throw Exception(message);
    }

    if (decoded['success'] == false) {
      throw Exception(decoded['message']?.toString() ?? 'Registration failed');
    }

    return decoded;
  }
}
