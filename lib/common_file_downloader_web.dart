// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CommonFileDownloader {
  static Future<void> download({
    required String url,
    required String fileName,
    required State state,
  }) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) throw Exception('Failed to download');

      Uint8List bytes = response.bodyBytes;
      final blob = html.Blob([bytes]);
      final blobUrl = html.Url.createObjectUrlFromBlob(blob);

      final anchor = html.AnchorElement(href: blobUrl)
        ..setAttribute('download', fileName)
        ..style.display = 'none';

      html.document.body!.append(anchor);
      anchor.click();
      anchor.remove();
      html.Url.revokeObjectUrl(blobUrl);
    } catch (e) {
      if (kDebugMode) {
        print('Download error: $e');
      }
    }
  }
}

