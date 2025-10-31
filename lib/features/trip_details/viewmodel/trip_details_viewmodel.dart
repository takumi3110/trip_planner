import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'; // riverpodのインポートを追加
import 'package:trip_planner/data/models/trip.dart';
import 'package:trip_planner/data/repositories/trip_repository.dart';
import 'package:trip_planner/data/sources/mock_trip_data_source.dart'; // MockTripDataSourceのインポートを追加

class TripDetailsViewModel extends ChangeNotifier {
  final String tripId;
  final TripRepository tripRepository;

  Trip? _trip;
  bool _isLoading = false;

  TripDetailsViewModel({required this.tripId, required this.tripRepository});

  Trip? get trip => _trip;
  bool get isLoading => _isLoading;

  Future<void> loadTripDetails() async {
    _isLoading = true;
    notifyListeners();

    try {
      _trip = await tripRepository.getTrip(tripId);
    } catch (e) {
      // エラーハンドリング
      debugPrint('Error loading trip details: $e');
      _trip = null; // エラー時はnullにするか、エラー状態を保持する
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

// TripDetailsViewModelのプロバイダを定義 (tripIdを引数に取るFamilyプロバイダ)

