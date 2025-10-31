import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatWeekday(DateTime date) {
  return DateFormat('E', 'ja').format(date);
}

String formatTimeOfDay(TimeOfDay time) {
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  return DateFormat('HH:mm').format(dt);
}
