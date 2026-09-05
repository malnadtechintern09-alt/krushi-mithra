import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConfig {
  static const int port = 8080;
  static const String apiVersion = '/api/v1';

  // Primary base URL based on platform
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:$port$apiVersion';
    } else if (Platform.isAndroid) {
      // Android Emulator host loopback address is 10.0.2.2
      return 'http://10.0.2.2:$port$apiVersion';
    } else {
      // Windows Desktop, macOS, iOS Simulator
      return 'http://127.0.0.1:$port$apiVersion';
    }
  }

  // Candidate URLs to try sequentially when attempting network connection
  static List<String> get candidateBaseUrls {
    if (kIsWeb) {
      return ['http://localhost:$port$apiVersion', 'http://127.0.0.1:$port$apiVersion'];
    }
    if (Platform.isAndroid) {
      return [
        'http://10.0.2.2:$port$apiVersion',
        'http://127.0.0.1:$port$apiVersion',
        'http://localhost:$port$apiVersion',
      ];
    }
    return [
      'http://127.0.0.1:$port$apiVersion',
      'http://localhost:$port$apiVersion',
      'http://10.0.2.2:$port$apiVersion',
    ];
  }
}
