import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The color themes the user can pick on the Settings screen.
enum ThemeSeed {
  purple('Purple', Color(0xFF6750A4)),
  teal('Teal', Color(0xFF009688)),
  orange('Orange', Color(0xFFF57C00)),
  blue('Blue', Color(0xFF1E66F5));

  const ThemeSeed(this.label, this.color);

  final String label;
  final Color color;
}

/// Holds dark mode + color theme and saves them on the device.
class ThemeController extends ChangeNotifier {
  static const _darkKey = 'dark_mode';
  static const _seedKey = 'theme_seed';

  bool _isDark = false;
  ThemeSeed _seed = ThemeSeed.purple;

  bool get isDark => _isDark;
  ThemeSeed get seed => _seed;
  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDark = prefs.getBool(_darkKey) ?? false;
      final saved = prefs.getString(_seedKey);
      _seed = ThemeSeed.values.firstWhere(
        (s) => s.name == saved,
        orElse: () => ThemeSeed.purple,
      );
    } catch (_) {
      // If storage is unavailable, keep the defaults.
    }
    notifyListeners();
  }

  Future<void> setDark(bool value) async {
    if (_isDark == value) return;
    _isDark = value;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_darkKey, value);
    } catch (_) {
      // Saving is best-effort; the choice still applies for this session.
    }
  }

  Future<void> setSeed(ThemeSeed value) async {
    if (_seed == value) return;
    _seed = value;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_seedKey, value.name);
    } catch (_) {
      // Saving is best-effort; the choice still applies for this session.
    }
  }
}

/// Makes the [ThemeController] reachable from any widget.
class ThemeScope extends InheritedNotifier<ThemeController> {
  const ThemeScope({
    super.key,
    required ThemeController controller,
    required super.child,
  }) : super(notifier: controller);

  static ThemeController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ThemeScope>();
    assert(scope != null, 'No ThemeScope found in context');
    return scope!.notifier!;
  }
}
