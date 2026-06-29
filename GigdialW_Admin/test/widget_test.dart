import 'package:flutter_test/flutter_test.dart';
import 'package:gigdialw/main.dart';

void main() {
  testWidgets('GigDial app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const GigDialApp());

    // Verify that Splash Screen appears with the word 'GigDial'
    expect(find.text('GigDial'), findsOneWidget);
  });
}
