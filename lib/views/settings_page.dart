import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../l10n/app_localizations.dart';
import '../view_models/app_settings_view_model.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  String _version = '';
  final FocusNode _demoServerPortFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  @override
  void dispose() {
    _demoServerPortFocus.dispose();
    super.dispose();
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _version = info.version;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(appSettingsViewModelProvider);
    final viewModel = ref.read(appSettingsViewModelProvider.notifier);
    final bool isIOS = !kIsWeb && (Platform.isIOS || Platform.isMacOS);

    KeyboardActionsConfig buildKeyboardActionsConfig(BuildContext context) {
      return KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        keyboardBarColor: isIOS ? CupertinoColors.systemGrey6.resolveFrom(context) : Colors.grey[200],
        actions: [
          KeyboardActionsItem(
            focusNode: _demoServerPortFocus,
            toolbarButtons: [
              (node) {
                return GestureDetector(
                  onTap: () => node.unfocus(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      l10n.done,
                      style: TextStyle(
                        color: isIOS ? CupertinoColors.activeBlue : Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }
            ],
          ),
        ],
      );
    }

    Widget content = KeyboardActions(
      config: buildKeyboardActionsConfig(context),
      child: ListView(
        children: [
        if (isIOS)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 20, bottom: 8),
            child: Text(l10n.theme.toUpperCase(), style: TextStyle(fontSize: 13, color: CupertinoDynamicColor.resolve(CupertinoColors.secondaryLabel, context))),
          )
        else
          ListTile(
            title: Text(l10n.theme, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            width: double.infinity,
            child: SegmentedButton<ThemeMode>(
              segments: [
                ButtonSegment(value: ThemeMode.system, label: Text(l10n.themeSystem), icon: Icon(isIOS ? CupertinoIcons.settings : Icons.settings_brightness)),
                ButtonSegment(value: ThemeMode.light, label: Text(l10n.themeLight), icon: Icon(isIOS ? CupertinoIcons.sun_max : Icons.light_mode)),
                ButtonSegment(value: ThemeMode.dark, label: Text(l10n.themeDark), icon: Icon(isIOS ? CupertinoIcons.moon : Icons.dark_mode)),
              ],
              selected: {settings.themeMode},
              onSelectionChanged: (Set<ThemeMode> newSelection) {
                viewModel.updateThemeMode(newSelection.first);
              },
            ),
          ),
        ),
        const Divider(),
        if (isIOS)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 20, bottom: 8),
            child: Text(l10n.language.toUpperCase(), style: TextStyle(fontSize: 13, color: CupertinoDynamicColor.resolve(CupertinoColors.secondaryLabel, context))),
          )
        else
          ListTile(
            title: Text(l10n.language, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            width: double.infinity,
            child: SegmentedButton<String?>(
              segments: [
                ButtonSegment(value: null, label: Text(l10n.languageSystem)),
                ButtonSegment(value: 'en', label: Text(l10n.languageEn)),
                ButtonSegment(value: 'ja', label: Text(l10n.languageJa)),
              ],
              selected: {settings.locale?.languageCode},
              onSelectionChanged: (Set<String?> newSelection) {
                final code = newSelection.first;
                viewModel.updateLocale(code == null ? null : Locale(code));
              },
            ),
          ),
        ),
        const Divider(),
        if (isIOS)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 20, bottom: 8),
            child: Text(l10n.fontSize.toUpperCase(), style: TextStyle(fontSize: 13, color: CupertinoDynamicColor.resolve(CupertinoColors.secondaryLabel, context))),
          )
        else
          ListTile(
            title: Text(l10n.fontSize, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(l10n.communicationWindow),
                  Expanded(
                    child: Slider.adaptive(
                      value: settings.fontSize,
                      min: 8,
                      max: 24,
                      divisions: 16,
                      label: settings.fontSize.round().toString(),
                      onChanged: (val) {
                        viewModel.updateFontSize(val);
                      },
                    ),
                  ),
                  Text(settings.fontSize.round().toString()),
                ],
              ),
            ],
          ),
        ),
        const Divider(),
        SwitchListTile.adaptive(
          title: Text(l10n.preventSleepDuringUdp),
          value: settings.preventSleepDuringUdp,
          onChanged: (val) {
            viewModel.updatePreventSleepDuringUdp(val);
          },
        ),
        const Divider(),
        SwitchListTile.adaptive(
          title: Text(l10n.demoServer),
          value: settings.demoServerEnabled,
          onChanged: (val) {
            viewModel.updateDemoServerEnabled(val);
          },
        ),
        if (settings.demoServerEnabled)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(l10n.demoServerPort),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    focusNode: _demoServerPortFocus,
                    decoration: InputDecoration(
                      hintText: '12345',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      viewModel.updateDemoServerPort(val);
                    },
                    controller: TextEditingController(text: settings.demoServerPort)
                      ..selection = TextSelection.fromPosition(
                        TextPosition(offset: settings.demoServerPort.length),
                      ),
                  ),
                ),
              ],
            ),
          ),
        const Divider(),
        ListTile(
          leading: Icon(isIOS ? CupertinoIcons.doc_text : Icons.description),
          title: Text(l10n.licenses),
          onTap: () {
            showLicensePage(
              context: context,
              applicationName: 'UDP Log',
              applicationVersion: _version,
            );
          },
        ),
        ListTile(
          title: Text(l10n.version(settings.initialized ? _version : '')),
        ),
      ],
    ),
    );

    if (isIOS) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(l10n.settings),
        ),
        child: SafeArea(child: content),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        centerTitle: true,
      ),
      body: content,
    );
  }
}
