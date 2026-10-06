import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:shared_preferences/shared_preferences.dart";

import "screens/about.dart";
import "screens/dashboard_profile_screen.dart";
import "screens/home.dart";
import "screens/login.dart";
import "screens/meet.dart";
import "screens/visitor_registration.dart";
import "store/agenda.dart";
import "theme.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AgendaStore.instance.load();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const TiexpoApp());
}

class TiexpoApp extends StatelessWidget {
  const TiexpoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TIExpo",
      debugShowCheckedModeBanner: false,
      theme: tiexpoTheme(),
      home: const Shell(),
    );
  }
}

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int index = 0;
  bool _isSignedIn = false;
  bool _isCheckingSession = true;

  @override
  void initState() {
    super.initState();
    _refreshSession();
  }

  Future<void> _refreshSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");
    if (mounted) {
      setState(() {
        _isSignedIn = token != null && token.isNotEmpty;
        _isCheckingSession = false;
      });
    }
  }

  Future<void> _openSignIn() async {
    await Navigator.of(
      context,
    ).push<void>(MaterialPageRoute<void>(builder: (_) => _buildLoginScreen()));
    await _refreshSession();
  }

  LoginScreen _buildLoginScreen() => LoginScreen(
    onLoginSuccess: _markSignedIn,
    onSignOut: _signOutFromLoginProfile,
  );

  void _markSignedIn() {
    if (mounted) setState(() => _isSignedIn = true);
  }

  void _signOutFromProfileTab(BuildContext profileContext) {
    setState(() => _isSignedIn = false);
    Navigator.of(
      profileContext,
    ).push<void>(MaterialPageRoute<void>(builder: (_) => _buildLoginScreen()));
  }

  void _signOutFromLoginProfile(BuildContext profileContext) {
    if (mounted) setState(() => _isSignedIn = false);
    Navigator.of(profileContext).pushReplacement<void, void>(
      MaterialPageRoute<void>(builder: (_) => _buildLoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(onOpenAgenda: () => setState(() => index = 2)),
      _isSignedIn
          ? DashboardProfileScreen(onSignOut: _signOutFromProfileTab)
          : const VisitorRegistrationScreen(),
      const MeetScreen(),
      const AboutScreen(),
    ];

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: index, children: pages),
      ),
      floatingActionButton: _isCheckingSession || _isSignedIn
          ? null
          : FloatingActionButton.extended(
              heroTag: 'login_btn',
              onPressed: _openSignIn,
              backgroundColor: brandPurple,
              icon: const Icon(
                Icons.login_rounded,
                color: Colors.white,
                size: 18,
              ),
              label: const Text(
                "Sign In",
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
      bottomNavigationBar: Container(
        color: paper,
        child: NavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedIndex: index,
          onDestinationSelected: (i) => setState(() => index = i),
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: "Home",
            ),
            NavigationDestination(
              icon: Icon(
                _isSignedIn
                    ? Icons.account_circle_outlined
                    : Icons.person_add_alt_1_outlined,
              ),
              selectedIcon: Icon(
                _isSignedIn ? Icons.account_circle : Icons.person_add_alt_1,
              ),
              label: _isSignedIn ? "Profile" : "Register",
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_today_outlined),
              selectedIcon: Icon(Icons.calendar_today),
              label: "Meets",
            ),
            NavigationDestination(
              icon: Icon(Icons.info_outline),
              selectedIcon: Icon(Icons.info),
              label: "About",
            ),
          ],
        ),
      ),
    );
  }
}
