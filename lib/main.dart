import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:udplog/l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const MainNavigationPage(),
    );
  }
}

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class SettingsProvider extends InheritedWidget {
  final double fontSize;
  final _MainNavigationPageState state;

  const SettingsProvider({
    super.key,
    required this.fontSize,
    required this.state,
    required super.child,
  });

  static _MainNavigationPageState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SettingsProvider>()?.state;
  }

  @override
  bool updateShouldNotify(SettingsProvider oldWidget) {
    return fontSize != oldWidget.fontSize;
  }
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;
  final GlobalKey<_LogViewerPageState> _logViewerKey = GlobalKey<_LogViewerPageState>();

  double _fontSize = 12.0;

  @override
  void initState() {
    super.initState();
    _loadFontSettings();
  }

  Future<void> _loadFontSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fontSize = prefs.getDouble('fontSize') ?? 12.0;
    });
  }

  Future<void> updateFontSettings(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', size);
    setState(() {
      _fontSize = size;
    });
  }

  double get fontSize => _fontSize;

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      _logViewerKey.currentState?.refreshLogFiles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingsProvider(
      fontSize: _fontSize,
      state: this,
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            const UdpCommunicationPage(),
            LogViewerPage(key: _logViewerKey),
            const SettingsPage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: const Icon(Icons.swap_horiz), label: AppLocalizations.of(context)!.tabCommunication),
            BottomNavigationBarItem(icon: const Icon(Icons.history), label: AppLocalizations.of(context)!.tabLog),
            BottomNavigationBarItem(icon: const Icon(Icons.settings), label: AppLocalizations.of(context)!.tabSettings),
          ],
          currentIndex: _selectedIndex,
          onTap: _onTabTapped,
        ),
      ),
    );
  }
}

class UdpCommunicationPage extends StatefulWidget {
  const UdpCommunicationPage({super.key});

  @override
  State<UdpCommunicationPage> createState() => _UdpCommunicationPageState();
}

class _UdpCommunicationPageState extends State<UdpCommunicationPage> {
  final TextEditingController _receivePortController = TextEditingController(text: '12345');
  final TextEditingController _sendAddressController = TextEditingController(text: '127.0.0.1');
  final TextEditingController _sendPortController = TextEditingController(text: '12345');
  final TextEditingController _sendMessageController = TextEditingController();
  final List<String> _receivedLogs = [];
  List<String> _sendHistory = [];
  final ScrollController _scrollController = ScrollController();

  RawDatagramSocket? _socket;
  bool _isReceiving = false;
  IOSink? _logSink;
  String? _currentLogPath;

