import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiConfig {
  static const int port = 8080;
  static const String apiVersion = '/api/v1';

  // Primary Wi-Fi IP of laptop on local network
  static const String defaultLaptopIp = '192.168.31.136';
  
  static String? _customServerIp;

  static String get currentServerIp => _customServerIp ?? defaultLaptopIp;

  static Future<void> loadSavedServerIp() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _customServerIp = prefs.getString('custom_server_ip');
    } catch (_) {}
  }

  static Future<void> setCustomServerIp(String ip) async {
    _customServerIp = ip.trim();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('custom_server_ip', _customServerIp!);
    } catch (_) {}
  }

  // Primary base URL based on platform
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:$port$apiVersion';
    } else if (Platform.isAndroid) {
      // For physical Android device on same Wi-Fi network as laptop
      return 'http://${currentServerIp}:$port$apiVersion';
    } else {
      // Windows Desktop, macOS, iOS Simulator
      return 'http://127.0.0.1:$port$apiVersion';
    }
  }

  // Candidate URLs tried sequentially by ApiService for zero-config connection
  static List<String> get candidateBaseUrls {
    final list = <String>[];

    if (_customServerIp != null && _customServerIp!.isNotEmpty) {
      list.add('http://${_customServerIp}:$port$apiVersion');
    }

    if (kIsWeb) {
      list.addAll([
        'http://localhost:$port$apiVersion',
        'http://127.0.0.1:$port$apiVersion',
      ]);
    } else if (Platform.isAndroid) {
      list.addAll([
        'http://127.0.0.1:$port$apiVersion', // USB ADB Reverse tcp:8080 tcp:8080
        'http://localhost:$port$apiVersion',
        'http://$defaultLaptopIp:$port$apiVersion', // Wi-Fi Local Network IP
        'http://10.0.2.2:$port$apiVersion', // Android Emulator host alias
      ]);
    } else {
      list.addAll([
        'http://127.0.0.1:$port$apiVersion',
        'http://localhost:$port$apiVersion',
        'http://$defaultLaptopIp:$port$apiVersion',
        'http://10.0.2.2:$port$apiVersion',
      ]);
    }

    return list;
  }
}
