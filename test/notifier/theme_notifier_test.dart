import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adam_s_application/notifier/theme_notifier.dart';

void main() {
  test('ThemeNotifier loads persisted preference from SharedPreferences',
      () async {
    // Arrange: set persisted value to light
    SharedPreferences.setMockInitialValues({'isDarkMode': false});

    final container = ProviderContainer();
    addTearDown(container.dispose);

    // Give the notifier time to perform its async load scheduled via
    // Future.microtask in build(). Poll until the provider reflects the
    // persisted value or timeout to avoid flakiness on CI machines.
    ThemeMode? observed;
    const maxAttempts = 20;
    for (var i = 0; i < maxAttempts; i++) {
      observed = container.read(themeNotifierProvider);
      if (observed == ThemeMode.light) break;
      await Future.delayed(const Duration(milliseconds: 25));
    }

    // Assert that we eventually observed the persisted light mode
    expect(observed, equals(ThemeMode.light));
  });

  test('ThemeNotifier persists changes to SharedPreferences', () async {
    // Start with empty prefs
    SharedPreferences.setMockInitialValues({});

    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(themeNotifierProvider.notifier);

    // Act: set dark mode and wait for persistence microtask
    notifier.setMode(ThemeMode.dark);
    await Future.delayed(const Duration(milliseconds: 50));

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('isDarkMode'), isTrue);
  });
}
