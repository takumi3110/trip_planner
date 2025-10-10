import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/features/create_trip/view/create_trip_screen.dart';
import 'package:trip_planner/features/trip_details/view/trip_details_screen.dart';
import 'package:trip_planner/data/sources/mock_trip_data_source.dart';

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
        GoRoute(
          path: 'trip/:id',
          builder: (BuildContext context, GoRouterState state) {
            final String tripId = state.pathParameters['id']!;
            // In a real app, you would use a dependency injection solution.
            return TripDetailsScreen(
              tripId: tripId,
              tripRepository: MockTripDataSource(),
            );
          },
        ),
      ],
    ),
  ],
);
