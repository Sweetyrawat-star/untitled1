import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:untitled1/file_downloader.dart';

void main() async{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: FileDownloaderScreen(),
    );
  }
}


