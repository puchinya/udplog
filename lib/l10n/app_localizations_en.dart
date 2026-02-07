// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'UDPLog';

  @override
  String get tabCommunication => 'Comm';

  @override
  String get tabLog => 'Log';

  @override
  String get udpCommunication => 'UDP Comm';

  @override
  String get receivePort => 'Receive Port';

  @override
  String get connect => 'Connect';

  @override
  String get disconnect => 'Disconnect';

  @override
  String get destinationIp => 'Dest IP';

  @override
  String get port => 'Port';

  @override
  String get sendDataHex => 'Send Data (Hex: 00AA...)';

  @override
  String get sendText => 'Send Text';

  @override
  String get hexMode => 'Hex';

  @override
  String get sendHistory => 'History';

  @override
  String get sendComplete => 'Send Complete';

  @override
  String get hexParseError => 'Invalid Hex format';

  @override
  String invalidAddress(String address) {
    return 'Invalid address: $address';
  }

  @override
  String get portRangeError => 'Port must be 1-65535';

  @override
  String receiveError(String error) {
    return 'Receive Error: $error';
  }

  @override
  String get socketClosed => 'Socket closed';

  @override
  String connectionStarted(int port) {
    return '--- Connection Started (Port: $port) ---';
  }

  @override
  String logFile(String path) {
    return 'Log file: $path';
  }

  @override
  String get disconnected => '--- Disconnected ---';

  @override
  String dataProcessingError(String error) {
    return 'Data processing error: $error';
  }

  @override
  String get addressNotFound => 'Address not found';

  @override
  String get logViewer => 'Log Viewer';

  @override
  String get noLogs => 'No logs';

  @override
  String get selectLogFile => 'Select a log file';

  @override
  String file(String name) {
    return 'File: $name';
  }

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String deleteMessage(String fileName) {
    return 'Delete log file \"$fileName\"?';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String deleted(String fileName) {
    return 'Deleted: $fileName';
  }

  @override
  String deleteFailed(String error) {
    return 'Delete failed: $error';
  }

  @override
  String error(String error) {
    return 'Error: $error';
  }

  @override
  String get share => 'Share';

  @override
  String shareFailed(String error) {
    return 'Share failed: $error';
  }

  @override
  String get tabSettings => 'Settings';

  @override
  String get settings => 'Settings';

  @override
  String get fontSettings => 'Font Settings';

  @override
  String get fontSize => 'Font Size';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'Follow OS';

  @override
  String get languageEn => 'English';

  @override
  String get languageJa => 'Japanese';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System Default';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get licenses => 'Open Source Licenses';

  @override
  String version(String version) {
    return 'Version: $version';
  }
}
