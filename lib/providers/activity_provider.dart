import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trip_planner/data/models/activity.dart';
import 'package:trip_planner/providers/isar_provider.dart';
import 'package:trip_planner/service/isar_service.dart';

final allActivityProvider = FutureProvider((ref) async {
  final isarService = ref.watch(isarServiceProvider);
  return await isarService.getAllActivity();
});

final activityProvider = Provider((ref) {
  final isarService = ref.watch(isarServiceProvider);
  return ActivityService(isarService);
});

class ActivityService {
  final IsarService _isarService;

  ActivityService(this._isarService);

  Future<bool> saveActivity(Activity activity) async {
    return await _isarService.saveActivity(activity);
  }
}