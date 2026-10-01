import "package:flutter/foundation.dart";
import "package:shared_preferences/shared_preferences.dart";

class AgendaStore extends ChangeNotifier {
  AgendaStore._();
  static final AgendaStore instance = AgendaStore._();

  static const _key = "tiexpo-agenda";
  final Set<String> _ids = {};

  Set<String> get ids => Set.unmodifiable(_ids);
  int get count => _ids.length;
  bool has(String id) => _ids.contains(id);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _ids
      ..clear()
      ..addAll(prefs.getStringList(_key) ?? const []);
    notifyListeners();
  }

  Future<void> toggle(String id) async {
    if (!_ids.remove(id)) _ids.add(id);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, _ids.toList());
  }
}
