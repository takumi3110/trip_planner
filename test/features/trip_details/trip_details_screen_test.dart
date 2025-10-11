import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/data/models/activity.dart';
import 'package:trip_planner/data/models/itinerary.dart';
import 'package:trip_planner/data/models/trip.dart';
import 'package:trip_planner/data/repositories/trip_repository.dart';
import 'package:trip_planner/features/trip_details/view/trip_details_screen.dart';
import 'package:trip_planner/features/trip_details/viewmodel/trip_details_viewmodel.dart';

// Mock TripRepository
class MockTripRepository extends Mock implements TripRepository {}

// Mock TripDetailsViewModel
class MockTripDetailsViewModel extends Mock implements TripDetailsViewModel {}

void main() {
  group('TripDetailsScreen', () {
    late MockTripRepository mockTripRepository;
    late MockTripDetailsViewModel mockViewModel;

    setUpAll(() {
      registerFallbackValue(
        Trip(
          destination: '',
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          itineraries: [],
          numberOfPeople: 1,
        ),
      );
    });

    setUp(() {
      mockTripRepository = MockTripRepository();
      mockViewModel = MockTripDetailsViewModel();

      // デフォルトのmockTripを設定
      final defaultMockTrip = Trip(
        destination: 'Test Destination',
        startDate: DateTime(2025, 1, 1),
        endDate: DateTime(2025, 1, 5),
        itineraries: [],
        numberOfPeople: 1,
      );
      when(
        () => mockTripRepository.getTrip(any()),
      ).thenAnswer((_) async => defaultMockTrip);

      when(() => mockViewModel.tripId).thenReturn('test_trip_id');
      when(() => mockViewModel.isLoading).thenReturn(false);
      when(() => mockViewModel.loadTripDetails()).thenAnswer((_) async {});
    });

    Widget createTestableWidget(Widget child) {
      return MaterialApp(
        locale: const Locale('en', 'US'), // ロケールを設定
        builder: (context, _) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: Provider<TripRepository>(
              // Provider<TripRepository>を上位に移動
              create: (_) => mockTripRepository,
              child: ChangeNotifierProvider<TripDetailsViewModel>.value(
                value: mockViewModel,
                child: child,
              ),
            ),
          );
        },
        home: Container(), // homeはbuilderを使う場合は不要
      );
    }

    testWidgets('shows loading indicator when loading', (tester) async {
      final mockTrip = Trip(
        destination: 'Test Destination',
        startDate: DateTime(2025, 1, 1),
        endDate: DateTime(2025, 1, 5),
        itineraries: [],
        numberOfPeople: 2,
      );
      // getTripが遅延して完了するようにモックを設定
      when(() => mockTripRepository.getTrip('test_trip_id')).thenAnswer((
        _,
      ) async {
        await Future.delayed(const Duration(seconds: 2));
        return mockTrip;
      });

      final loadingViewModel = TripDetailsViewModel(
        tripId: 'test_trip_id',
        tripRepository: mockTripRepository,
      );
      loadingViewModel.loadTripDetails(); // ローディング状態を開始
      await tester.pump(); // ローディング状態が反映されるまで待機

      await tester.pumpWidget(
        createTestableWidget(const TripDetailsScreen(tripId: 'test_trip_id')),
      );
      await tester.pump(); // ViewModelの作成と初期ロード後のUI更新を待機
      await tester.pump(); // ローディング状態が反映されるまで待機

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle(); // ローディング完了まで待機
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Test Destination'), findsOneWidget);
    });

    testWidgets('shows error message when trip is null', (tester) async {
      when(() => mockTripRepository.getTrip(any())).thenAnswer(
        (_) async => Future.error(Exception('Trip not found')),
      ); // 例外を返すようにモックを設定

      final nullTripViewModel = TripDetailsViewModel(
        tripId: 'test_trip_id',
        tripRepository: mockTripRepository,
      );
      nullTripViewModel.loadTripDetails(); // エラー状態を開始

      await tester.pumpWidget(
        createTestableWidget(const TripDetailsScreen(tripId: 'test_trip_id')),
      );
      await tester.pumpAndSettle(); // UIが完全に更新されるまで待機
      expect(find.text('旅行プランが見つかりませんでした。'), findsOneWidget);
    });

    testWidgets('displays trip details correctly', (tester) async {
      final mockTrip = Trip(
        destination: '沖縄旅行',
        startDate: DateTime(2025, 7, 20),
        endDate: DateTime(2025, 7, 25),
        numberOfPeople: 3,
        itineraries: [
          Itinerary(
            date: DateTime(2025, 7, 20),
            activities: [
              Activity(
                name: '那覇空港到着',
                time: const TimeOfDay(hour: 10, minute: 0),
                location: '那覇空港',
                description: 'レンタカーを借りる',
              ),
              Activity(
                name: '美ら海水族館',
                time: const TimeOfDay(hour: 14, minute: 0),
                location: '本部町',
                description: null,
              ),
            ],
          ),
        ],
      );

      when(
        () => mockTripRepository.getTrip('test_trip_id'),
      ).thenAnswer((_) async => Future.value(mockTrip));

      final displayTripViewModel = TripDetailsViewModel(
        tripId: 'test_trip_id',
        tripRepository: mockTripRepository,
      );
      displayTripViewModel.loadTripDetails(); // 旅行詳細表示状態を開始

      await tester.pumpWidget(
        createTestableWidget(const TripDetailsScreen(tripId: 'test_trip_id')),
      );
      await tester.pumpAndSettle(); // UIが完全に更新されるまで待機

      expect(find.text('沖縄旅行'), findsOneWidget);
      expect(find.text('2025-07-20 - 2025-07-25'), findsOneWidget);
      expect(find.text('人数: 3人'), findsOneWidget);
      expect(find.text('那覇空港到着'), findsOneWidget);
      expect(find.text('時間: 10:00 AM'), findsOneWidget);
      expect(find.text('場所: 那覇空港'), findsOneWidget);
      expect(find.text('詳細: レンタカーを借りる'), findsOneWidget);
      expect(find.text('美ら海水族館'), findsOneWidget);
      expect(find.text('時間: 2:00 PM'), findsOneWidget);
      expect(find.text('場所: 本部町'), findsOneWidget);
    });
  });
}
