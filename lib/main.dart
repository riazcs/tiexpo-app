import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "screens/agenda.dart";
import "screens/exhibitors.dart";
import "screens/home.dart";
import "screens/login.dart";
import "screens/map.dart";
import "screens/speakers.dart";
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
      HomeScreen(onOpenAgenda: () => setState(() => index = 1)),
      const AgendaScreen(),
      const ExhibitorsScreen(),
      const SpeakersScreen(),
      const MapScreen(),
    ];

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: index, children: pages),
      ),
      // Modern floating action bar for quick access to Register and Sign In
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'register_btn',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VisitorRegistrationScreen(),
                ),
              );
            },
            backgroundColor: const Color(0xFF7E22CE),
            icon: const Icon(
              Icons.person_add_alt_1,
              color: Colors.white,
              size: 18,
            ),
            label: const Text(
              "Register",
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
          const SizedBox(width: 10),
          FloatingActionButton.extended(
            heroTag: 'login_btn',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            backgroundColor: const Color(0xFF0F172A),
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
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(gradient: appBackgroundGradient),
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
              icon: Icon(Icons.calendar_today_outlined),
              selectedIcon: Icon(Icons.calendar_today),
              label: "Agenda",
            ),
            NavigationDestination(
              icon: Icon(Icons.apartment_outlined),
              selectedIcon: Icon(Icons.apartment),
              label: "Halls",
            ),
            NavigationDestination(
              icon: Icon(Icons.groups_outlined),
              selectedIcon: Icon(Icons.groups),
              label: "Voices",
            ),
            NavigationDestination(
              icon: Icon(Icons.map_outlined),
              selectedIcon: Icon(Icons.map),
              label: "Map",
            ),
          ],
        ),
      ),
    );
  }
}
