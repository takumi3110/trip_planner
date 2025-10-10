import 'package:flutter/material.dart';

class CreateTripViewModel extends ChangeNotifier {
  String _destination = '';
  DateTime? _startDate;
  DateTime? _endDate;

  String get destination => _destination;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  void setDestination(String value) {
    _destination = value;
    notifyListeners();
  }

  void setStartDate(DateTime date) {
    _startDate = date;
    notifyListeners();
  }

  void setEndDate(DateTime date) {
    _endDate = date;
    notifyListeners();
  }

  void createTrip() {
    // TODO: Implement trip creation logic
  }
}
