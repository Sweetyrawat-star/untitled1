import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:untitled1/utils/device_info.dart';
import 'package:untitled1/utils/common_ui.dart';

class CommonFileDownloader {
  static Future<void> download({
    required State state,
    required String url,
    required String fileName,
  }) async {
    final context = state.context;

    final confirm = await CommonUI.showConfirmationDialog(
      context: context,
      title: 'Download File',
      content: 'Do you want to download "$fileName"?',
    );
    if (!confirm || !state.mounted) return;

    if (io.Platform.isAndroid) {
      final sdk = await DeviceInfo.getAndroidSdkVersion();
      final permission = sdk >= 30 ? Permission.manageExternalStorage : Permission.storage;

      final currentStatus = await permission.status;

      if (currentStatus.isPermanentlyDenied) {
        final openSettings = await CommonUI.showConfirmationDialog(
          context: context,
          title: 'Permission Required',
          content: 'Storage access is permanently denied.\nOpen settings to enable it?',
          confirmText: 'Open Settings',
          cancelText: 'Cancel',
        );
        if (openSettings && state.mounted) await openAppSettings();
        return;
      }

      final result = await permission.request();
      if (!result.isGranted) {
        if (state.mounted) {
          CommonUI.showSnackBar(context: context, message: 'Storage permission denied');
        }
        return;
      }
    }

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) throw Exception('Download failed');

      final file = await _getTargetFile(fileName);
      await file.writeAsBytes(response.bodyBytes);

      if (state.mounted) {
        CommonUI.showSnackBar(context: context, message: 'File saved to: ${file.path}');
      }
    } catch (e) {
      if (state.mounted) {
        CommonUI.showSnackBar(context: context, message: 'Error: $e');
      }
    }
  }

  static Future<io.File> _getTargetFile(String fileName) async {
    if (io.Platform.isAndroid) {
      return io.File('/storage/emulated/0/Download/$fileName');
    } else if (io.Platform.isIOS) {
      const platform = MethodChannel('com.untitled/documents');
      await platform.invokeMethod('openFile', {'path': fileName});
    } else if (io.Platform.isMacOS || io.Platform.isLinux || io.Platform.isWindows) {
      final dir = await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
      return io.File('${dir.path}/$fileName');
    }
    final fallback = await getApplicationDocumentsDirectory();
    return io.File('${fallback.path}/$fileName');
  }
}
