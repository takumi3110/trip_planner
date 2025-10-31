import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'; // riverpodのインポートを追加

class ThemeNotifier extends ChangeNotifier {
  ThemeData _currentTheme;

  ThemeNotifier(this._currentTheme);

  ThemeData get currentTheme => _currentTheme;

  void setTheme(ThemeData theme) {
    _currentTheme = theme;
    notifyListeners();
  }
}

// ThemeNotifierのプロバイダを定義
final themeNotifierProvider = ChangeNotifierProvider<ThemeNotifier>((ref) {
  return ThemeNotifier(
    ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFB3E5FC), // 淡いパステル調の薄い青
        brightness: Brightness.light,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(fontFamily: 'YasashisaGothicBold', fontSize: 57.0, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontFamily: 'YasashisaGothicBold', fontSize: 22.0, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(fontFamily: 'YasashisaGothicBold', fontSize: 16.0, height: 1.5),
        bodyMedium: TextStyle(fontFamily: 'YasashisaGothicBold', fontSize: 14.0, height: 1.4),
        labelSmall: TextStyle(fontFamily: 'YasashisaGothicBold', fontSize: 11.0, color: Colors.grey),
      ),
      useMaterial3: true, // Material 3を有効にする
      scaffoldBackgroundColor: Colors.white, // 背景色を白に設定
      cardTheme: CardThemeData( // constを追加
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // カードの角を丸くする
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // ボタンの角を丸くする
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0), // 入力フィールドの角を丸くする
        ),
      ),
      iconTheme: const IconThemeData(
        color: Colors.grey,
        size: 24.0,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white, // AppBarの背景色を白に設定
        elevation: 0, // AppBarの影をなくす
        foregroundColor: Colors.black, // AppBarのアイコンやタイトルの色を黒に設定
      ),
    ),
  );
});
