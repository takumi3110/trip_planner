import 'package:flutter/material.dart';
import 'package:trip_planner/core/routing/app_router.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/data/repositories/trip_repository.dart';
import 'package:trip_planner/data/sources/mock_trip_data_source.dart';
import 'package:trip_planner/core/theme/theme_notifier.dart'; // 追加

void main() {
  runApp(
    MultiProvider(
      // MultiProviderに変更
      providers: [
        Provider<TripRepository>(
          create: (_) => MockTripDataSource(), // MockDataSourceを提供
        ),
        ChangeNotifierProvider<ThemeNotifier>(
          // ThemeNotifierを追加
          create:
              (context) => ThemeNotifier(
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
                  cardTheme: CardThemeData(
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
              ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Trip Planner',
      theme:
          context.watch<ThemeNotifier>().currentTheme, // ThemeNotifierからテーマを取得
      routerConfig: appRouter,
    );
  }
}
