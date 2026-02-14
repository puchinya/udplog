// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'UDPLog';

  @override
  String get tabCommunication => '通信';

  @override
  String get tabLog => 'ログ';

  @override
  String get udpCommunication => 'UDP 通信';

  @override
  String get receivePort => '受信ポート';

  @override
  String get connect => '接続';

  @override
  String get disconnect => '切断';

  @override
  String get destinationIp => '宛先IP';

  @override
  String get port => 'ポート';

  @override
  String get sendDataHex => '送信データ (16進数: 00AA...)';

  @override
  String get sendText => '送信テキスト';

  @override
  String get hexMode => '16進数';

  @override
  String get sendHistory => '送信履歴';

  @override
  String get sendComplete => '送信完了';

  @override
  String get hexParseError => '16進数形式が正しくありません';

  @override
  String invalidAddress(String address) {
    return '宛先アドレス不正: $address';
  }

  @override
  String get portRangeError => 'ポート番号は1-65535の間で指定してください';

  @override
  String receiveError(String error) {
    return '受信エラー: $error';
  }

  @override
  String get socketClosed => 'ソケットが閉じられました';

  @override
  String connectionStarted(int port) {
    return '--- 接続開始 (ポート: $port) ---';
  }

  @override
  String logFile(String path) {
    return 'ログファイル: $path';
  }

  @override
  String get disconnected => '--- 切断 ---';

  @override
  String dataProcessingError(String error) {
    return 'データ処理エラー: $error';
  }

  @override
  String get addressNotFound => 'アドレスが見つかりません';

  @override
  String get logViewer => 'ログ表示';

  @override
  String get noLogs => 'ログなし';

  @override
  String get selectLogFile => 'ログファイルを選択してください';

  @override
  String file(String name) {
    return 'ファイル: $name';
  }

  @override
  String get confirmDelete => '削除の確認';

  @override
  String deleteMessage(String fileName) {
    return 'ログファイル「$fileName」を削除しますか？';
  }

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除';

  @override
  String get deleteAllLogsConfirm => 'すべてのログファイルを削除しますか？';

  @override
  String get deleteFileConfirm => 'このログファイルを削除しますか？';

  @override
  String deleted(String fileName) {
    return '削除しました: $fileName';
  }

  @override
  String deleteFailed(String error) {
    return '削除失敗: $error';
  }

  @override
  String error(String error) {
    return 'エラー: $error';
  }

  @override
  String get share => '共有';

  @override
  String shareFailed(String error) {
    return '共有失敗: $error';
  }

  @override
  String get showInFinder => 'Finderで表示';

  @override
  String get tabSettings => '設定';

  @override
  String get settings => '設定';

  @override
  String get fontSize => 'フォントサイズ';

  @override
  String get communicationWindow => '通信ウィンドウ';

  @override
  String get language => '言語';

  @override
  String get languageSystem => 'OSの設定に従う';

  @override
  String get languageEn => 'English';

  @override
  String get languageJa => '日本語';

  @override
  String get theme => 'テーマ';

  @override
  String get themeSystem => 'OSの設定に従う';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeDark => 'ダーク';

  @override
  String get preventSleepDuringUdp => 'UDP受信中の端末のスリープ禁止';

  @override
  String get demoServer => 'デモサーバー';

  @override
  String get demoServerPort => 'デモサーバーポート';

  @override
  String get done => '完了';

  @override
  String get licenses => 'オープンソースライセンス';

  @override
  String version(String version) {
    return 'バージョン: $version';
  }
}
