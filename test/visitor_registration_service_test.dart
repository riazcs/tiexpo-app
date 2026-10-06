import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:tiexpo/api_config.dart';
import 'package:tiexpo/services/visitor_registration_service.dart';

void main() {
  group('VisitorRegistrationService.register', () {
    test(
      'posts the visitor registration fields to the register endpoint',
      () async {
        final client = MockClient((request) async {
          expect(request.method, 'POST');
          expect(
            request.url,
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.register}'),
          );
          expect(jsonDecode(request.body), {
            'type': 'visitor_registration',
            'name': 'A Visitor',
            'email': 'visitor@example.com',
            'phone': '+880123456789',
            'company': 'Textile Co.',
            'job_title': 'Buyer',
            'event': 'Textile Materials Innovation Expo',
            'notes': 'Accessibility support',
          });
          return http.Response(
            jsonEncode({
              'success': true,
              'message': 'Visitor registration successful',
            }),
            201,
          );
        });

        await VisitorRegistrationService.register(
          name: 'A Visitor',
          email: 'visitor@example.com',
          phone: '+880123456789',
          company: 'Textile Co.',
          jobTitle: 'Buyer',
          event: 'Textile Materials Innovation Expo',
          notes: 'Accessibility support',
          client: client,
        );
      },
    );

    test('surfaces validation errors from the API', () async {
      final client = MockClient((_) async {
        return http.Response(
          jsonEncode({
            'success': false,
            'message': 'Validation failed',
            'errors': {
              'email': ['The email has already been taken.'],
            },
          }),
          422,
        );
      });

      await expectLater(
        VisitorRegistrationService.register(
          name: 'A Visitor',
          email: 'visitor@example.com',
          phone: '',
          company: '',
          jobTitle: '',
          event: 'Textile Materials Innovation Expo',
          notes: '',
          client: client,
        ),
        throwsA(
          isA<Exception>().having(
            (error) => error.toString(),
            'message',
            contains('The email has already been taken.'),
          ),
        ),
      );
    });
  });
}
