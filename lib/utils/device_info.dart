import 'package:flutter/services.dart';

class DeviceInfo {
  static const _channel = MethodChannel('com.example.deviceinfo');

  static Future<int> getAndroidSdkVersion() async {
    try {
      final version = await _channel.invokeMethod<int>('getSdkVersion');
      return version ?? 0;
    } catch (e) {
      return 0;
    }
  }
}
