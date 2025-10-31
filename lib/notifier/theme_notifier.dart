import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider that holds the application's [ThemeMode].
/// Default is [ThemeMode.dark].
final themeNotifierProvider =
    NotifierProvider<ThemeNotifier, ThemeMode>(() => ThemeNotifier());

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    // Default to dark mode since the app's palette is dark by design.
    final initial = ThemeMode.dark;

    // Load persisted preference (if any) asynchronously and apply it.
    Future.microtask(() async {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getBool('isDarkMode');
      if (saved != null) {
        state = saved ? ThemeMode.dark : ThemeMode.light;
      }
    });

    return initial;
  }

  void toggle() {
    setMode(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }

  void setMode(ThemeMode mode) {
    state = mode;
    // Persist selection
    Future.microtask(() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', mode == ThemeMode.dark);
    });
  }
}
