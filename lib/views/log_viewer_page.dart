import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
    final bool isIOS = !kIsWeb && (Platform.isIOS || Platform.isMacOS);

    Widget content = Column(
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
                    if (isIOS) {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => LogDetailView(file: file),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LogDetailView(file: file),
                        ),
                      );
                    }
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 44,
                        height: 44,
                        child: IconButton(
                          icon: Icon(isIOS ? CupertinoIcons.share : Icons.share),
                          onPressed: () {
                            final fileName = file.path.split(Platform.pathSeparator).last;
                            // ignore: deprecated_member_use
                            Share.shareXFiles([XFile(file.path)], text: fileName);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 44,
                        height: 44,
                        child: IconButton(
                          icon: Icon(isIOS ? CupertinoIcons.delete : Icons.delete_outline),
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
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );

    if (isIOS) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(l10n.logViewer),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => viewModel.refreshLogFiles(),
                child: const Icon(CupertinoIcons.refresh),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
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
                child: const Icon(CupertinoIcons.delete),
              ),
            ],
          ),
        ),
        child: SafeArea(child: content),
      );
    }

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
      body: content,
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
    final bool isIOS = !kIsWeb && (Platform.isIOS || Platform.isMacOS);

    final logStyle = TextStyle(
      fontFamily: 'monospace',
      fontFamilyFallback: const ['Courier'],
      fontSize: settings.fontSize,
    );

    Widget content = Padding(
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
    );

    if (isIOS) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(fileName),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              // ignore: deprecated_member_use
              Share.shareXFiles([XFile(file.path)], text: fileName);
            },
            child: const Icon(CupertinoIcons.share),
          ),
        ),
        child: SafeArea(child: content),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(fileName),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // ignore: deprecated_member_use
              Share.shareXFiles([XFile(file.path)], text: fileName);
            },
          ),
        ],
      ),
      body: content,
    );
  }
}