  bool _isHexMode = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _receivePortController.text = prefs.getString('receivePort') ?? '12345';
      _sendAddressController.text = prefs.getString('sendAddress') ?? '127.0.0.1';
      _sendPortController.text = prefs.getString('sendPort') ?? '12345';
      _sendMessageController.text = prefs.getString('sendMessage') ?? '';
      _isHexMode = prefs.getBool('isHexMode') ?? false;
      _sendHistory = prefs.getStringList('sendHistory') ?? [];
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('receivePort', _receivePortController.text);
    await prefs.setString('sendAddress', _sendAddressController.text);
    await prefs.setString('sendPort', _sendPortController.text);
    await prefs.setString('sendMessage', _sendMessageController.text);
    await prefs.setBool('isHexMode', _isHexMode);
    await prefs.setStringList('sendHistory', _sendHistory);
  }

  @override
  void dispose() {
    _disconnect();
    _receivePortController.dispose();
    _sendAddressController.dispose();
    _sendPortController.dispose();
    _sendMessageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _connect() async {
    final port = int.tryParse(_receivePortController.text);
    if (port == null) return;

    await _saveSettings();

    try {
      _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
      _socket!.broadcastEnabled = true;
      _socket!.listen((RawSocketEvent event) {
        if (event == RawSocketEvent.read) {
          final datagram = _socket!.receive();
          if (datagram != null) {
            _processReceivedData(datagram.address.address, datagram.port, datagram.data);
          }
        }
      }, onError: (e) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          setState(() {
            _receivedLogs.add(l10n.receiveError(e.toString()));
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.receiveError(e.toString()))));
        }
      }, onDone: () {
        if (mounted && _isReceiving) {
          _disconnect();
          setState(() {
            _receivedLogs.add(AppLocalizations.of(context)!.socketClosed);
          });
        }
      });

      // ログファイル作成
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final logFileName = 'udp_log_$timestamp.txt';
      final logFile = File(p.join(directory.path, logFileName));
      _logSink = logFile.openWrite();
      _currentLogPath = logFile.path;

      setState(() {
        _isReceiving = true;
        final l10n = AppLocalizations.of(context)!;
        _receivedLogs.add(l10n.connectionStarted(port));
        _receivedLogs.add(l10n.logFile(logFile.path));
      });
    } catch (e) {
      debugPrint('接続エラー: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('接続エラー: $e')));
      }
    }
  }

  void _disconnect() {
    _socket?.close();
    _socket = null;
    _logSink?.close();
    _logSink = null;
    _isReceiving = false;
    if (mounted && _currentLogPath != null) {
      setState(() {
        _receivedLogs.add(AppLocalizations.of(context)!.disconnected);
      });
    }
  }

  void _processReceivedData(String address, int port, Uint8List data) {
    try {
      final now = DateTime.now();
      final timeStr = DateFormat('HH:mm:ss.SSS').format(now);
      
      // 表示用文字列作成
      final buffer = StringBuffer();
      for (var byte in data) {
        if (byte >= 32 && byte <= 126) {
          buffer.write(String.fromCharCode(byte));
        } else {
          buffer.write('\$${byte.toRadixString(16).padLeft(2, '0').toUpperCase()}');
        }
      }
      final displayStr = buffer.toString();
      final logEntry = '[$timeStr] $address:$port > $displayStr';

      _logSink?.writeln(logEntry);

      if (mounted) {
        setState(() {
          _receivedLogs.add(logEntry);
        });

        // 自動スクロール
        Timer(const Duration(milliseconds: 100), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          }
        });
      }
    } catch (e) {
      debugPrint('データ処理エラー: $e');
      if (mounted) {
        setState(() {
          _receivedLogs.add(AppLocalizations.of(context)!.dataProcessingError(e.toString()));
        });
      }
    }
  }

  Future<void> _sendData() async {
    if (!_isReceiving || _socket == null) return;

    final address = _sendAddressController.text;
    final port = int.tryParse(_sendPortController.text);
    final message = _sendMessageController.text;
    if (port == null) return;

    // 履歴に追加 (重複を避け、最新を上にする)
    if (message.isNotEmpty) {
      _sendHistory.remove(message);
      _sendHistory.insert(0, message);
      if (_sendHistory.length > 20) {
        _sendHistory = _sendHistory.sublist(0, 20);
      }
    }

    List<int> dataToSend;
    if (_isHexMode) {
      try {
        final hexStr = message.replaceAll(RegExp(r'\s+'), '');
        dataToSend = [];
        for (int i = 0; i < hexStr.length; i += 2) {
          dataToSend.add(int.parse(hexStr.substring(i, i + 2), radix: 16));
        }
      } catch (e) {
        debugPrint('16進数パースエラー: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.hexParseError)));
        }
        return;
      }
    } else {
      dataToSend = utf8.encode(_sendMessageController.text);
    }

    await _saveSettings();

    try {
      // 宛先アドレスの解決（ホスト名対応）
      InternetAddress destAddress;
      try {
        final addresses = await InternetAddress.lookup(address);
        if (addresses.isEmpty) {
          throw Exception(AppLocalizations.of(context)!.addressNotFound);
        }
        // ソケットがIPv4でバインドされているため、可能であればIPv4アドレスを優先する
        destAddress = addresses.firstWhere(
          (a) => a.type == InternetAddressType.IPv4,
          orElse: () => addresses.first,
        );
        debugPrint('送信先解決: $address -> $destAddress');
      } catch (e) {
        debugPrint('宛先アドレス解決エラー: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.invalidAddress(address))));
        }
        return;
      }

      // ポート番号のバリデーション
      if (port < 1 || port > 65535) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.portRangeError)));
        }
        return;
      }

      _socket!.send(dataToSend, destAddress, port);
      debugPrint('UDP送信成功: $destAddress:$port');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.sendComplete), duration: const Duration(seconds: 1)));
      }
    } catch (e, st) {
      debugPrint('送信エラー: $e');
      debugPrint('スタックトレース: $st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('送信エラー: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final navState = SettingsProvider.of(context);
    final logStyle = TextStyle(
      fontFamily: 'monospace',
      fontSize: navState?.fontSize ?? 12,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.udpCommunication),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _receivePortController,
                    decoration: InputDecoration(labelText: l10n.receivePort),
                    keyboardType: TextInputType.number,
                    enabled: !_isReceiving,
                    style: logStyle,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _isReceiving ? _disconnect : _connect,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isReceiving 
                        ? (Theme.of(context).brightness == Brightness.dark ? Colors.red.shade900 : Colors.red.shade100)
                        : (Theme.of(context).brightness == Brightness.dark ? Colors.green.shade900 : Colors.green.shade100),
                    foregroundColor: _isReceiving
                        ? (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.red.shade900)
                        : (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.green.shade900),
                  ),
                  child: Text(_isReceiving ? l10n.disconnect : l10n.connect),
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
                  itemCount: _receivedLogs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                      child: Text(
                        _receivedLogs[index],
                        style: logStyle,
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
                  flex: 2,
                  child: TextField(
                    controller: _sendAddressController,
                    decoration: InputDecoration(labelText: l10n.destinationIp),
                    style: logStyle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _sendPortController,
                    decoration: InputDecoration(labelText: l10n.port),
                    keyboardType: TextInputType.number,
                    style: logStyle,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _sendMessageController,
                    style: logStyle,
                    decoration: InputDecoration(
                      labelText: _isHexMode ? l10n.sendDataHex : l10n.sendText,
                      suffixIcon: _sendHistory.isEmpty
                          ? null
                          : PopupMenuButton<String>(
                              icon: const Icon(Icons.history, size: 20),
                              tooltip: l10n.sendHistory,
                              onSelected: (String value) {
                                setState(() {
                                  _sendMessageController.text = value;
                                });
                              },
                              itemBuilder: (BuildContext context) {
                                return _sendHistory.map((String choice) {
                                  return PopupMenuItem<String>(
                                    value: choice,
                                    child: Text(
                                      choice,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(l10n.hexMode, style: const TextStyle(fontSize: 10)),
                    Switch.adaptive(
                      value: _isHexMode,
                      onChanged: (val) {
                        setState(() => _isHexMode = val);
                        _saveSettings();
                      },
                    ),
                  ],
                ),
                IconButton(
                  onPressed: _isReceiving ? _sendData : null,
                  icon: const Icon(Icons.send),
                  color: _isReceiving ? Theme.of(context).colorScheme.primary : Theme.of(context).disabledColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LogViewerPage extends StatefulWidget {
  const LogViewerPage({super.key});

  @override
  State<LogViewerPage> createState() => _LogViewerPageState();
}

class _LogViewerPageState extends State<LogViewerPage> {
  String _fileContent = 'ログファイルを選択してください';
  String? _selectedFileName;
  List<File> _logFiles = [];

  @override
  void initState() {
    super.initState();
    refreshLogFiles();
  }

  Future<void> refreshLogFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final entities = await directory.list().toList();
      final files = entities
          .whereType<File>()
          .where((f) => p.basename(f.path).startsWith('udp_log_') && f.path.endsWith('.txt'))
          .toList();
      
      // 新しい順にソート
      files.sort((a, b) => b.path.compareTo(a.path));

      setState(() {
        _logFiles = files;
      });
    } catch (e) {
      debugPrint('ログファイル一覧取得エラー: $e');
    }
  }

  Future<void> _loadLogFile(File file) async {
    try {
      final content = await file.readAsString();
      setState(() {
        _selectedFileName = p.basename(file.path);
        _fileContent = content;
      });
    } catch (e) {
      setState(() {
        _fileContent = AppLocalizations.of(context)!.error(e.toString());
      });
    }
  }

  Future<void> _deleteLogFile(File file) async {
    final l10n = AppLocalizations.of(context)!;
    final fileName = p.basename(file.path);
    final confirmed = await (Platform.isIOS || Platform.isMacOS
        ? showCupertinoDialog<bool>(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: Text(l10n.confirmDelete),
              content: Text(l10n.deleteMessage(fileName)),
              actions: [
                CupertinoDialogAction(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(l10n.cancel),
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(l10n.delete),
                ),
              ],
            ),
          )
        : showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(l10n.confirmDelete),
              content: Text(l10n.deleteMessage(fileName)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(l10n.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: Text(l10n.delete),
                ),
              ],
            ),
          ));

    if (confirmed == true) {
      try {
        await file.delete();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.deleted(fileName))),
          );
          if (_selectedFileName == fileName) {
            setState(() {
              _selectedFileName = null;
              _fileContent = l10n.selectLogFile;
            });
          }
          await refreshLogFiles();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.deleteFailed(e.toString()))),
          );
        }
      }
    }
  }

  Future<void> _shareLogFile(File file) async {
    try {
      await Share.shareXFiles([XFile(file.path)]);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.shareFailed(e.toString()))),
      );
    }
  }

  Future<void> _pickAndLoadFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        initialDirectory: directory.path,
        type: FileType.any,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        await _loadLogFile(file);
      }
    } catch (e) {
      setState(() {
        _fileContent = AppLocalizations.of(context)!.error(e.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final navState = SettingsProvider.of(context);
    final logStyle = TextStyle(
      fontFamily: 'monospace',
      fontSize: navState?.fontSize ?? 12,
    );

    final isMobile = Platform.isAndroid || Platform.isIOS;

    final fileList = _logFiles.isEmpty
        ? Center(child: Text(l10n.noLogs, style: const TextStyle(fontSize: 12)))
        : ListView.builder(
            itemCount: _logFiles.length,
            itemBuilder: (context, index) {
              final file = _logFiles[index];
              final fileName = p.basename(file.path);
              final isSelected = fileName == _selectedFileName;
              return ListTile(
                title: Text(
                  fileName.replaceFirst('udp_log_', '').replaceFirst('.txt', ''),
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.share, size: 16, color: Theme.of(context).disabledColor),
                      onPressed: () => _shareLogFile(file),
                      tooltip: l10n.share,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, size: 16, color: Theme.of(context).disabledColor),
                      onPressed: () => _deleteLogFile(file),
                      tooltip: l10n.delete,
                    ),
                  ],
                ),
                selected: isSelected,
                dense: true,
                onTap: () {
                  if (isMobile) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LogDetailPage(file: file),
                      ),
                    );
                  } else {
                    _loadLogFile(file);
                  }
                },
              );
            },
          );

    if (isMobile) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.logViewer),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: refreshLogFiles,
              icon: const Icon(Icons.refresh),
            ),
            IconButton(
              onPressed: _pickAndLoadFile,
              icon: const Icon(Icons.file_open),
            ),
          ],
        ),
        body: fileList,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.logViewer),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: refreshLogFiles,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: _pickAndLoadFile,
            icon: const Icon(Icons.file_open),
          ),
        ],
      ),
      body: Row(
        children: [
          // 左側：ファイルリスト
          Container(
            width: 200,
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: Theme.of(context).dividerColor)),
            ),
            child: fileList,
          ),
          // 右側：ログ内容
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_selectedFileName != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(l10n.file(_selectedFileName!), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).dividerColor),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          _fileContent,
                          style: logStyle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LogDetailPage extends StatelessWidget {
  final File file;
  const LogDetailPage({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final navState = SettingsProvider.of(context);
    final logStyle = TextStyle(
      fontFamily: 'monospace',
      fontSize: navState?.fontSize ?? 12,
    );
    final fileName = p.basename(file.path);

    return Scaffold(
      appBar: AppBar(
        title: Text(fileName.replaceFirst('udp_log_', '').replaceFirst('.txt', '')),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => Share.shareXFiles([XFile(file.path)]),
            tooltip: l10n.share,
          ),
        ],
      ),
      body: FutureBuilder<String>(
        future: file.readAsString(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(l10n.error(snapshot.error.toString())));
          }
          return Padding(
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
                  snapshot.data ?? '',
                  style: logStyle,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = info.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final navState = SettingsProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        centerTitle: true,
      ),
      body: ListView(
        children: [
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
                        value: navState?.fontSize ?? 12,
                        min: 8,
                        max: 24,
                        divisions: 16,
                        label: navState?.fontSize.round().toString(),
                        onChanged: (double value) {
                          if (navState != null) {
                            setState(() {
                              navState.updateFontSettings(value);
                            });
                          }
                        },
                      ),
                    ),
                    Text(navState?.fontSize.round().toString() ?? '12'),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.licenses),
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: l10n.appTitle,
                applicationVersion: _version,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.verified_user_outlined),
            title: Text(l10n.version(_version)),
          ),
        ],
      ),
    );
  }
}
