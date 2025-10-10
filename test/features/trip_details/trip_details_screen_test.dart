import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/data/sources/mock_trip_data_source.dart';
import 'package:trip_planner/features/trip_details/view/trip_details_screen.dart';

void main() {
  group('TripDetailsScreen', () {
    testWidgets('should display loading indicator and then trip details', (
      WidgetTester tester,
    ) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: TripDetailsScreen(
            tripId: '1',
            tripRepository: MockTripDataSource(),
          ),
        ),
      );

      // Initially, a loading indicator should be displayed.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Trigger a frame to simulate the completion of the future.
      await tester.pumpAndSettle();

      // Verify that the destination is displayed in the app bar.
      expect(find.text('沖縄'), findsOneWidget);

      // Verify that the itinerary date is displayed.
      expect(find.text('11月10日'), findsOneWidget);

      // Verify that the activity is displayed.
      expect(find.text('那覇空港到着'), findsOneWidget);
    });
  });
}
