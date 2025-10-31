import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/data/models/itinerary.dart';

void main() {
  group('Itinerary', () {
    test('should create an instance with correct properties', () {
      final date = DateTime.now();

      final itinerary = Itinerary(date: date);

      expect(itinerary.date, date);
      expect(itinerary.activities, isNotNull);
      expect(itinerary.activities.isEmpty, isTrue);
    });
  });
}
