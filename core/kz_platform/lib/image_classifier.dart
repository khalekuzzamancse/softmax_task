import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:typed_data';

@pragma('vm:entry-point')
class CorePlatform {
  static const platform = MethodChannel('kz_platform'); // Ensure this matches Android side channel

  Future<String> getPlatformVersion() async {
    try {
      final String version = await platform.invokeMethod('getPlatformVersion');
      return version;
    } on PlatformException catch (e) {
      print("Failed to get platform version: ${e.message}");
      return 'N/A';
    }
  }

  // Method to get the device name
  Future<String> deviceName() async {
    try {
      // Invoke the 'getDeviceName' method on the platform
      final String device = await platform.invokeMethod('getDeviceName');
      return device;  // Return the device name string
    } on PlatformException catch (e) {
      print("Failed to get device name: ${e.message}");
      return 'N/A';
    }
  }

}
