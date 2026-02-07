import 'package:flutter_test/flutter_test.dart';
import 'package:udplog/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('UDP Log App basic UI test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that "UDP 通信" title is present.
    expect(find.text('UDP 通信'), findsOneWidget);

    // Verify that "受信ポート" text field is present.
    expect(find.text('受信ポート'), findsOneWidget);

    // Verify that "接続" button is present.
    expect(find.text('接続'), findsOneWidget);
  });
}
