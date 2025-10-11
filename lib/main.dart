import 'package:flutter/material.dart';
import 'package:trip_planner/core/routing/app_router.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/data/repositories/trip_repository.dart';
import 'package:trip_planner/data/sources/mock_trip_data_source.dart';

void main() {
  runApp(
    Provider<TripRepository>(
      create: (_) => MockTripDataSource(), // MockDataSourceを提供
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routerConfig: appRouter,
    );
  }
}
