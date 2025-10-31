import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trip_planner/service/isar_service.dart';

final isarServiceProvider = Provider<IsarService>((ref) {
  final service = IsarService();
  ref.onDispose(() => service.close());
  return service;
});