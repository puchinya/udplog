import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'log_file_state.freezed.dart';

@freezed
class LogFileState with _$LogFileState {
  const factory LogFileState({
    @Default([]) List<File> logFiles,
    @Default('') String fileContent,
    String? selectedFileName,
    @Default(false) bool isLoading,
  }) = _LogFileState;
}
