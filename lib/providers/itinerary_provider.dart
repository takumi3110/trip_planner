import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trip_planner/providers/isar_provider.dart';

final allItineraryProvider = FutureProvider((ref) async {
  final isarService = ref.watch(isarServiceProvider);
  return await isarService.getAllItinerary();
});