import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:udplog/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:udplog/l10n/app_localizations.dart';

void main() {
  testWidgets('UDP Log App basic UI test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Check for English strings (default)
    expect(find.text('UDP Comm'), findsOneWidget);
    expect(find.text('Receive Port'), findsOneWidget);
    expect(find.text('Connect'), findsOneWidget);
  });

  testWidgets('UDP Log App Japanese UI test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    // Build our app with Japanese locale
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('ja'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MainNavigationPage(),
      ),
    );
    await tester.pumpAndSettle();

    // Check for Japanese strings
    expect(find.text('UDP 通信'), findsOneWidget);
    expect(find.text('受信ポート'), findsOneWidget);
    expect(find.text('接続'), findsOneWidget);
  });
}
