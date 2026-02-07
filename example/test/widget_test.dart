import 'package:flutter_test/flutter_test.dart';
import 'package:example/app.dart';

void main() {
  testWidgets('App shows Cities & Areas screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Cities & Areas'), findsOneWidget);
  });
}
