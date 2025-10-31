import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trip_planner/data/models/trip.dart';
import 'package:trip_planner/providers/isar_provider.dart';

final allTripsProvider = FutureProvider<List<Trip>>((ref) async{
  final isarService = ref.watch(isarServiceProvider);
  return await isarService.getAllTrips();
});

final todayTripsProvider = FutureProvider<Trip?>((ref) async {
  final isarService = ref.watch(isarServiceProvider);
  return await isarService.getTodayTrip();
});

final upcomingTripsProvider = FutureProvider<List<Trip>>((ref) async {
  final isarService = ref.watch(isarServiceProvider);
  return await isarService.getUpcomingTrips();
});

final pastTripsProvider = FutureProvider<List<Trip>>((ref) async {
  final isarService = ref.watch(isarServiceProvider);
  return await isarService.getPastTrips();
});

final tripByIdProvider = FutureProvider.family<Trip?, int>((ref, tripId) async {
  final isarService = ref.watch(isarServiceProvider);
  return await isarService.getTripById(tripId);
});