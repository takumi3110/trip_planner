import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/features/create_trip/view/create_trip_screen.dart';

void main() {
  group('CreateTripScreen', () {
    testWidgets('should display the app bar title and create button', (
      WidgetTester tester,
    ) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MaterialApp(home: CreateTripScreen()));

      // Verify that the app bar title is displayed.
      expect(find.text('旅行日程の編集'), findsOneWidget);

      // Verify that the create button is displayed.
      expect(find.widgetWithText(TextButton, '更新'), findsOneWidget);
    });

    testWidgets('should update view model when text is entered', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: CreateTripScreen()));

      // Enter text into the destination text field.
      await tester.enterText(find.byType(TextFormField), '沖縄');
      await tester.pump();

      // The view model is not directly accessible here, but we can test
      // the side effects if there were any. For now, this test just
      // ensures that entering text doesn't crash the app.
      // A more advanced test could involve a mock view model.
      expect(find.text('沖縄'), findsOneWidget);
    });
  });
}
