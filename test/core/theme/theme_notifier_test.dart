import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/core/theme/theme_notifier.dart';

void main() {
  group('ThemeNotifier', () {
    test('initial theme is set correctly', () {
      final initialTheme = ThemeData.light();
      final themeNotifier = ThemeNotifier(initialTheme);
      expect(themeNotifier.currentTheme, initialTheme);
    });

    test('setTheme updates the theme and notifies listeners', () {
      final initialTheme = ThemeData.light();
      final themeNotifier = ThemeNotifier(initialTheme);
      var listenerCalled = false;
      themeNotifier.addListener(() {
        listenerCalled = true;
      });

      final newTheme = ThemeData.dark();
      themeNotifier.setTheme(newTheme);

      expect(themeNotifier.currentTheme, newTheme);
      expect(listenerCalled, isTrue);
    });
  });
}
