import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiexpo/screens/dashboard_profile_screen.dart';

void main() {
  testWidgets('profile displays the saved API user record', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'auth_user_data': jsonEncode({
        'id': 494,
        'name': 'Riazul Islam',
        'email': 'riazul.cse.mbstu@gmail.com',
        'profile_picture': null,
        'email_verified_at': null,
        'created_at': '2026-08-19T09:42:11.000000Z',
        'status': 8,
        'type': 'visitor',
        'company_name': null,
        'phone': '+1 (857) 546-1259',
        'job_title': null,
        'organization': null,
        'event': 'Green & SusTech Innovation Expo 2026',
        'roles': [
          {'id': 17, 'name': 'visitor'},
        ],
      }),
    });

    await tester.pumpWidget(const MaterialApp(home: DashboardProfileScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Riazul Islam'), findsOneWidget);
    expect(find.text('riazul.cse.mbstu@gmail.com'), findsOneWidget);
    expect(find.text('+1 (857) 546-1259'), findsOneWidget);
    expect(find.text('Visitor'), findsOneWidget);
    expect(find.text('494'), findsOneWidget);
    expect(find.text('Green & SusTech Innovation Expo 2026'), findsOneWidget);
    expect(find.text('19 Aug 2026'), findsOneWidget);
    expect(find.text('Not provided'), findsNWidgets(2));
    expect(find.text('Md Riazul Islam'), findsNothing);
  });
}
