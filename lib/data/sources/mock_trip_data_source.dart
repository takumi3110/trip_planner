import '../models/trip.dart';
import '../repositories/trip_repository.dart';

class MockTripDataSource implements TripRepository {
  final List<Trip> _trips = [
    Trip(
      destination: '沖縄',
      title: '沖縄旅行',
      startDate: DateTime(2025, 11, 10),
      endDate: DateTime(2025, 11, 13),
      numberOfPeople: 2,
    ),
  ];

  @override
  Future<Trip> getTrip(String id) async {
    // For now, just return the first trip.
    await Future.delayed(const Duration(seconds: 1));
    return _trips.first;
  }

  @override
  Future<void> saveTrip(Trip trip) async {
    await Future.delayed(const Duration(seconds: 1));
    _trips.add(trip);
  }

  @override
  Future<List<Trip>> getAllTrips() async {
    await Future.delayed(const Duration(seconds: 1));
    return _trips;
  }
}
