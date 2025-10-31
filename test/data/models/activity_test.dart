import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/data/models/activity.dart';

void main() {
  group('Activity', () {
    test('should create an instance with correct properties', () {
      const name = 'Test Activity';
      const location = 'Test Location';
      const description = 'Test Description';
      final arrivalTime = DateTime(2025, 1, 1, 10, 0);
      final departureTime = DateTime(2025, 1, 1, 11, 0);
      const moved = '徒歩';
      const timeInMinutes = 60;

      final activity = Activity(
        name: name,
        location: location,
        description: description,
        timeInMinutes: timeInMinutes,
        arrivalTime: arrivalTime,
        departureTime: departureTime,
        moved: moved,
      );

      expect(activity.name, name);
      expect(activity.location, location);
      expect(activity.description, description);
      expect(activity.arrivalTime, arrivalTime);
      expect(activity.departureTime, departureTime);
      expect(activity.moved, moved);
      expect(activity.timeInMinutes, timeInMinutes);
    });
  });
}
