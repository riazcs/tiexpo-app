import "package:flutter/material.dart";
import "package:flutter/foundation.dart";
import "package:webview_flutter/webview_flutter.dart";
import "package:webview_flutter_android/webview_flutter_android.dart";
import "package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart";

import "../theme.dart";

Future<String?> showVisitorRecaptchaChallenge(
  BuildContext context, {
  required String siteKey,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _VisitorRecaptchaSheet(siteKey: siteKey),
  );
}

class _VisitorRecaptchaSheet extends StatefulWidget {
  const _VisitorRecaptchaSheet({required this.siteKey});

  final String siteKey;

  @override
  State<_VisitorRecaptchaSheet> createState() => _VisitorRecaptchaSheetState();
}

class _VisitorRecaptchaSheetState extends State<_VisitorRecaptchaSheet> {
  WebViewController? _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (WebViewPlatform.instance == null) {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          AndroidWebViewPlatform.registerWith();
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          WebKitWebViewPlatform.registerWith();
        default:
          _error = "The security check is not supported on this platform.";
          return;
      }
    }
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..addJavaScriptChannel(
        "VisitorRecaptcha",
        onMessageReceived: _onRecaptchaMessage,
      )
      ..loadHtmlString(
        _challengeHtml,
        baseUrl: "https://textileinnovationexpo.com",
      );
  }

  String get _challengeHtml =>
      '''
<!doctype html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    html, body { margin: 0; padding: 0; background: #ffffff; }
    #captcha { display: flex; justify-content: center; }
  </style>
  <script>
    function onRecaptchaLoaded() {
      try {
        const widget = grecaptcha.render('captcha', {
          sitekey: '${widget.siteKey}',
          size: 'invisible',
          callback: function(token) {
            VisitorRecaptcha.postMessage(token);
          },
          'expired-callback': function() {
            VisitorRecaptcha.postMessage('expired');
          },
          'error-callback': function() {
            VisitorRecaptcha.postMessage('error');
          }
        });
        grecaptcha.execute(widget);
      } catch (error) {
        VisitorRecaptcha.postMessage('error');
      }
    }
  </script>
  <script src="https://www.google.com/recaptcha/api.js?onload=onRecaptchaLoaded&render=explicit" async defer></script>
</head>
<body><div id="captcha"></div></body>
</html>
''';

  void _onRecaptchaMessage(JavaScriptMessage message) {
    if (!mounted) return;
    final token = message.message;
    if (token == "error" || token == "expired" || token.isEmpty) {
      setState(() {
        _error = token == "expired"
            ? "The security check expired. Please retry."
            : "Could not complete the security check. Please retry.";
      });
      return;
    }
    Navigator.of(context).pop(token);
  }

  Future<void> _retry() async {
    final controller = _controller;
    if (controller == null) return;
    setState(() => _error = null);
    await controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return Container(
      height: height * 0.72,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 38,
            height: 4,
            decoration: BoxDecoration(
              color: brandBorder,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 12, 8),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    "Security check",
                    style: TextStyle(
                      color: brandInk,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: "Close security check",
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Complete the Google reCAPTCHA check to submit your visitor registration.",
              style: TextStyle(color: brandMuted, fontSize: 13, height: 1.4),
            ),
          ),
          const SizedBox(height: 14),
          if (_error != null)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: brandPurple,
                        size: 36,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: brandInk),
                      ),
                      const SizedBox(height: 10),
                      if (_controller != null)
                        FilledButton(
                          onPressed: _retry,
                          style: FilledButton.styleFrom(
                            backgroundColor: brandPurple,
                          ),
                          child: const Text("Retry"),
                        )
                      else
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Close"),
                        ),
                    ],
                  ),
                ),
              ),
            )
          else if (_controller != null)
            Expanded(child: WebViewWidget(controller: _controller!)),
        ],
      ),
    );
  }
}
