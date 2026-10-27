import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_cards_app/main.dart';

void main() {
  testWidgets('SmartCardsApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: SmartCardsApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Login screen text is rendered
    expect(find.text('SMART'), findsOneWidget);
    expect(find.text('CARDS'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
