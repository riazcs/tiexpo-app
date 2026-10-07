// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tiexpo/data/expo.dart';
import 'package:tiexpo/main.dart';
import 'package:tiexpo/screens/exhibitor_detail.dart';
import 'package:tiexpo/screens/home.dart';
import 'package:tiexpo/screens/meet.dart';
import 'package:tiexpo/screens/visitor_registration.dart';

void main() {
  testWidgets('app shows the primary actions', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const TiexpoApp());
    await tester.pumpAndSettle();

    expect(find.text('Register'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Dyeing & Printing Innovation Expo 2026'), findsOneWidget);
    expect(find.text('Dyeing & Printing'), findsOneWidget);
  });

  testWidgets('home venue row fits a narrow screen', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: HomeScreen())),
    );
    await tester.pump(const Duration(milliseconds: 100));

    expect(tester.takeException(), isNull);
  });

  testWidgets('visitor expo selector fits a narrow screen', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(home: VisitorRegistrationScreen()),
    );
    await tester.ensureVisible(find.text('Select an expo *'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('Meet screen shows the shared exhibitor directory', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: MeetScreen())),
    );
    await tester.pump();

    expect(find.text('Exhibitor directory'), findsOneWidget);
    expect(find.text('Search companies'), findsOneWidget);
    expect(find.text('Demo Loom Works'), findsOneWidget);
  });

  testWidgets('meeting booking offers the correct slots on all expo days', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'auth_token': 'test-token',
      'auth_user_id': '1',
    });
    const testExhibitor = Exhibitor(
      id: 'test-company',
      name: 'Test Textiles',
      category: 'Materials',
      booth: 'A12',
      hall: 'Hall A',
      blurb: 'A test company profile.',
      tags: [],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: ExhibitorDetail.fromExhibitor(exhibitor: testExhibitor),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Book a meeting slot'));
    await tester.pumpAndSettle();
    expect(find.text('Meet Test Textiles'), findsOneWidget);
    expect(find.text('Thu 12 Nov'), findsOneWidget);
    expect(find.text('Fri 13 Nov'), findsOneWidget);
    expect(find.text('Sat 14 Nov'), findsOneWidget);

    expect(find.text('11.30 AM - 12.00 PM'), findsOneWidget);
    expect(find.text('5.30 PM - 6.00 PM'), findsOneWidget);
    expect(find.text('11.00 AM - 11.30 AM'), findsNothing);

    await tester.tap(find.text('Fri 13 Nov'));
    await tester.pump();
    expect(find.text('11.00 AM - 11.30 AM'), findsOneWidget);
    expect(find.text('5.30 PM - 6.00 PM'), findsOneWidget);

    await tester.tap(find.text('Sat 14 Nov'));
    await tester.pump();
    expect(find.text('4.30 PM - 5.00 PM'), findsOneWidget);
    expect(find.text('5.00 PM - 5.30 PM'), findsNothing);
  });

  testWidgets('meeting booking asks guests to sign in first', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    const testExhibitor = Exhibitor(
      id: 'test-company',
      name: 'Test Textiles',
      category: 'Materials',
      booth: 'A12',
      hall: 'Hall A',
      blurb: 'A test company profile.',
      tags: [],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: ExhibitorDetail.fromExhibitor(exhibitor: testExhibitor),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Book a meeting slot'));
    await tester.pumpAndSettle();

    expect(find.text('TIExpo 2026'), findsOneWidget);
    expect(find.text('Sign In to Dashboard'), findsOneWidget);
    expect(find.text('Meet Test Textiles'), findsNothing);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Book a meeting slot'), findsOneWidget);
  });

  testWidgets('exhibitor profile shows up to two products, videos, and news', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const testExhibitor = Exhibitor(
      id: 'limited-company',
      name: 'Limited Textiles',
      category: 'Materials',
      booth: 'A12',
      hall: 'Hall A',
      blurb: 'Company profile text.',
      tags: ['fibers'],
      products: ['Product One', 'Product Two', 'Product Three'],
      videoUrls: [
        'https://example.com/video-one',
        'https://example.com/video-two',
        'https://example.com/video-three',
      ],
      news: [
        CompanyNews(title: 'News One'),
        CompanyNews(title: 'News Two'),
        CompanyNews(title: 'News Three'),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ExhibitorDetail.fromExhibitor(exhibitor: testExhibitor),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Innovation story'), findsOneWidget);
    expect(find.text('About the company'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Innovation story')).dy,
      lessThan(tester.getTopLeft(find.text('About the company')).dy),
    );
    expect(find.text('Product One'), findsOneWidget);
    expect(find.text('Product Two'), findsOneWidget);
    expect(find.text('Product Three'), findsNothing);
    expect(find.text('Company video 1'), findsOneWidget);
    expect(find.text('Company video 2'), findsOneWidget);
    expect(find.text('Company video 3'), findsNothing);
    await tester.ensureVisible(find.text('News One'));
    expect(find.text('News One'), findsOneWidget);
    expect(find.text('News Two'), findsOneWidget);
    expect(find.text('News Three'), findsNothing);
  });

  testWidgets('alternate meeting request requires a time and query', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'auth_token': 'test-token',
      'auth_user_id': '1',
    });
    const testExhibitor = Exhibitor(
      id: 'test-company',
      name: 'Test Textiles',
      category: 'Materials',
      booth: 'A12',
      hall: 'Hall A',
      blurb: 'A test company profile.',
      tags: [],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: ExhibitorDetail.fromExhibitor(exhibitor: testExhibitor),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Book a meeting slot'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('No suitable slot? Request another time'));
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Prepare slot request'),
          )
          .onPressed,
      isNull,
    );

    await tester.enterText(
      find.byKey(const ValueKey('requested-meeting-time')),
      '4:30 PM',
    );
    await tester.enterText(
      find.byKey(const ValueKey('meeting-query')),
      'Discuss recycled fiber sourcing',
    );
    await tester.pump();
    await tester.ensureVisible(find.text('Prepare slot request'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Prepare slot request'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Request prepared for Test Textiles: Thu 12 Nov, 4:30 PM; query: Discuss recycled fiber sourcing. Confirm availability with the exhibitor.',
      ),
      findsOneWidget,
    );
  });
}
