import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trip_planner/core/theme/theme_notifier.dart';
import 'package:trip_planner/features/settings/view/settings_screen.dart';

void main() {
  group('SettingsScreen', () {
    testWidgets('displays settings title', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            themeNotifierProvider.overrideWith(
              (ref) => ThemeNotifier(ThemeData.light()),
            ),
          ],
          child: const MaterialApp(home: SettingsScreen()),
        ),
      );

      expect(find.text('設定'), findsOneWidget);
    });

    testWidgets('displays theme color option', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            themeNotifierProvider.overrideWith(
              (ref) => ThemeNotifier(ThemeData.light()),
            ),
          ],
          child: const MaterialApp(home: SettingsScreen()),
        ),
      );

      expect(find.text('テーマカラー'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
    });

    testWidgets('tapping theme color option shows dialog', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            themeNotifierProvider.overrideWith(
              (ref) => ThemeNotifier(ThemeData.light()),
            ),
          ],
          child: const MaterialApp(home: SettingsScreen()),
        ),
      );

      await tester.tap(find.text('テーマカラー'));
      await tester.pumpAndSettle();

      expect(find.text('テーマカラーを選択'), findsOneWidget);
      expect(find.text('ライトブルー'), findsOneWidget);
      expect(find.text('ピンク'), findsOneWidget);
      expect(find.text('グリーン'), findsOneWidget);
      expect(find.text('パープル'), findsOneWidget);
      expect(find.text('キャンセル'), findsOneWidget);
    });

    testWidgets('tapping a theme color option changes theme', (tester) async {
      final themeNotifier = ThemeNotifier(ThemeData.light());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            themeNotifierProvider.overrideWith(
              (ref) => themeNotifier,
            ),
          ],
          child: const MaterialApp(home: SettingsScreen()),
        ),
      );

      await tester.tap(find.text('テーマカラー'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('ピンク'));
      await tester.pumpAndSettle();

      // Color型同士で比較するように修正
      expect(
        themeNotifier.currentTheme.colorScheme.primary,
        Colors.pink,
      );
    });

    testWidgets('tapping a mint green theme color option changes theme', (tester) async {
      final themeNotifier = ThemeNotifier(ThemeData.light());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            themeNotifierProvider.overrideWith(
              (ref) => themeNotifier,
            ),
          ],
          child: const MaterialApp(home: SettingsScreen()),
        ),
      );

      await tester.tap(find.text('テーマカラー'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('ミントグリーン'));
      await tester.pumpAndSettle();

      expect(
        themeNotifier.currentTheme.colorScheme.primary,
        Colors.teal.shade100,
      );
    });

    testWidgets('tapping a lavender theme color option changes theme', (tester) async {
      final themeNotifier = ThemeNotifier(ThemeData.light());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            themeNotifierProvider.overrideWith(
              (ref) => themeNotifier,
            ),
          ],
          child: const MaterialApp(home: SettingsScreen()),
        ),
      );

      await tester.tap(find.text('テーマカラー'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('ラベンダー'));
      await tester.pumpAndSettle();

      expect(
        themeNotifier.currentTheme.colorScheme.primary,
        Colors.deepPurple.shade100,
      );
    });

    testWidgets('tapping a coral pink theme color option changes theme', (tester) async {
      final themeNotifier = ThemeNotifier(ThemeData.light());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            themeNotifierProvider.overrideWith(
              (ref) => themeNotifier,
            ),
          ],
          child: const MaterialApp(home: SettingsScreen()),
        ),
      );

      await tester.tap(find.text('テーマカラー'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('コーラルピンク'));
      await tester.pumpAndSettle();

      expect(
        themeNotifier.currentTheme.colorScheme.primary,
        Colors.deepOrange.shade100,
      );
    });

    testWidgets('tapping a beige theme color option changes theme', (tester) async {
      final themeNotifier = ThemeNotifier(ThemeData.light());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            themeNotifierProvider.overrideWith(
              (ref) => themeNotifier,
            ),
          ],
          child: const MaterialApp(home: SettingsScreen()),
        ),
      );

      await tester.tap(find.text('テーマカラー'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('ベージュ'));
      await tester.pumpAndSettle();

      expect(
        themeNotifier.currentTheme.colorScheme.primary,
        Colors.amber.shade100,
      );
    });
  });
}
