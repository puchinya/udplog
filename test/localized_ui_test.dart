import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:udplog/l10n/app_localizations.dart';
import 'package:udplog/models/udp_state.dart';
import 'package:udplog/view_models/udp_view_model.dart';
import 'package:udplog/view_models/app_settings_view_model.dart';
import 'package:udplog/models/app_settings.dart';
import 'package:udplog/views/udp_communication_page.dart';

class MockUdpViewModel extends UdpViewModel {
  final UdpState initialState;
  MockUdpViewModel(this.initialState);

  @override
  UdpState build() => initialState;
}

void main() {
  testWidgets('UdpCommunicationPage localizes system messages from state', (WidgetTester tester) async {
    final now = DateTime(2023, 1, 1, 12, 0, 0);
    final state = UdpState(
      initialized: true,
      logs: [
        UdpMessage(
          timestamp: now,
          address: '',
          port: 0,
          message: 'Original English Message',
          systemMessageKey: 'connectionStarted',
          systemMessageArgs: '12345',
          isSystem: true,
        ),
        UdpMessage(
          timestamp: now,
          address: '',
          port: 0,
          message: 'Original File Path Message',
          systemMessageKey: 'logFile',
          systemMessageArgs: 'test_log.txt',
          isSystem: true,
        ),
        UdpMessage(
          timestamp: now,
          address: '',
          port: 0,
          message: 'Original Disconnect Message',
          systemMessageKey: 'disconnected',
          isSystem: true,
        ),
      ],
    );

    // Build the app with English locale
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          udpViewModelProvider.overrideWith(() => MockUdpViewModel(state)),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('en'),
          home: UdpCommunicationPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Check English localization
    expect(find.textContaining('--- Connection Started (Port: 12345) ---'), findsOneWidget);
    expect(find.textContaining('Log file: test_log.txt'), findsOneWidget);
    expect(find.textContaining('--- Disconnected ---'), findsOneWidget);

    // Rebuild with Japanese locale
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          udpViewModelProvider.overrideWith(() => MockUdpViewModel(state)),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('ja'),
          home: UdpCommunicationPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Check Japanese localization
    expect(find.textContaining('--- 接続開始 (ポート: 12345) ---'), findsOneWidget);
    expect(find.textContaining('ログファイル: test_log.txt'), findsOneWidget);
    expect(find.textContaining('--- 切断 ---'), findsOneWidget);
  });
}
