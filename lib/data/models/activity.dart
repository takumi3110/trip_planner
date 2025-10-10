import 'package:flutter/foundation.dart';

@immutable
class Activity {
  const Activity({
    required this.name,
    required this.location,
    required this.startTime,
    this.endTime,
    this.description,
  });

  final String name;
  final String location;
  final DateTime startTime;
  final DateTime? endTime;
  final String? description;
}
