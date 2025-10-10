import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/features/create_trip/view/create_trip_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        // For now, show the create trip screen
        return const CreateTripScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'trip/create',
          builder: (BuildContext context, GoRouterState state) {
            return const CreateTripScreen();
          },
        ),
      ],
    ),
  ],
);
