// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:nutrition_app/main.dart';
import 'package:nutrition_app/notifiers/patient_notifier.dart';

void main() {
  testWidgets('Welcome screen flows to practitioner dashboard',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => PatientNotifier()),
        ],
        child: const MyApp(),
      ),
    );

    // Allow the splash screen timer to elapse.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('AyurDiet Pro'), findsOneWidget);
    expect(find.textContaining('Prototype highlights'), findsOneWidget);

    await tester.tap(find.text('Enter Practitioner Dashboard'));
    await tester.pumpAndSettle();

    expect(find.text('AyurDiet Practitioner'), findsOneWidget);
    expect(find.textContaining('Holistic practice cockpit'), findsOneWidget);
  });
}
