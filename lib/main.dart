import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UDP Log App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainNavigationPage(),
    );
  }
}

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    UdpCommunicationPage(),
    LogViewerPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: '通信'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'ログ'),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
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
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('receivePort', _receivePortController.text);
    await prefs.setString('sendAddress', _sendAddressController.text);
    await prefs.setString('sendPort', _sendPortController.text);
    await prefs.setString('sendMessage', _sendMessageController.text);
    await prefs.setBool('isHexMode', _isHexMode);
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
          setState(() {
            _receivedLogs.add('受信エラー: $e');
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('受信エラー: $e')));
        }
      }, onDone: () {
        if (mounted && _isReceiving) {
          _disconnect();
          setState(() {
            _receivedLogs.add('ソケットが閉じられました');
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
        _receivedLogs.add('--- 接続開始 (ポート: $port) ---');
        _receivedLogs.add('ログファイル: ${logFile.path}');
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
        _receivedLogs.add('--- 切断 ---');
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
          _receivedLogs.add('データ処理エラー: $e');
        });
      }
    }
  }

  Future<void> _sendData() async {
    if (!_isReceiving || _socket == null) return;

    final address = _sendAddressController.text;
    final port = int.tryParse(_sendPortController.text);
    if (port == null) return;

    List<int> dataToSend;
    if (_isHexMode) {
      try {
        final hexStr = _sendMessageController.text.replaceAll(RegExp(r'\s+'), '');
        dataToSend = [];
        for (int i = 0; i < hexStr.length; i += 2) {
          dataToSend.add(int.parse(hexStr.substring(i, i + 2), radix: 16));
        }
      } catch (e) {
        debugPrint('16進数パースエラー: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('16進数形式が正しくありません')));
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
          throw Exception('アドレスが見つかりません');
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('宛先アドレス不正: $address')));
        }
        return;
      }

      // ポート番号のバリデーション
      if (port < 1 || port > 65535) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ポート番号は1-65535の間で指定してください')));
        }
        return;
      }

      _socket!.send(dataToSend, destAddress, port);
      debugPrint('UDP送信成功: $destAddress:$port');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('送信完了'), duration: Duration(seconds: 1)));
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
    return Scaffold(
      appBar: AppBar(title: const Text('UDP 通信')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _receivePortController,
                    decoration: const InputDecoration(labelText: '受信ポート'),
                    keyboardType: TextInputType.number,
                    enabled: !_isReceiving,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _isReceiving ? _disconnect : _connect,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isReceiving ? Colors.red.shade100 : Colors.green.shade100,
                  ),
                  child: Text(_isReceiving ? '切断' : '接続'),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
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
                        style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
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
                    decoration: const InputDecoration(labelText: '宛先IP'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _sendPortController,
                    decoration: const InputDecoration(labelText: 'ポート'),
                    keyboardType: TextInputType.number,
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
                      labelText: _isHexMode ? '送信データ (16進数: 00AA...)' : '送信テキスト',
                    ),
                  ),
                ),
                Column(
                  children: [
                    const Text('16進数', style: TextStyle(fontSize: 10)),
                    Switch(
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
                  color: _isReceiving ? Colors.blue : Colors.grey,
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
    _refreshLogFiles();
  }

  Future<void> _refreshLogFiles() async {
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
        _fileContent = 'エラー: $e';
      });
    }
  }

  Future<void> _deleteLogFile(File file) async {
    final fileName = p.basename(file.path);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('削除の確認'),
        content: Text('ログファイル「$fileName」を削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('削除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await file.delete();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('削除しました: $fileName')),
          );
          if (_selectedFileName == fileName) {
            setState(() {
              _selectedFileName = null;
              _fileContent = 'ログファイルを選択してください';
            });
          }
          await _refreshLogFiles();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('削除失敗: $e')),
          );
        }
      }
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
        _fileContent = 'エラー: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ログ表示'),
        actions: [
          IconButton(
            onPressed: _refreshLogFiles,
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
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: Colors.grey)),
            ),
            child: _logFiles.isEmpty
                ? const Center(child: Text('ログなし', style: TextStyle(fontSize: 12)))
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
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, size: 16, color: Colors.grey),
                          onPressed: () => _deleteLogFile(file),
                        ),
                        selected: isSelected,
                        dense: true,
                        onTap: () => _loadLogFile(file),
                      );
                    },
                  ),
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
                      child: Text('ファイル: $_selectedFileName', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          _fileContent,
                          style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
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
