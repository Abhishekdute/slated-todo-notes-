import 'package:flutter_test/flutter_test.dart';
import 'package:skylist/main.dart';

void main() {
  testWidgets('App basic smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SkyListApp());
  });
}
