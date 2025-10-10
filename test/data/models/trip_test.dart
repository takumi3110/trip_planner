import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/data/models/activity.dart';
import 'package:trip_planner/data/models/itinerary.dart';
import 'package:trip_planner/data/models/trip.dart';

void main() {
  group('Trip', () {
    test('should create an instance with correct properties', () {
      final startDate = DateTime.now();
      final endDate = startDate.add(const Duration(days: 2));
      const destination = 'Test Destination';
      final itineraries = [
        Itinerary(
          date: startDate,
          activities: [
            Activity(
              name: 'Activity 1',
              location: 'Location 1',
              startTime: startDate,
            ),
          ],
        ),
      ];

      final trip = Trip(
        destination: destination,
        startDate: startDate,
        endDate: endDate,
        itineraries: itineraries,
      );

      expect(trip.destination, destination);
      expect(trip.startDate, startDate);
      expect(trip.endDate, endDate);
      expect(trip.itineraries, itineraries);
      expect(trip.itineraries.length, 1);
    });
  });
}
