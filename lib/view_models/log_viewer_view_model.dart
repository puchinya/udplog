import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/log_file_state.dart';

part 'log_viewer_view_model.g.dart';

@riverpod
class LogViewerViewModel extends _$LogViewerViewModel {
  @override
  LogFileState build() {
    Future.microtask(() => refreshLogFiles());
    return const LogFileState();
  }

  Future<void> refreshLogFiles() async {
    state = state.copyWith(isLoading: true);
    try {
      final directory = await getApplicationDocumentsDirectory();
      final entities = await directory.list().toList();
      final files = entities
          .whereType<File>()
          .where((f) => p.basename(f.path).startsWith('udp_log_') && f.path.endsWith('.txt'))
          .toList();
      
      // Sort by name (which includes timestamp) descending
      files.sort((a, b) => b.path.compareTo(a.path));

      state = state.copyWith(logFiles: files, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loadFileContent(File file) async {
    try {
      final content = await file.readAsString();
      state = state.copyWith(
        fileContent: content,
        selectedFileName: p.basename(file.path),
      );
    } catch (e) {
      state = state.copyWith(fileContent: 'Error loading file: $e');
    }
  }

  Future<void> deleteFile(File file) async {
    try {
      await file.delete();
      if (state.selectedFileName == p.basename(file.path)) {
        state = state.copyWith(fileContent: '', selectedFileName: null);
      }
      await refreshLogFiles();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> deleteAllLogs() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final entities = await directory.list().toList();
      final files = entities
          .whereType<File>()
          .where((f) => p.basename(f.path).startsWith('udp_log_') && f.path.endsWith('.txt'));
      
      for (var file in files) {
        await file.delete();
      }
      state = state.copyWith(fileContent: '', selectedFileName: null);
      await refreshLogFiles();
    } catch (e) {
      // Handle error
    }
  }
}
