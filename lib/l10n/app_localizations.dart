import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'UDPLog'**
  String get appTitle;

  /// No description provided for @tabCommunication.
  ///
  /// In en, this message translates to:
  /// **'Comm'**
  String get tabCommunication;

  /// No description provided for @tabLog.
  ///
  /// In en, this message translates to:
  /// **'Log'**
  String get tabLog;

  /// No description provided for @udpCommunication.
  ///
  /// In en, this message translates to:
  /// **'UDP Comm'**
  String get udpCommunication;

  /// No description provided for @receivePort.
  ///
  /// In en, this message translates to:
  /// **'Receive Port'**
  String get receivePort;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @disconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// No description provided for @destinationIp.
  ///
  /// In en, this message translates to:
  /// **'Dest IP'**
  String get destinationIp;

  /// No description provided for @port.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get port;

  /// No description provided for @sendDataHex.
  ///
  /// In en, this message translates to:
  /// **'Send Data (Hex: 00AA...)'**
  String get sendDataHex;

  /// No description provided for @sendText.
  ///
  /// In en, this message translates to:
  /// **'Send Text'**
  String get sendText;

  /// No description provided for @hexMode.
  ///
  /// In en, this message translates to:
  /// **'Hex'**
  String get hexMode;

  /// No description provided for @sendHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get sendHistory;

  /// No description provided for @sendComplete.
  ///
  /// In en, this message translates to:
  /// **'Send Complete'**
  String get sendComplete;

  /// No description provided for @hexParseError.
  ///
  /// In en, this message translates to:
  /// **'Invalid Hex format'**
  String get hexParseError;

  /// No description provided for @invalidAddress.
  ///
  /// In en, this message translates to:
  /// **'Invalid address: {address}'**
  String invalidAddress(String address);

  /// No description provided for @portRangeError.
  ///
  /// In en, this message translates to:
  /// **'Port must be 1-65535'**
  String get portRangeError;

  /// No description provided for @receiveError.
  ///
  /// In en, this message translates to:
  /// **'Receive Error: {error}'**
  String receiveError(String error);

  /// No description provided for @socketClosed.
  ///
  /// In en, this message translates to:
  /// **'Socket closed'**
  String get socketClosed;

  /// No description provided for @connectionStarted.
  ///
  /// In en, this message translates to:
  /// **'--- Connection Started (Port: {port}) ---'**
  String connectionStarted(int port);

  /// No description provided for @logFile.
  ///
  /// In en, this message translates to:
  /// **'Log file: {path}'**
  String logFile(String path);

  /// No description provided for @disconnected.
  ///
  /// In en, this message translates to:
  /// **'--- Disconnected ---'**
  String get disconnected;

  /// No description provided for @dataProcessingError.
  ///
  /// In en, this message translates to:
  /// **'Data processing error: {error}'**
  String dataProcessingError(String error);

  /// No description provided for @addressNotFound.
  ///
  /// In en, this message translates to:
  /// **'Address not found'**
  String get addressNotFound;

  /// No description provided for @logViewer.
  ///
  /// In en, this message translates to:
  /// **'Log Viewer'**
  String get logViewer;

  /// No description provided for @noLogs.
  ///
  /// In en, this message translates to:
  /// **'No logs'**
  String get noLogs;

  /// No description provided for @selectLogFile.
  ///
  /// In en, this message translates to:
  /// **'Select a log file'**
  String get selectLogFile;

  /// No description provided for @file.
  ///
  /// In en, this message translates to:
  /// **'File: {name}'**
  String file(String name);

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @deleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete log file \"{fileName}\"?'**
  String deleteMessage(String fileName);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteAllLogsConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all log files?'**
  String get deleteAllLogsConfirm;

  /// No description provided for @deleteFileConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this log file?'**
  String get deleteFileConfirm;

  /// No description provided for @deleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted: {fileName}'**
  String deleted(String fileName);

  /// No description provided for @deleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Delete failed: {error}'**
  String deleteFailed(String error);

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String error(String error);

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @shareFailed.
  ///
  /// In en, this message translates to:
  /// **'Share failed: {error}'**
  String shareFailed(String error);

  /// No description provided for @tabSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get tabSettings;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get fontSize;

  /// No description provided for @communicationWindow.
  ///
  /// In en, this message translates to:
  /// **'Communication Window'**
  String get communicationWindow;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow OS'**
  String get languageSystem;

  /// No description provided for @languageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @languageJa.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get languageJa;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @preventSleepDuringUdp.
  ///
  /// In en, this message translates to:
  /// **'Prevent sleep during UDP reception'**
  String get preventSleepDuringUdp;

  /// No description provided for @licenses.
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get licenses;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version: {version}'**
  String version(String version);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
