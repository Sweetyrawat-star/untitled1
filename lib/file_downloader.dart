import 'package:flutter/material.dart';
import 'common_file_downloader.dart';

class FileDownloaderScreen extends StatefulWidget {
  const FileDownloaderScreen({super.key});

  @override
  _FileDownloaderScreenState createState() => _FileDownloaderScreenState();
}

class _FileDownloaderScreenState extends State<FileDownloaderScreen> {
  final Map<String, String> fileTypeUrls = {
    'PDF':
        'https://worksheetspack.com/wp-content/uploads/2022/02/A-to-Z-Alphabet-Spelling-Free-PDF_compressed.pdf',
    'Excel':
        'https://www.exceldemy.com/wp-content/uploads/2022/08/Sample-Employee-Data.xlsx',
    'Text': 'https://www.w3.org/TR/2003/REC-PNG-20031110/iso_8859-1.txt',
    'Image':
        'https://images.rawpixel.com/image_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIzLTAzL3JtNTk3ZGVzaWduLWMtc2F2ZS0wMDIuanBn.jpg',
  };

  String getFileName(String filePath) {
    try {
      final name = filePath.split('/').last;
      final parts = name.split('.');
      if (parts.length >= 2) {
        final fileNameWithoutExt = parts.sublist(0, parts.length - 1).join('.');
        final ext = parts.last;
        return '$fileNameWithoutExt.$ext';
      } else {
        return name; // No extension
      }
    } catch (e) {
      return filePath.split('/').last;
    }
  }

  String selectedType = 'PDF';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom File Downloader')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedType,
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedType = value);
                }
              },
              items: fileTypeUrls.keys
                  .map((type) =>
                      DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final url = fileTypeUrls[selectedType]!;
                // final extension = url.split('.').last;

                // await Permission.storage.re
                // await requestStoragePermission();

                await CommonFileDownloader.download(
                  url: url,
                  fileName: getFileName(url),
                  state: this,
                );
              },
              child: Text('Download $selectedType File'),
            ),
          ],
        ),
      ),
    );
  }
}
