import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "screens/agenda.dart";
import "screens/exhibitors.dart";
import "screens/home.dart";
import "screens/map.dart";
import "screens/speakers.dart";
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: "Home"),
          NavigationDestination(icon: Icon(Icons.calendar_today_outlined), selectedIcon: Icon(Icons.calendar_today), label: "Agenda"),
          NavigationDestination(icon: Icon(Icons.apartment_outlined), selectedIcon: Icon(Icons.apartment), label: "Halls"),
          NavigationDestination(icon: Icon(Icons.groups_outlined), selectedIcon: Icon(Icons.groups), label: "Voices"),
          NavigationDestination(icon: Icon(Icons.map_outlined), selectedIcon: Icon(Icons.map), label: "Map"),
        ],
      ),
    );
  }
}
