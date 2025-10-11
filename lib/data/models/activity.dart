import 'package:flutter/material.dart';

@immutable
class Activity {
  const Activity({
    required this.name,
    required this.location,
    this.description,
    required this.time,
  });

  final String name;
  final String location;
  final String? description;
  final TimeOfDay time;
}
