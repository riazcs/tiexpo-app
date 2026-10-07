import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:tiexpo/widgets/visitor_recaptcha_challenge.dart";

void main() {
  testWidgets("unsupported platforms show an error instead of asserting", (
    tester,
  ) async {
    final previousPlatform = debugDefaultTargetPlatformOverride;
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    try {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () => showVisitorRecaptchaChallenge(
                    context,
                    siteKey: "test-site-key",
                  ),
                  child: const Text("Open CAPTCHA"),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text("Open CAPTCHA"));
      await tester.pumpAndSettle();

      expect(
        find.text("The security check is not supported on this platform."),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    } finally {
      debugDefaultTargetPlatformOverride = previousPlatform;
    }
  });
}
