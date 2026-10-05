import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "screens/about.dart";
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

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(onOpenAgenda: () => setState(() => index = 2)),
      const VisitorRegistrationScreen(),
      const MeetScreen(),
      const AboutScreen(),
    ];

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: index, children: pages),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'login_btn',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        },
        backgroundColor: brandPurple,
        icon: const Icon(Icons.login_rounded, color: Colors.white, size: 18),
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
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: "Home",
            ),
            NavigationDestination(
              icon: Icon(Icons.person_add_alt_1_outlined),
              selectedIcon: Icon(Icons.person_add_alt_1),
              label: "Register",
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
