// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pocket_flow/main.dart';

// flutter test ./test/file_name_test.dart

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  // UNIT TESTS

  setUp(() {
    // this_code_runs_before_every_test_functions
  });
  setUpAll(() {
    // this_code_runs_only_one_time_before_all_test_functions
  });
  tearDown(() {
    // this_code_runs_after_every_test_functions
    // inverse_of_setup_function
  });
  tearDownAll(() {
    // this_code_runs_only_one_time_after_all_test_functions
    // inverse_of_teardown_function
  });
  test('description_for_expected_result', () {
    expect('find_value', 'expected_value');
  });

  // TEST GROUP OF TESTS
  group('description_for_expected_resultS', () {
    test('description_for_expected_result', () {
      expect('find_value', 'expected_value');
    });
    test('description_for_expected_result', () {
      expect('find_value', 'expected_value');
    });
    test('description_for_expected_result', () {
      expect('find_value', 'expected_value');
    });
  });
}
