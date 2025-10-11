import 'package:flutter/material.dart';
import 'package:trip_planner/core/routing/app_router.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/data/repositories/trip_repository.dart';
import 'package:trip_planner/data/sources/mock_trip_data_source.dart';
import 'package:google_fonts/google_fonts.dart';
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
                    seedColor: const Color(0xFF87CEFA), // ユーザー指定の淡いブルー
                    brightness: Brightness.light,
                  ),
                  textTheme: GoogleFonts.caveatTextTheme(
                    // 手書き風フォントを適用
                    Theme.of(context).textTheme,
                  ),
                  useMaterial3: true, // Material 3を有効にする
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
