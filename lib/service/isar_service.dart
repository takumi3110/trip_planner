import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trip_planner/data/models/activity.dart';
import 'package:trip_planner/data/models/itinerary.dart';
import 'package:trip_planner/data/models/trip.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      //   もしすでに開いているインスタンスがあれば、それを返す
      if (Isar.instanceNames.isNotEmpty) {
        return Future.value(Isar.getInstance());
      }

      return await Isar.open(
        [TripSchema, ActivitySchema],
        directory: dir.path,
        inspector: true,
      );
    } catch (e) {
      debugPrint('Isarデータベースのオープンに失敗しました。: $e');
      rethrow;
    }
  }

  // ===== データベースクローズ =====
  Future<void> close() async {
    try {
      final isarInstance = await db;
      await isarInstance.close();
    } catch (e) {
      debugPrint('Isarのクローズに失敗しました。: $e');
    }
  }

  //  ===== trip関連のメソッド =====
  //   全取得
  Future<List<Trip>> getAllTrips() async {
    try {
      final isar = await db;
      return await isar.collection<Trip>().where().findAll();
    } catch (error) {
      debugPrint('旅行日程取得に失敗しました。: $error');
      return [];
    }
  }

  // 当日の旅行を取得
  Future<Trip?> getTodayTrip() async {
    try {
      final isar = await db;
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      return await isar
          .collection<Trip>()
          .filter()
          .startDateEqualTo(today)
          .findFirst();
    } catch (error) {
      debugPrint('本日の旅行取得に失敗しました。: $error');
      return null;
    }
  }

  // 当日から始まってる旅行をのぞいて、先の日付の旅行を取得
  Future<List<Trip>> getUpcomingTrips() async {
    try {
      final isar = await db;
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day); // 今日の日付（時間なし）

      return await isar
          .collection<Trip>()
          .filter()
          .startDateGreaterThan(today) // 今日以降のstartDateを持つ旅行を取得
          .findAll();
    } catch (error) {
      debugPrint('今後の旅行日程取得に失敗しました。: $error');
      return [];
    }
  }

  // 当日より過去の旅行を取得
  Future<List<Trip>> getPastTrips() async {
    try {
      final isar = await db;
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      return await isar
          .collection<Trip>()
          .filter()
          .startDateLessThan(today)
          .findAll();
    } catch (error) {
      debugPrint('過去の旅行日程取得に失敗しました。: $error');
      return [];
    }
  }

  // 旅行を追加する
  Future<bool> saveTrip(Trip trip) async {
    try {
      final isar = await db;
      return await isar.writeTxn(() async {
        await isar.collection<Trip>().put(trip);
        return true;
      });
    } catch (error) {
      debugPrint('旅行登録に失敗しました。: $error');
      return false;
    }
  }

  // 旅行を更新
  Future<bool> updateTrip(Trip trip) async {
    try {
      final isar = await db;
      return await isar.writeTxn(() async {
        await isar.collection<Trip>().put(trip);
        return true;
      });
    } catch (error) {
      debugPrint('旅行の更新に失敗しました。: $error');
      return false;
    }
  }

  // 旅行を削除する
  Future<bool> deleteTrip(int id) async {
    try {
      final isar = await db;
      return await isar.writeTxn(() async {
        await isar.collection<Trip>().delete(id);
        return true;
      });
    } catch (error) {
      debugPrint('旅行の削除に失敗しました。: $error');
      return false;
    }
  }

  // IDで旅行を取得する
  Future<Trip?> getTripById(Id id) async {
    try {
      final isar = await db;
      return await isar.collection<Trip>().get(id);
    } catch (error) {
      debugPrint('IDで旅行を取得できませんでした。: $error');
      return null;
    }
  }

  //   ==== 旅行の予定関連 ====
  // 全予定を取得
  Future<List<Itinerary>> getAllItinerary() async {
    try {
      final isar = await db;
      return await isar.collection<Itinerary>().where().findAll();
    } catch (error) {
      debugPrint('予定の取得に失敗しました。: $error');
      return [];
    }
  }

  //   ==== アクティビティの取得 ====
  // 全アクティビティ取得
  Future<List<Activity>> getAllActivity() async {
    try {
      final isar = await db;
      return await isar.collection<Activity>().where().sortByArrivalTime().findAll();
    } catch (error) {
      debugPrint('アクティビティの取得に失敗しました。: $error');
      return [];
    }
  }

  // アクティビティを追加する
  Future<bool> saveActivity(Activity activity) async {
    try {
      final isar = await db;
      return await isar.writeTxn(() async {
        await isar.collection<Activity>().put(activity);
        return true;
      });
    } catch (error) {
      debugPrint('アクティビティ登録に失敗しました。: $error');
      return false;
    }
  }
}
