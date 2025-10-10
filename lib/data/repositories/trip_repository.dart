import '../models/trip.dart';

abstract class TripRepository {
  Future<Trip> getTrip(String id);
  Future<void> saveTrip(Trip trip);
  Future<List<Trip>> getAllTrips();
}
