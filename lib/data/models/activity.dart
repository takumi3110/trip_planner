import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:trip_planner/data/models/trip.dart';

part 'activity.g.dart';

@collection
class Activity {
  Id id = Isar.autoIncrement;
  final String name;
  final String location;
  final String description;
  final int timeInMinutes;
  final String? category;
  final DateTime arrivalTime;
  final DateTime departureTime;
  final String moved;

  final trip = IsarLink<Trip>();

  Activity({
    required this.name,
    required this.location,
    required this.description,
    required this.arrivalTime,
    required this.departureTime,
    required this.moved,
    required this.timeInMinutes,
    this.category,
  });

  // TimeOfDayに変換するgetterを追加すると便利だよ！
  @ignore
  TimeOfDay get time =>
      TimeOfDay(hour: timeInMinutes ~/ 60, minute: timeInMinutes % 60);
}