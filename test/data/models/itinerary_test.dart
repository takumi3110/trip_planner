import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/data/models/activity.dart';
import 'package:trip_planner/data/models/itinerary.dart';

void main() {
  group('Itinerary', () {
    test('should create an instance with correct properties', () {
      final date = DateTime.now();
      final activities = [
        Activity(name: 'Activity 1', location: 'Location 1', startTime: date),
        Activity(
          name: 'Activity 2',
          location: 'Location 2',
          startTime: date.add(const Duration(hours: 2)),
        ),
      ];

      final itinerary = Itinerary(date: date, activities: activities);

      expect(itinerary.date, date);
      expect(itinerary.activities, activities);
      expect(itinerary.activities.length, 2);
    });
  });
}
