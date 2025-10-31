import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/data/models/trip.dart';

void main() {
  group('Trip', () {
    test('should create an instance with correct properties', () {
      final startDate = DateTime.now();
      final endDate = startDate.add(const Duration(days: 2));
      const destination = 'Test Destination';
      const numberOfPeople = 2;

      final trip = Trip(
        title: 'test',
        destination: destination,
        startDate: startDate,
        endDate: endDate,
        numberOfPeople: numberOfPeople,
      );

      expect(trip.destination, destination);
      expect(trip.startDate, startDate);
      expect(trip.endDate, endDate);
      expect(trip.numberOfPeople, numberOfPeople);
      expect(trip.activities, isNotNull);
      expect(trip.activities.isEmpty, isTrue);
    });
  });
}
