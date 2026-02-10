import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../models/udp_state.dart';

part 'udp_view_model.g.dart';

@Riverpod(keepAlive: true)
class UdpViewModel extends _$UdpViewModel {
  RawDatagramSocket? _socket;
  IOSink? _logSink;

  @override
  UdpState build() {
    Future.microtask(() => _loadSettings());
    ref.onDispose(() {
      _disconnect();
    });
    return const UdpState();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = state.copyWith(
      receivePort: prefs.getString('receivePort') ?? '12345',
      sendAddress: prefs.getString('sendAddress') ?? '127.0.0.1',
      sendPort: prefs.getString('sendPort') ?? '12345',
      sendMessage: prefs.getString('sendMessage') ?? '',
      isHexMode: prefs.getBool('isHexMode') ?? false,
      sendHistory: prefs.getStringList('sendHistory') ?? [],
      initialized: true,
    );
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('receivePort', state.receivePort);
    await prefs.setString('sendAddress', state.sendAddress);
    await prefs.setString('sendPort', state.sendPort);
    await prefs.setString('sendMessage', state.sendMessage);
    await prefs.setBool('isHexMode', state.isHexMode);
    await prefs.setStringList('sendHistory', state.sendHistory);
  }

  void updateReceivePort(String value) {
    state = state.copyWith(receivePort: value);
    _saveSettings();
  }

  void updateSendAddress(String value) {
    state = state.copyWith(sendAddress: value);
    _saveSettings();
  }

  void updateSendPort(String value) {
    state = state.copyWith(sendPort: value);
    _saveSettings();
  }

  void updateSendMessage(String value) {
    state = state.copyWith(sendMessage: value);
    _saveSettings();
  }

  void updateIsHexMode(bool value) {
    state = state.copyWith(isHexMode: value);
    _saveSettings();
  }

  Future<void> toggleConnection({bool preventSleep = true, Function(String)? onError}) async {
    if (state.isReceiving) {
      _disconnect();
    } else {
      await _connect(preventSleep: preventSleep, onError: onError);
    }
  }

  Future<void> _connect({bool preventSleep = true, Function(String)? onError}) async {
    final port = int.tryParse(state.receivePort);
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
        if (onError != null) onError(e.toString());
        _disconnect();
      }, onDone: () {
        if (state.isReceiving) {
          _disconnect();
        }
      });

      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final logFileName = 'udp_log_$timestamp.txt';
      final logFile = File(p.join(directory.path, logFileName));
      _logSink = logFile.openWrite();
      
      final timeStr = DateFormat('HH:mm:ss.SSS').format(DateTime.now());
      final connectionMsg = '--- Connection Started (Port: $port) ---';
      _logSink?.writeln('[$timeStr] $connectionMsg');

      final logFileMsgFile = 'Log file: $logFileName';
      _logSink?.writeln('[$timeStr] $logFileMsgFile');

      if (preventSleep) {
        WakelockPlus.enable();
      }

      final now = DateTime.now();
      state = state.copyWith(
        isReceiving: true,
        currentLogPath: logFile.path,
        logs: [
          ...state.logs,
          UdpMessage(
            timestamp: now,
            address: '',
            port: 0,
            message: connectionMsg,
            systemMessageKey: 'connectionStarted',
            systemMessageArgs: port.toString(),
            isSystem: true,
          ),
          UdpMessage(
            timestamp: now,
            address: '',
            port: 0,
            message: logFileMsgFile,
            systemMessageKey: 'logFile',
            systemMessageArgs: logFileName,
            isSystem: true,
          ),
        ],
      );
    } catch (e) {
      if (onError != null) onError(e.toString());
    }
  }

  void _disconnect() {
    _socket?.close();
    _socket = null;
    if (_logSink != null) {
      final now = DateTime.now();
      final timeStr = DateFormat('HH:mm:ss.SSS').format(now);
      const disconnectMsg = '--- Disconnected ---';
      _logSink?.writeln('[$timeStr] $disconnectMsg');
      _logSink?.close();
      _logSink = null;
      
      state = state.copyWith(
        isReceiving: false,
        logs: [
          ...state.logs,
          UdpMessage(
            timestamp: now,
            address: '',
            port: 0,
            message: disconnectMsg,
            systemMessageKey: 'disconnected',
            isSystem: true,
          ),
        ],
      );
    } else {
      state = state.copyWith(isReceiving: false);
    }
    WakelockPlus.disable();
  }

  void _processReceivedData(String address, int port, Uint8List data) {
    String message;
    if (state.isHexMode) {
      message = data.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ');
    } else {
      message = utf8.decode(data, allowMalformed: true);
    }

    final now = DateTime.now();
    final logEntry = UdpMessage(
      timestamp: now,
      address: address,
      port: port,
      message: message,
    );

    final timeStr = DateFormat('HH:mm:ss.SSS').format(now);
    final logLine = '[$timeStr] $address:$port -> $message';
    _logSink?.writeln(logLine);

    state = state.copyWith(
      logs: [...state.logs, logEntry],
    );
  }

  Future<void> sendData({Function(String)? onError, String? hexErrorLabel}) async {
    if (_socket == null) return;
    final address = state.sendAddress;
    final port = int.tryParse(state.sendPort);
    final message = state.sendMessage;
    if (port == null || message.isEmpty) return;

    try {
      Uint8List data;
      if (state.isHexMode) {
        // Remove spaces and parse hex
        final hexString = message.replaceAll(' ', '');
        if (hexString.isEmpty || hexString.length % 2 != 0) {
          if (onError != null) onError(hexErrorLabel ?? 'Invalid hex format');
          return;
        }
        final bytes = <int>[];
        try {
          for (int i = 0; i < hexString.length; i += 2) {
            bytes.add(int.parse(hexString.substring(i, i + 2), radix: 16));
          }
        } catch (e) {
          if (onError != null) onError(hexErrorLabel ?? 'Invalid hex format');
          return;
        }
        data = Uint8List.fromList(bytes);
      } else {
        data = utf8.encode(message);
      }

      // Resolve address
      InternetAddress? targetAddress;
      try {
        final addresses = await InternetAddress.lookup(address);
        if (addresses.isNotEmpty) {
          targetAddress = addresses.first;
        }
      } catch (e) {
        if (onError != null) onError(e.toString());
        return;
      }

      if (targetAddress == null) {
        if (onError != null) onError('Address not found');
        return;
      }

      _socket!.send(data, targetAddress, port);

      final now = DateTime.now();
      final logEntry = UdpMessage(
        timestamp: now,
        address: address,
        port: port,
        message: message,
        isOutgoing: true,
      );

      final timeStr = DateFormat('HH:mm:ss.SSS').format(now);
      final logLine = '[$timeStr] OUT -> $address:$port: $message';
      _logSink?.writeln(logLine);

      List<String> newHistory = List.from(state.sendHistory);
      if (!newHistory.contains(message)) {
        newHistory.insert(0, message);
        if (newHistory.length > 20) newHistory.removeLast();
      }

      state = state.copyWith(
        logs: [...state.logs, logEntry],
        sendHistory: newHistory,
      );
      _saveSettings();
    } catch (e) {
      if (onError != null) onError(e.toString());
    }
  }

  void clearLogs() {
    state = state.copyWith(logs: []);
  }
}
