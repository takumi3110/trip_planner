import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/features/create_trip/view/create_trip_detail_screen.dart';
import 'package:trip_planner/features/create_trip/view/create_trip_screen.dart';
import 'package:trip_planner/features/home_screen.dart';
import 'package:trip_planner/features/trip_details/view/trip_details_screen.dart';
import 'package:trip_planner/features/settings/view/settings_screen.dart'; // 追加

final GoRouter appRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        // For now, show the create trip screen
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'trip/create',
          builder: (BuildContext context, GoRouterState state) {
            return const CreateTripScreen();
          },
        ),
        GoRoute(
            path: 'trip/:tripId/create/detail',
          builder: (BuildContext context, GoRouterState state) {
              final int tripId = int.parse(state.pathParameters['tripId']!);
              return CreateTripDetail(tripId: tripId);
          }
        ),
        GoRoute(
          path: 'trip/:id',
          builder: (BuildContext context, GoRouterState state) {
            final String tripId = state.pathParameters['id']!;
            return TripDetailsScreen(tripId: tripId);
          },
        ),
        GoRoute(
          // 追加
          path: 'settings',
          builder: (BuildContext context, GoRouterState state) {
            return const SettingsScreen();
          },
        ),
      ],
    ),
  ],
);
