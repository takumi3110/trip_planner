import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/core/theme/theme_notifier.dart';
import 'package:trip_planner/features/settings/view/settings_screen.dart';

void main() {
  group('SettingsScreen', () {
    testWidgets('displays settings title', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ThemeNotifier(ThemeData.light()),
          child: const MaterialApp(home: SettingsScreen()),
        ),
      );

      expect(find.text('設定'), findsOneWidget);
    });

    testWidgets('displays theme color option', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ThemeNotifier(ThemeData.light()),
          child: const MaterialApp(home: SettingsScreen()),
        ),
      );

      expect(find.text('テーマカラー'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
    });

    testWidgets('tapping theme color option shows dialog', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ThemeNotifier(ThemeData.light()),
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
        ChangeNotifierProvider.value(
          value: themeNotifier,
          child: const MaterialApp(home: SettingsScreen()),
        ),
      );

      await tester.tap(find.text('テーマカラー'));
      await tester.pumpAndSettle();

      final initialTheme = themeNotifier.currentTheme;

      await tester.tap(find.text('ピンク'));
      await tester.pumpAndSettle();

      expect(themeNotifier.currentTheme, isNot(initialTheme));
      // Color型同士で比較するように修正
      expect(
        themeNotifier.currentTheme.colorScheme.primary.value,
        ColorScheme.fromSeed(seedColor: Colors.pink).primary.value,
      );
    });
  });
}
