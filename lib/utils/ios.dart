

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SaveIosDownloadFile {
  static const platform = MethodChannel('com.yourapp/documents');

  Future<void> saveToDownloads(String path, String filename) async {
    try {
      await platform.invokeMethod('saveToDownloads', {
        'path': path,
        'filename': filename,
      });
    } on PlatformException catch (e) {
      if (kDebugMode) {
          print(" Error: ${e.message}");

      }
    }
  }
}
