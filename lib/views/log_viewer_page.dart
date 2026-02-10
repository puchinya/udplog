import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../l10n/app_localizations.dart';
import '../view_models/app_settings_view_model.dart';
import '../view_models/log_viewer_view_model.dart';

class LogViewerPage extends ConsumerWidget {
  const LogViewerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(logViewerViewModelProvider);
    final viewModel = ref.read(logViewerViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.logViewer),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => viewModel.refreshLogFiles(),
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog.adaptive(
                  title: Text(l10n.confirmDelete),
                  content: Text(l10n.deleteAllLogsConfirm),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(l10n.cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        viewModel.deleteAllLogs();
                        Navigator.pop(context);
                      },
                      child: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (state.logFiles.isEmpty)
            Expanded(child: Center(child: Text(l10n.noLogs)))
          else
            Expanded(
              child: ListView.builder(
                itemCount: state.logFiles.length,
                itemBuilder: (context, index) {
                  final file = state.logFiles[index];
                  final fileName = file.path.split(Platform.pathSeparator).last;
                  return ListTile(
                    title: Text(fileName),
                    selected: state.selectedFileName == fileName,
                    onTap: () {
                      viewModel.loadFileContent(file);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LogDetailView(file: file),
                        ),
                      );
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.share),
                          onPressed: () {
                            final fileName = file.path.split(Platform.pathSeparator).last;
                            Share.shareXFiles([XFile(file.path)], text: fileName);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog.adaptive(
                                title: Text(l10n.confirmDelete),
                                content: Text(l10n.deleteFileConfirm),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(l10n.cancel),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      viewModel.deleteFile(file);
                                      Navigator.pop(context);
                                    },
                                    child: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class LogDetailView extends ConsumerWidget {
  final File file;
  const LogDetailView({super.key, required this.file});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(logViewerViewModelProvider);
    final settings = ref.watch(appSettingsViewModelProvider);
    final fileName = file.path.split(Platform.pathSeparator).last;

    final logStyle = TextStyle(
      fontFamily: 'monospace',
      fontFamilyFallback: const ['Courier'],
      fontSize: settings.fontSize,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(fileName),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Share.shareXFiles([XFile(file.path)], text: fileName);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(4),
          ),
          child: SingleChildScrollView(
            child: Text(
              state.fileContent,
              style: logStyle,
            ),
          ),
        ),
      ),
    );
  }
}
