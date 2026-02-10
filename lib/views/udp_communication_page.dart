import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../l10n/app_localizations.dart';
import '../view_models/app_settings_view_model.dart';
import '../view_models/udp_view_model.dart';

class UdpCommunicationPage extends ConsumerStatefulWidget {
  const UdpCommunicationPage({super.key});

  @override
  ConsumerState<UdpCommunicationPage> createState() => _UdpCommunicationPageState();
}

class _UdpCommunicationPageState extends ConsumerState<UdpCommunicationPage> {
  late TextEditingController _receivePortController;
  late TextEditingController _sendAddressController;
  late TextEditingController _sendPortController;
  late TextEditingController _sendMessageController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final udpState = ref.read(udpViewModelProvider);
    _receivePortController = TextEditingController(text: udpState.receivePort);
    _sendAddressController = TextEditingController(text: udpState.sendAddress);
    _sendPortController = TextEditingController(text: udpState.sendPort);
    _sendMessageController = TextEditingController(text: udpState.sendMessage);
  }

  @override
  void dispose() {
    _receivePortController.dispose();
    _sendAddressController.dispose();
    _sendPortController.dispose();
    _sendMessageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showError(String message) {
    if (!mounted) return;
    final bool isIOS = !kIsWeb && (Platform.isIOS || Platform.isMacOS);
    if (isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(AppLocalizations.of(context)!.error('')),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final udpState = ref.watch(udpViewModelProvider);
    final settings = ref.watch(appSettingsViewModelProvider);
    final viewModel = ref.read(udpViewModelProvider.notifier);

    // Listen for log changes to scroll
    ref.listen(udpViewModelProvider.select((s) => s.logs.length), (previous, next) {
      if (next > (previous ?? 0)) {
        _scrollToBottom();
      }
    });

    // Update controllers when initialized
    ref.listen(udpViewModelProvider.select((s) => s.initialized), (previous, next) {
      if (next && !(previous ?? false)) {
        final state = ref.read(udpViewModelProvider);
        _receivePortController.text = state.receivePort;
        _sendAddressController.text = state.sendAddress;
        _sendPortController.text = state.sendPort;
        _sendMessageController.text = state.sendMessage;
      }
    });

    if (!udpState.initialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    final logStyle = TextStyle(
      fontFamily: 'monospace',
      fontSize: settings.fontSize,
    );

    final bool isIOS = !kIsWeb && (Platform.isIOS || Platform.isMacOS);

    Widget content = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: !kIsWeb && Platform.isAndroid ? MainAxisSize.min : MainAxisSize.max,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _receivePortController,
                  decoration: InputDecoration(labelText: l10n.receivePort),
                  keyboardType: TextInputType.number,
                  enabled: !udpState.isReceiving,
                  onChanged: viewModel.updateReceivePort,
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => viewModel.toggleConnection(
                  preventSleep: settings.preventSleepDuringUdp,
                  onError: _showError,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: udpState.isReceiving 
                      ? (Theme.of(context).brightness == Brightness.dark ? Colors.red.shade900 : Colors.red.shade100)
                      : (Theme.of(context).brightness == Brightness.dark ? Colors.green.shade900 : Colors.green.shade100),
                  foregroundColor: udpState.isReceiving
                      ? (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.red.shade900)
                      : (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.green.shade900),
                ).copyWith(
                  mouseCursor: WidgetStateProperty.resolveWith<MouseCursor>(
                    (states) => states.contains(WidgetState.disabled) ? SystemMouseCursors.basic : SystemMouseCursors.click,
                  ),
                ),
                child: Text(udpState.isReceiving ? l10n.disconnect : l10n.connect),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(4),
              ),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: udpState.logs.length,
                itemBuilder: (context, index) {
                  final log = udpState.logs[index];
                  final timeStr = DateFormat('HH:mm:ss.SSS').format(log.timestamp);
                  String text;
                  Color? textColor;
                  FontStyle? fontStyle;

                  if (log.isSystem) {
                    String systemMsg = log.message;
                    if (log.systemMessageKey != null) {
                      switch (log.systemMessageKey) {
                        case 'connectionStarted':
                          systemMsg = l10n.connectionStarted(int.tryParse(log.systemMessageArgs ?? '') ?? 0);
                          break;
                        case 'logFile':
                          systemMsg = l10n.logFile(log.systemMessageArgs ?? '');
                          break;
                        case 'disconnected':
                          systemMsg = l10n.disconnected;
                          break;
                      }
                    }
                    text = '[$timeStr] $systemMsg';
                    textColor = Colors.grey;
                    fontStyle = FontStyle.italic;
                  } else if (log.isOutgoing) {
                    text = '[$timeStr] OUT -> ${log.address}:${log.port}: ${log.message}';
                    textColor = Colors.blue;
                  } else {
                    text = '[$timeStr] ${log.address}:${log.port} -> ${log.message}';
                  }
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                    child: Text(
                      text,
                      style: logStyle.copyWith(
                        color: textColor,
                        fontStyle: fontStyle,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _sendAddressController,
                  decoration: InputDecoration(labelText: l10n.destinationIp),
                  onChanged: viewModel.updateSendAddress,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _sendPortController,
                  decoration: InputDecoration(labelText: l10n.port),
                  keyboardType: TextInputType.number,
                  onChanged: viewModel.updateSendPort,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _sendMessageController,
                  decoration: InputDecoration(
                    labelText: l10n.sendText,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.history),
                      onPressed: () {
                        if (udpState.sendHistory.isEmpty) return;
                        showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(100, 100, 0, 0),
                          items: udpState.sendHistory.map((h) {
                            return PopupMenuItem(
                              value: h,
                              child: Text(h),
                            );
                          }).toList(),
                        ).then((value) {
                          if (value != null) {
                            _sendMessageController.text = value;
                            viewModel.updateSendMessage(value);
                          }
                        });
                      },
                    ),
                  ),
                  onChanged: viewModel.updateSendMessage,
                ),
              ),
              Column(
                children: [
                  Text(l10n.hexMode, style: const TextStyle(fontSize: 10)),
                  SizedBox(
                    height: 44,
                    width: 44,
                    child: Center(
                      child: Switch.adaptive(
                        value: udpState.isHexMode,
                        onChanged: viewModel.updateIsHexMode,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 44,
                height: 44,
                child: IconButton(
                  onPressed: udpState.isReceiving 
                      ? () => viewModel.sendData(
                          onError: _showError,
                          hexErrorLabel: l10n.hexParseError,
                        )
                      : null,
                  icon: Icon(isIOS ? CupertinoIcons.paperplane_fill : Icons.send),
                  color: udpState.isReceiving ? Theme.of(context).colorScheme.primary : Theme.of(context).disabledColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (isIOS) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(l10n.udpCommunication),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: viewModel.clearLogs,
            child: const Icon(CupertinoIcons.delete),
          ),
        ),
        child: SafeArea(child: Material(child: content)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.udpCommunication),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: viewModel.clearLogs,
          ),
        ],
      ),
      body: !kIsWeb && Platform.isAndroid ? SingleChildScrollView(child: SizedBox(height: MediaQuery.of(context).size.height - 150, child: content)) : content,
    );
  }
}
