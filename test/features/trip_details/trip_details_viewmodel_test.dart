import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_planner/data/models/trip.dart';
import 'package:trip_planner/data/repositories/trip_repository.dart';
import 'package:trip_planner/features/trip_details/viewmodel/trip_details_viewmodel.dart';

// Mock TripRepository
class MockTripRepository extends Mock implements TripRepository {}

void main() {
  group('TripDetailsViewModel', () {
    late TripDetailsViewModel viewModel;
    late MockTripRepository mockTripRepository;

    setUp(() {
      mockTripRepository = MockTripRepository();
      viewModel = TripDetailsViewModel(
        tripId: 'test_trip_id',
        tripRepository: mockTripRepository,
      );
    });

    test('initial values are correct', () {
      expect(viewModel.trip, isNull);
      expect(viewModel.isLoading, isFalse);
    });

    test('loadTripDetails loads trip successfully', () async {
      final mockTrip = Trip(
        destination: 'Test Destination',
        startDate: DateTime(2025, 1, 1),
        endDate: DateTime(2025, 1, 5),
        itineraries: [],
        numberOfPeople: 2,
      );

      when(
        () => mockTripRepository.getTrip('test_trip_id'),
      ).thenAnswer((_) async => mockTrip);

      await viewModel.loadTripDetails();

      expect(viewModel.isLoading, isFalse);
      expect(viewModel.trip, equals(mockTrip));
      verify(() => mockTripRepository.getTrip('test_trip_id')).called(1);
    });

    test('loadTripDetails handles error', () async {
      when(
        () => mockTripRepository.getTrip('test_trip_id'),
      ).thenThrow(Exception('Failed to load trip'));

      await viewModel.loadTripDetails();

      expect(viewModel.isLoading, isFalse);
      expect(viewModel.trip, isNull);
      verify(() => mockTripRepository.getTrip('test_trip_id')).called(1);
    });
  });
}
