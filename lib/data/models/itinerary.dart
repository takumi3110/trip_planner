import 'package:isar/isar.dart';
import 'package:trip_planner/data/models/activity.dart';

part 'itinerary.g.dart';

@collection
class Itinerary {
  Id id = Isar.autoIncrement;
  final DateTime date;
  final IsarLinks<Activity> activities = IsarLinks<Activity>();
  // final String name;
  // final DateTime arrivalTime;
  // final DateTime departureTime;
  // final String category;
  // final String moved;




  Itinerary({required this.date}); // ✨ dateもrequiredにするよ！

}
