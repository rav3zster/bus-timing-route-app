import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smart_bus_assistant/main.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: SmartBusApp()));
    expect(find.byType(SmartBusApp), findsOneWidget);
  });
}
