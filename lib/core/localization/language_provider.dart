import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_translations.dart';

class LanguageNotifier extends StateNotifier<String> {
  static const String _storageKey = 'selected_app_language';

  LanguageNotifier() : super(AppTranslations.defaultLanguage) {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLang = prefs.getString(_storageKey);
      if (savedLang != null && savedLang.isNotEmpty) {
        state = savedLang;
      }
    } catch (_) {}
  }

  Future<void> setLanguage(String language) async {
    state = language;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, language);
    } catch (_) {}
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  return LanguageNotifier();
});

extension TranslationRef on WidgetRef {
  String tr(String key) {
    final lang = watch(languageProvider);
    return AppTranslations.tr(key, lang);
  }
}
