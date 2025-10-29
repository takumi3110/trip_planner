import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/core/theme/theme_notifier.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: Consumer<ThemeNotifier>(
        // Consumerでラップ
        builder: (context, themeNotifier, child) {
          return ListView(
            children: [
              ListTile(
                title: const Text('テーマカラー'),
                trailing: Row(
                  // 現在のテーマカラーを表示
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          themeNotifier.currentTheme.colorScheme.primary,
                      radius: 12,
                      child: Icon(
                        Icons.check,
                        color: themeNotifier.currentTheme.colorScheme.onPrimary,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_ios),
                  ],
                ),
                onTap: () {
                  _showThemeColorPickerDialog(context);
                },
              ),
              // 他の設定項目を追加
            ],
          );
        },
      ),
    );
  }

  void _showThemeColorPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final currentThemeNotifier = Provider.of<ThemeNotifier>(dialogContext);
        return AlertDialog(
          title: const Text('テーマカラーを選択'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildThemeColorOption(
                  dialogContext,
                  'ライトブルー',
                  Colors.lightBlue,
                  currentThemeNotifier.currentTheme.colorScheme.primary
                          .toARGB32() ==
                      ColorScheme.fromSeed(
                        seedColor: Colors.lightBlue,
                      ).primary.toARGB32(),
                ),
                _buildThemeColorOption(
                  dialogContext,
                  'ピンク',
                  Colors.pink,
                  currentThemeNotifier.currentTheme.colorScheme.primary
                          .toARGB32() ==
                      ColorScheme.fromSeed(
                        seedColor: Colors.pink,
                      ).primary.toARGB32(),
                ),
                _buildThemeColorOption(
                  dialogContext,
                  'グリーン',
                  Colors.green,
                  currentThemeNotifier.currentTheme.colorScheme.primary
                          .toARGB32() ==
                      ColorScheme.fromSeed(
                        seedColor: Colors.green,
                      ).primary.toARGB32(),
                ),
                _buildThemeColorOption(
                  dialogContext,
                  'パープル',
                  Colors.purple,
                  currentThemeNotifier.currentTheme.colorScheme.primary
                          .toARGB32() ==
                      ColorScheme.fromSeed(
                        seedColor: Colors.purple,
                      ).primary.toARGB32(),
                ), // 他のテーマカラーオプションを追加
                _buildThemeColorOption(
                  dialogContext,
                  'ミントグリーン',
                  Colors.teal.shade100,
                  currentThemeNotifier.currentTheme.colorScheme.primary
                          .toARGB32() ==
                      ColorScheme.fromSeed(
                        seedColor: Colors.teal.shade100,
                      ).primary.toARGB32(),
                ),
                _buildThemeColorOption(
                  dialogContext,
                  'ラベンダー',
                  Colors.deepPurple.shade100,
                  currentThemeNotifier.currentTheme.colorScheme.primary
                          .toARGB32() ==
                      ColorScheme.fromSeed(
                        seedColor: Colors.deepPurple.shade100,
                      ).primary.toARGB32(),
                ),
                _buildThemeColorOption(
                  dialogContext,
                  'コーラルピンク',
                  Colors.deepOrange.shade100,
                  currentThemeNotifier.currentTheme.colorScheme.primary
                          .toARGB32() ==
                      ColorScheme.fromSeed(
                        seedColor: Colors.deepOrange.shade100,
                      ).primary.toARGB32(),
                ),
                _buildThemeColorOption(
                  dialogContext,
                  'ベージュ',
                  Colors.amber.shade100,
                  currentThemeNotifier.currentTheme.colorScheme.primary
                          .toARGB32() ==
                      ColorScheme.fromSeed(
                        seedColor: Colors.amber.shade100,
                      ).primary.toARGB32(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('キャンセル'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildThemeColorOption(
    BuildContext context,
    String title,
    Color seedColor,
    bool isSelected,
  ) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(backgroundColor: seedColor),
      trailing:
          isSelected ? const Icon(Icons.check) : null, // 選択されている場合にチェックマークを表示
      onTap: () {
        final newTheme = ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: seedColor,
            brightness: Brightness.light,
          ),
          textTheme: TextTheme(
            displayLarge: TextStyle(fontFamily: 'YasashisaGothicBold', fontSize: 57.0, fontWeight: FontWeight.bold),
            titleLarge: TextStyle(fontFamily: 'YasashisaGothicBold', fontSize: 22.0, fontWeight: FontWeight.bold),
            bodyLarge: TextStyle(fontFamily: 'YasashisaGothicBold', fontSize: 16.0, height: 1.5),
            bodyMedium: TextStyle(fontFamily: 'YasashisaGothicBold', fontSize: 14.0, height: 1.4),
            labelSmall: TextStyle(fontFamily: 'YasashisaGothicBold', fontSize: 11.0, color: Colors.grey),
          ),
          useMaterial3: true,
        );
        Provider.of<ThemeNotifier>(context, listen: false).setTheme(newTheme);
        Navigator.of(context).pop(); // ダイアログを閉じる
      },
    );
  }
}
