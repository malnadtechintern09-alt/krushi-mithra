import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';

import 'core/config/api_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiConfig.loadSavedServerIp();
  runApp(
    const ProviderScope(
      child: KrushiMithraApp(),
    ),
  );
}
