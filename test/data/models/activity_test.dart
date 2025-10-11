import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/data/models/activity.dart';
import 'package:flutter/material.dart';

void main() {
  group('Activity', () {
    test('should create an instance with correct properties', () {
      const name = 'Test Activity';
      const location = 'Test Location';
      const description = 'Test Description';
      const time = TimeOfDay(hour: 10, minute: 0);

      final activity = Activity(
        name: name,
        location: location,
        description: description,
        time: time,
      );

      expect(activity.name, name);
      expect(activity.location, location);
      expect(activity.description, description);
      expect(activity.time, time);
    });
  });
}
