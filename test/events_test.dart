import 'package:flutter_test/flutter_test.dart';
import 'package:youthspot/screens/events/events_screen.dart';

void main() {
  testWidgets('EventsScreen should be created without errors', (WidgetTester tester) async {
    // This basic test just verifies the widget can be instantiated
    expect(() => const EventsScreen(), returnsNormally);
  });
}