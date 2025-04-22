// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class CommonFileDownloader {
  static Future<void> download({
    required String url,
    required String fileName,
  }) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('Failed to download file: ${response.statusCode}');
      }

      final Uint8List bytes = response.bodyBytes;

      // Create a blob and generate an object URL
      final blob = html.Blob([bytes]);
      final blobUrl = html.Url.createObjectUrlFromBlob(blob);

      // Create and configure the anchor element for downloading
      final anchor = html.AnchorElement(href: blobUrl)
        ..download = fileName
        ..style.display = 'none';

      html.document.body!.append(anchor);
      anchor.click();

      // Clean up
      anchor.remove();
      html.Url.revokeObjectUrl(blobUrl);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('Download error: $e\n$stackTrace');
      }
    }
  }
}
