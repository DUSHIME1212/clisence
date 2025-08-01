import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  
  Locale _currentLocale = const Locale('en', 'US');
  bool _isLoading = false;

  Locale get currentLocale => _currentLocale;
  bool get isLoading => _isLoading;

  // Supported languages
  static const List<Map<String, dynamic>> supportedLanguages = [
    {
      'code': 'en',
      'countryCode': 'US',
      'name': 'English',
      'nativeName': 'English',
      'flag': '🇺🇸',
    },
    {
      'code': 'es',
      'countryCode': 'ES',
      'name': 'Spanish',
      'nativeName': 'Español',
      'flag': '🇪🇸',
    },
    {
      'code': 'fr',
      'countryCode': 'FR',
      'name': 'French',
      'nativeName': 'Français',
      'flag': '🇫🇷',
    },
    {
      'code': 'de',
      'countryCode': 'DE',
      'name': 'German',
      'nativeName': 'Deutsch',
      'flag': '🇩🇪',
    },
    {
      'code': 'pt',
      'countryCode': 'BR',
      'name': 'Portuguese',
      'nativeName': 'Português',
      'flag': '🇧🇷',
    },
    {
      'code': 'ar',
      'countryCode': 'SA',
      'name': 'Arabic',
      'nativeName': 'العربية',
      'flag': '🇸🇦',
    },
    {
      'code': 'zh',
      'countryCode': 'CN',
      'name': 'Chinese',
      'nativeName': '中文',
      'flag': '🇨🇳',
    },
    {
      'code': 'hi',
      'countryCode': 'IN',
      'name': 'Hindi',
      'nativeName': 'हिन्दी',
      'flag': '🇮🇳',
    },
  ];

  LanguageProvider() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(_languageKey);
      
      if (savedLanguage != null) {
        final parts = savedLanguage.split('_');
        if (parts.length == 2) {
          _currentLocale = Locale(parts[0], parts[1]);
        }
      }
    } catch (e) {
      debugPrint('Error loading saved language: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> changeLanguage(String languageCode, String countryCode) async {
    if (_currentLocale.languageCode == languageCode && 
        _currentLocale.countryCode == countryCode) {
      return; // Already set to this language
    }

    _isLoading = true;
    notifyListeners();

    try {
      _currentLocale = Locale(languageCode, countryCode);
      
      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, '${languageCode}_$countryCode');
      
    } catch (e) {
      debugPrint('Error changing language: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String getCurrentLanguageName() {
    final currentLang = supportedLanguages.firstWhere(
      (lang) => lang['code'] == _currentLocale.languageCode,
      orElse: () => supportedLanguages.first,
    );
    return currentLang['name'] as String;
  }

  String getCurrentLanguageNativeName() {
    final currentLang = supportedLanguages.firstWhere(
      (lang) => lang['code'] == _currentLocale.languageCode,
      orElse: () => supportedLanguages.first,
    );
    return currentLang['nativeName'] as String;
  }

  String getCurrentLanguageFlag() {
    final currentLang = supportedLanguages.firstWhere(
      (lang) => lang['code'] == _currentLocale.languageCode,
      orElse: () => supportedLanguages.first,
    );
    return currentLang['flag'] as String;
  }

  bool isCurrentLanguage(String languageCode) {
    return _currentLocale.languageCode == languageCode;
  }
} 