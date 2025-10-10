import 'package:flutter/material.dart';
import 'package:trip_planner/data/models/trip.dart';
import 'package:trip_planner/data/repositories/trip_repository.dart';

class TripDetailsViewModel extends ChangeNotifier {
  TripDetailsViewModel({required this.tripRepository, required this.tripId});

  final TripRepository tripRepository;
  final String tripId;

  Trip? _trip;
  Trip? get trip => _trip;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchTripDetails() async {
    _isLoading = true;
    notifyListeners();
    try {
      _trip = await tripRepository.getTrip(tripId);
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
