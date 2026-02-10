import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../view_models/log_viewer_view_model.dart';
import 'udp_communication_page.dart';
import 'log_viewer_page.dart';
import 'settings_page.dart';

class MainNavigationPage extends ConsumerStatefulWidget {
  const MainNavigationPage({super.key});

  @override
  ConsumerState<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends ConsumerState<MainNavigationPage> {
  int _selectedIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      ref.read(logViewerViewModelProvider.notifier).refreshLogFiles();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool isIOS = !kIsWeb && (Platform.isIOS || Platform.isMacOS);

    if (isIOS) {
      return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: [
            BottomNavigationBarItem(
              icon: const Icon(CupertinoIcons.shuffle),
              label: l10n.tabCommunication,
            ),
            BottomNavigationBarItem(
              icon: const Icon(CupertinoIcons.doc_text),
              label: l10n.tabLog,
            ),
            BottomNavigationBarItem(
              icon: const Icon(CupertinoIcons.settings),
              label: l10n.tabSettings,
            ),
          ],
          onTap: _onTabTapped,
          currentIndex: _selectedIndex,
        ),
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return const CupertinoPageScaffold(child: Material(child: UdpCommunicationPage()));
            case 1:
              return const CupertinoPageScaffold(child: Material(child: LogViewerPage()));
            case 2:
              return const CupertinoPageScaffold(child: Material(child: SettingsPage()));
            default:
              return const CupertinoPageScaffold(child: Material(child: UdpCommunicationPage()));
          }
        },
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          UdpCommunicationPage(),
          LogViewerPage(),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.swap_horiz),
            label: l10n.tabCommunication,
          ),
          NavigationDestination(
            icon: const Icon(Icons.history),
            label: l10n.tabLog,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings),
            label: l10n.tabSettings,
          ),
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onTabTapped,
      ),
    );
  }
}
