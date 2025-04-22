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

  String selectedType = 'PDF';

  String getFileName(String filePath) {
    final name = Uri.parse(filePath).pathSegments.last;
    return name.contains('.') ? name : '$name.file';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom File Downloader')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdown(),
            const SizedBox(height: 20),
            _buildDownloadButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedType,
      decoration: const InputDecoration(
        labelText: 'Select File Type',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        if (value != null) {
          setState(() => selectedType = value);
        }
      },
      items: fileTypeUrls.keys
          .map((type) => DropdownMenuItem(value: type, child: Text(type)))
          .toList(),
    );
  }

  Widget _buildDownloadButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _downloadSelectedFile,
        child: Text('Download $selectedType File'),
      ),
    );
  }

  Future<void> _downloadSelectedFile() async {
    final url = fileTypeUrls[selectedType]!;
    await CommonFileDownloader.download(
      url: url,
      fileName: getFileName(url),
      state: this,
    );
  }
}
