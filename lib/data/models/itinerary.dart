import 'package:flutter/foundation.dart';
import 'activity.dart';

@immutable
class Itinerary {
  const Itinerary({required this.date, required this.activities});

  final DateTime date;
  final List<Activity> activities;
}
