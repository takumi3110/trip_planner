import 'package:flutter/foundation.dart';
import 'itinerary.dart';

@immutable
class Trip {
  const Trip({
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.itineraries,
    required this.numberOfPeople,
  });

  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final List<Itinerary> itineraries;
  final int numberOfPeople;
}
