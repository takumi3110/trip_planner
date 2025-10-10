import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/data/models/trip.dart';
import 'package:trip_planner/data/sources/mock_trip_data_source.dart';

void main() {
  group('MockTripDataSource', () {
    late MockTripDataSource dataSource;

    setUp(() {
      dataSource = MockTripDataSource();
    });

    test('getAllTrips should return a list of trips', () async {
      final trips = await dataSource.getAllTrips();
      expect(trips, isA<List<Trip>>());
      expect(trips.isNotEmpty, isTrue);
    });

    test('getTrip should return a single trip', () async {
      final trip = await dataSource.getTrip('some_id');
      expect(trip, isA<Trip>());
      expect(trip.destination, '沖縄');
    });

    test('saveTrip should add a trip to the list', () async {
      final initialTrips = await dataSource.getAllTrips();
      final initialLength = initialTrips.length;

      final newTrip = Trip(
        destination: '北海道',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 3)),
        itineraries: [],
      );

      await dataSource.saveTrip(newTrip);

      final finalTrips = await dataSource.getAllTrips();
      expect(finalTrips.length, initialLength + 1);
      expect(finalTrips.last.destination, '北海道');
    });
  });
}
