import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:udplog/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:udplog/l10n/app_localizations.dart';
import 'package:udplog/views/main_navigation_page.dart';

void main() {
  testWidgets('UDPLog basic UI test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();

    // Check for English strings (default)
    expect(find.text('UDP Comm'), findsOneWidget);
    expect(find.text('Receive Port'), findsOneWidget);
    expect(find.text('Connect'), findsOneWidget);
    
    final bool isIOS = !kIsWeb && (Platform.isIOS || Platform.isMacOS);
    if (isIOS) {
      expect(find.byIcon(CupertinoIcons.settings), findsOneWidget);
    } else {
      expect(find.byIcon(Icons.settings), findsOneWidget);
    }
  });

  testWidgets('UDPLog Japanese UI test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    // Build our app with Japanese locale
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          locale: Locale('ja'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MainNavigationPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Check for Japanese strings
    expect(find.text('UDP 通信'), findsOneWidget);
    expect(find.text('受信ポート'), findsOneWidget);
    expect(find.text('接続'), findsOneWidget);
  });

  testWidgets('Font settings update test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();

    // Go to settings tab
    final bool isIOS = !kIsWeb && (Platform.isIOS || Platform.isMacOS);
    if (isIOS) {
      await tester.tap(find.byIcon(CupertinoIcons.settings));
    } else {
      await tester.tap(find.byIcon(Icons.settings));
    }
    await tester.pumpAndSettle();

    if (isIOS) {
      expect(find.text('FONT SIZE'), findsOneWidget);
    } else {
      expect(find.text('Font Size'), findsOneWidget);
    }

    // Initial font size should be 12
    expect(find.text('12'), findsAtLeast(1));

    // Change font size using slider
    // The slider is in the middle of the screen usually, let's find it.
    final sliderFinder = find.byType(Slider);
    expect(sliderFinder, findsOneWidget);
    
    // Drag slider to the right
    await tester.drag(sliderFinder, const Offset(100, 0));
    await tester.pumpAndSettle();

    // Font size should have changed from 12
    expect(find.text('12'), findsNothing);
  });
}
