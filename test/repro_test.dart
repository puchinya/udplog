import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:udplog/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Change language in settings test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    
    // Start the app
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();

    // Verify it starts in English (default)
    expect(find.text('UDP Comm'), findsOneWidget);

    // Go to settings tab
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    // Find the Language segmented button for Japanese
    // The segments are: [Follow OS, English, Japanese]
    // The labels are from l10n.
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('Japanese'), findsOneWidget);

    // Tap 'Japanese'
    await tester.tap(find.text('Japanese'));
    await tester.pumpAndSettle();

    // Now it should be Japanese
    // 'Language' becomes '言語'
    expect(find.text('言語'), findsOneWidget);
    expect(find.text('日本語'), findsOneWidget);

    // Go back to communication tab
    await tester.tap(find.byIcon(Icons.swap_horiz));
    await tester.pumpAndSettle();

    // Communication tab should be in Japanese
    expect(find.text('UDP 通信'), findsOneWidget);
  });
}
