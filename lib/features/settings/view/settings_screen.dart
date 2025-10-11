import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/core/theme/theme_notifier.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('テーマカラー'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              _showThemeColorPickerDialog(context);
            },
          ),
          // 他の設定項目を追加
        ],
      ),
    );
  }

  void _showThemeColorPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('テーマカラーを選択'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildThemeColorOption(
                  dialogContext,
                  'ライトブルー',
                  Colors.lightBlue,
                ),
                _buildThemeColorOption(dialogContext, 'ピンク', Colors.pink),
                _buildThemeColorOption(dialogContext, 'グリーン', Colors.green),
                _buildThemeColorOption(dialogContext, 'パープル', Colors.purple),
                // 他のテーマカラーオプションを追加
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
  ) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(backgroundColor: seedColor),
      onTap: () {
        final newTheme = ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: seedColor,
            brightness: Brightness.light,
          ),
          textTheme: GoogleFonts.caveatTextTheme(Theme.of(context).textTheme),
          useMaterial3: true,
        );
        Provider.of<ThemeNotifier>(context, listen: false).setTheme(newTheme);
        Navigator.of(context).pop(); // ダイアログを閉じる
      },
    );
  }
}
