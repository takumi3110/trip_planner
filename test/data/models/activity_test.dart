import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/data/models/activity.dart';

void main() {
  group('Activity', () {
    test('should create an instance with correct properties', () {
      final startTime = DateTime.now();
      final endTime = startTime.add(const Duration(hours: 1));
      const name = 'Test Activity';
      const location = 'Test Location';
      const description = 'Test Description';

      final activity = Activity(
        name: name,
        location: location,
        startTime: startTime,
        endTime: endTime,
        description: description,
      );

      expect(activity.name, name);
      expect(activity.location, location);
      expect(activity.startTime, startTime);
      expect(activity.endTime, endTime);
      expect(activity.description, description);
    });
  });
}
