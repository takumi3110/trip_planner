import 'package:isar/isar.dart';
import 'package:trip_planner/data/models/activity.dart';

part 'trip.g.dart';

@collection
class Trip {
  Id id = Isar.autoIncrement;
  late String title;
  late String destination; //目的地
  late DateTime startDate;
  late DateTime endDate;
  final IsarLinks<Activity> activities = IsarLinks<Activity>();
  int numberOfPeople;
  String? memo;


  @Index(type: IndexType.value)
  String? destinationIndex;

  Trip({
    required this.title,
    required this.destination,
    required this.startDate,
    required this.endDate,
    // required this.itineraries,
    required this.numberOfPeople,
    this.memo,
  }) {
    destinationIndex = destination.toLowerCase();
  }
}
