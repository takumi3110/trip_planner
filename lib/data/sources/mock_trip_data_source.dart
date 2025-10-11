import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../models/itinerary.dart';
import '../models/trip.dart';
import '../repositories/trip_repository.dart';

class MockTripDataSource implements TripRepository {
  final List<Trip> _trips = [
    Trip(
      destination: '沖縄',
      startDate: DateTime(2025, 11, 10),
      endDate: DateTime(2025, 11, 13),
      numberOfPeople: 2,
      itineraries: [
        Itinerary(
          date: DateTime(2025, 11, 10),
          activities: [
            Activity(
              name: '那覇空港到着',
              location: '那覇空港',
              time: const TimeOfDay(hour: 10, minute: 0),
            ),
            Activity(
              name: '国際通りでランチ',
              location: '国際通り',
              time: const TimeOfDay(hour: 12, minute: 0),
              description: 'タコライスを食べる！',
            ),
          ],
        ),
      ],
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
