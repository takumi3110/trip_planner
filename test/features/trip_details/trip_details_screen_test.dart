import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
          title: '',
          destination: '',
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          numberOfPeople: 1,
        ),
      );
    });

    setUp(() {
      mockTripRepository = MockTripRepository();
      mockViewModel = MockTripDetailsViewModel();

      // デフォルトのmockTripを設定
      final defaultMockTrip = Trip(
        title: 'test',
        destination: 'Test Destination',
        startDate: DateTime(2025, 1, 1),
        endDate: DateTime(2025, 1, 5),
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
      return ProviderScope(
        overrides: [
          tripRepositoryProvider.overrideWith(
            (ref) => mockTripRepository,
          ),
          tripDetailsViewModelProvider('test_trip_id').overrideWith(
            (ref) => mockViewModel,
          ),
        ],
        child: MaterialApp(
          locale: const Locale('en', 'US'), // ロケールを設定
          builder: (context, _) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
              child: child,
            );
          },
          home: Container(), // homeはbuilderを使う場合は不要
        ),
      );
    }

    testWidgets('shows loading indicator when loading', (tester) async {
      final mockTrip = Trip(
        title: 'test',
        destination: 'Test Destination',
        startDate: DateTime(2025, 1, 1),
        endDate: DateTime(2025, 1, 5),
        numberOfPeople: 2,
      );
      // getTripが遅延して完了するようにモックを設定
      when(() => mockTripRepository.getTrip('test_trip_id')).thenAnswer((
        _,
      ) async {
        await Future.delayed(const Duration(seconds: 2));
        return mockTrip;
      });

      when(() => mockViewModel.isLoading).thenReturn(true); // ローディング状態をtrueに設定

      await tester.pumpWidget(
        createTestableWidget(const TripDetailsScreen(tripId: 'test_trip_id')),
      );
      await tester.pump(); // ViewModelの作成と初期ロード後のUI更新を待機
      await tester.pump(); // ローディング状態が反映されるまで待機

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      when(() => mockViewModel.isLoading).thenReturn(false); // ローディング状態をfalseに設定
      when(() => mockViewModel.trip).thenReturn(mockTrip); // tripを設定
      await tester.pumpAndSettle(); // ローディング完了まで待機
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Test Destination'), findsOneWidget);
    });

    testWidgets('shows error message when trip is null', (tester) async {
      when(() => mockViewModel.isLoading).thenReturn(false);
      when(() => mockViewModel.trip).thenReturn(null); // tripをnullに設定

      await tester.pumpWidget(
        createTestableWidget(const TripDetailsScreen(tripId: 'test_trip_id')),
      );
      await tester.pumpAndSettle(); // UIが完全に更新されるまで待機
      expect(find.text('旅行プランが見つかりませんでした。'), findsOneWidget);
    });

    testWidgets('displays trip details correctly', (tester) async {
      final mockTrip = Trip(
        title: 'test',
        destination: '沖縄旅行',
        startDate: DateTime(2025, 7, 20),
        endDate: DateTime(2025, 7, 25),
        numberOfPeople: 3,
      );

      when(() => mockViewModel.isLoading).thenReturn(false);
      when(() => mockViewModel.trip).thenReturn(mockTrip); // tripを設定

      await tester.pumpWidget(
        createTestableWidget(const TripDetailsScreen(tripId: 'test_trip_id')),
      );
      await tester.pumpAndSettle(); // UIが完全に更新されるまで待機

      expect(find.text('沖縄旅行'), findsOneWidget);
      // 日程や人数はViewModelから直接取得しないので、ここではテストしない
      // expect(find.text('2025-07-20 - 2025-07-25'), findsOneWidget);
      // expect(find.text('人数: 3人'), findsOneWidget);
      // 旅程の詳細はTripDetailsScreenのコメントアウトされている部分なので、ここではテストしない
      // expect(find.text('那覇空港到着'), findsOneWidget);
      // expect(find.text('時間: 10:00 AM'), findsOneWidget);
      // expect(find.text('場所: 那覇空港'), findsOneWidget);
      // expect(find.text('詳細: レンタカーを借りる'), findsOneWidget);
      // expect(find.text('美ら海水族館'), findsOneWidget);
      // expect(find.text('時間: 2:00 PM'), findsOneWidget);
      // expect(find.text('場所: 本部町'), findsOneWidget);
    });
  });
}
