import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(l10n.theme, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SegmentedButton<ThemeMode>(
              segments: [
                ButtonSegment(value: ThemeMode.system, label: Text(l10n.themeSystem), icon: const Icon(Icons.settings_brightness)),
                ButtonSegment(value: ThemeMode.light, label: Text(l10n.themeLight), icon: const Icon(Icons.light_mode)),
                ButtonSegment(value: ThemeMode.dark, label: Text(l10n.themeDark), icon: const Icon(Icons.dark_mode)),
              ],
              selected: {settings.themeMode},
              onSelectionChanged: (Set<ThemeMode> newSelection) {
                viewModel.updateThemeMode(newSelection.first);
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(l10n.language, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
          const Divider(),
          ListTile(
            title: Text(l10n.fontSettings, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(l10n.fontSize),
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
          ListTile(
            title: Text(l10n.version(settings.initialized ? _version : '')),
          ),
          const AboutListTile(
            applicationName: 'UDP Log',
            icon: Icon(Icons.info),
          ),
        ],
      ),
    );
  }
}
