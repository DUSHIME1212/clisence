import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('es', 'ES'),
    Locale('fr', 'FR'),
    Locale('de', 'DE'),
    Locale('pt', 'BR'),
    Locale('ar', 'SA'),
    Locale('zh', 'CN'),
    Locale('hi', 'IN'),
  ];

  // Translation maps
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'settings': 'SETTINGS',
      'language_settings': 'LANGUAGE SETTINGS',
      'current_language': 'CURRENT LANGUAGE',
      'available_languages': 'AVAILABLE LANGUAGES',
      'active': 'ACTIVE',
      'selected': 'SELECTED',
      'language_changed': 'Language changed to',
      'failed_to_change_language': 'Failed to change language. Please try again.',
      'account': 'ACCOUNT',
      'profile': 'PROFILE',
      'edit_your_profile': 'EDIT YOUR PROFILE',
      'farm_location': 'FARM LOCATION',
      'manage_your_farm_location': 'MANAGE YOUR FARM LOCATION',
      'crops': 'CROPS',
      'manage_your_crops': 'MANAGE YOUR CROPS',
      'preferences': 'PREFERENCES',
      'communication': 'COMMUNICATION',
      'manage_your_communication_preferences': 'MANAGE YOUR COMMUNICATION PREFERENCES',
      'language': 'LANGUAGE',
      'switch_languages': 'SWITCH LANGUAGES',
      'privacy': 'PRIVACY',
      'privacy_and_data_use_notifications': 'PRIVACY AND DATA USE NOTIFICATIONS',
      'help': 'HELP',
      'contact': 'CONTACT',
      'contact_us_for_help': 'CONTACT US FOR HELP',
      'logout': 'LOGOUT',
      'logout_of_your_account': 'LOGOUT OF YOUR ACCOUNT',
    },
    'es': {
      'settings': 'CONFIGURACIÓN',
      'language_settings': 'CONFIGURACIÓN DE IDIOMA',
      'current_language': 'IDIOMA ACTUAL',
      'available_languages': 'IDIOMAS DISPONIBLES',
      'active': 'ACTIVO',
      'selected': 'SELECCIONADO',
      'language_changed': 'Idioma cambiado a',
      'failed_to_change_language': 'Error al cambiar el idioma. Inténtalo de nuevo.',
      'account': 'CUENTA',
      'profile': 'PERFIL',
      'edit_your_profile': 'EDITAR TU PERFIL',
      'farm_location': 'UBICACIÓN DE LA GRANJA',
      'manage_your_farm_location': 'GESTIONAR LA UBICACIÓN DE TU GRANJA',
      'crops': 'CULTIVOS',
      'manage_your_crops': 'GESTIONAR TUS CULTIVOS',
      'preferences': 'PREFERENCIAS',
      'communication': 'COMUNICACIÓN',
      'manage_your_communication_preferences': 'GESTIONAR TUS PREFERENCIAS DE COMUNICACIÓN',
      'language': 'IDIOMA',
      'switch_languages': 'CAMBIAR IDIOMAS',
      'privacy': 'PRIVACIDAD',
      'privacy_and_data_use_notifications': 'PRIVACIDAD Y NOTIFICACIONES DE USO DE DATOS',
      'help': 'AYUDA',
      'contact': 'CONTACTO',
      'contact_us_for_help': 'CONTÁCTANOS PARA AYUDA',
      'logout': 'CERRAR SESIÓN',
      'logout_of_your_account': 'CERRAR SESIÓN DE TU CUENTA',
    },
    'fr': {
      'settings': 'PARAMÈTRES',
      'language_settings': 'PARAMÈTRES DE LANGUE',
      'current_language': 'LANGUE ACTUELLE',
      'available_languages': 'LANGUES DISPONIBLES',
      'active': 'ACTIF',
      'selected': 'SÉLECTIONNÉ',
      'language_changed': 'Langue changée vers',
      'failed_to_change_language': 'Échec du changement de langue. Veuillez réessayer.',
      'account': 'COMPTE',
      'profile': 'PROFIL',
      'edit_your_profile': 'MODIFIER VOTRE PROFIL',
      'farm_location': 'EMPLACEMENT DE LA FERME',
      'manage_your_farm_location': 'GÉRER L\'EMPLACEMENT DE VOTRE FERME',
      'crops': 'CULTURES',
      'manage_your_crops': 'GÉRER VOS CULTURES',
      'preferences': 'PRÉFÉRENCES',
      'communication': 'COMMUNICATION',
      'manage_your_communication_preferences': 'GÉRER VOS PRÉFÉRENCES DE COMMUNICATION',
      'language': 'LANGUE',
      'switch_languages': 'CHANGER DE LANGUE',
      'privacy': 'CONFIDENTIALITÉ',
      'privacy_and_data_use_notifications': 'CONFIDENTIALITÉ ET NOTIFICATIONS D\'UTILISATION DES DONNÉES',
      'help': 'AIDE',
      'contact': 'CONTACT',
      'contact_us_for_help': 'CONTACTEZ-NOUS POUR L\'AIDE',
      'logout': 'DÉCONNEXION',
      'logout_of_your_account': 'SE DÉCONNECTER DE VOTRE COMPTE',
    },
    'de': {
      'settings': 'EINSTELLUNGEN',
      'language_settings': 'SPRACHEINSTELLUNGEN',
      'current_language': 'AKTUELLE SPRACHE',
      'available_languages': 'VERFÜGBARE SPRACHEN',
      'active': 'AKTIV',
      'selected': 'AUSGEWÄHLT',
      'language_changed': 'Sprache geändert zu',
      'failed_to_change_language': 'Sprachänderung fehlgeschlagen. Bitte versuchen Sie es erneut.',
      'account': 'KONTO',
      'profile': 'PROFIL',
      'edit_your_profile': 'IHRE PROFIL BEARBEITEN',
      'farm_location': 'HOFSTANDORT',
      'manage_your_farm_location': 'VERWALTEN SIE IHREN HOFSTANDORT',
      'crops': 'KULTUREN',
      'manage_your_crops': 'VERWALTEN SIE IHRE KULTUREN',
      'preferences': 'PRÄFERENZEN',
      'communication': 'KOMMUNIKATION',
      'manage_your_communication_preferences': 'VERWALTEN SIE IHRE KOMMUNIKATIONSPRÄFERENZEN',
      'language': 'SPRACHE',
      'switch_languages': 'SPRACHEN WECHSELN',
      'privacy': 'DATENSCHUTZ',
      'privacy_and_data_use_notifications': 'DATENSCHUTZ UND DATENNUTZUNGSBENACHRICHTIGUNGEN',
      'help': 'HILFE',
      'contact': 'KONTAKT',
      'contact_us_for_help': 'KONTAKTIEREN SIE UNS FÜR HILFE',
      'logout': 'ABMELDEN',
      'logout_of_your_account': 'VON IHREM KONTO ABMELDEN',
    },
    'pt': {
      'settings': 'CONFIGURAÇÕES',
      'language_settings': 'CONFIGURAÇÕES DE IDIOMA',
      'current_language': 'IDIOMA ATUAL',
      'available_languages': 'IDIOMAS DISPONÍVEIS',
      'active': 'ATIVO',
      'selected': 'SELECIONADO',
      'language_changed': 'Idioma alterado para',
      'failed_to_change_language': 'Falha ao alterar o idioma. Tente novamente.',
      'account': 'CONTA',
      'profile': 'PERFIL',
      'edit_your_profile': 'EDITAR SEU PERFIL',
      'farm_location': 'LOCALIZAÇÃO DA FAZENDA',
      'manage_your_farm_location': 'GERENCIAR A LOCALIZAÇÃO DA SUA FAZENDA',
      'crops': 'CULTURAS',
      'manage_your_crops': 'GERENCIAR SUAS CULTURAS',
      'preferences': 'PREFERÊNCIAS',
      'communication': 'COMUNICAÇÃO',
      'manage_your_communication_preferences': 'GERENCIAR SUAS PREFERÊNCIAS DE COMUNICAÇÃO',
      'language': 'IDIOMA',
      'switch_languages': 'ALTERNAR IDIOMAS',
      'privacy': 'PRIVACIDADE',
      'privacy_and_data_use_notifications': 'PRIVACIDADE E NOTIFICAÇÕES DE USO DE DADOS',
      'help': 'AJUDA',
      'contact': 'CONTATO',
      'contact_us_for_help': 'ENTRE EM CONTATO CONOSCO PARA AJUDA',
      'logout': 'SAIR',
      'logout_of_your_account': 'SAIR DA SUA CONTA',
    },
    'ar': {
      'settings': 'الإعدادات',
      'language_settings': 'إعدادات اللغة',
      'current_language': 'اللغة الحالية',
      'available_languages': 'اللغات المتاحة',
      'active': 'نشط',
      'selected': 'محدد',
      'language_changed': 'تم تغيير اللغة إلى',
      'failed_to_change_language': 'فشل في تغيير اللغة. يرجى المحاولة مرة أخرى.',
      'account': 'الحساب',
      'profile': 'الملف الشخصي',
      'edit_your_profile': 'تحرير ملفك الشخصي',
      'farm_location': 'موقع المزرعة',
      'manage_your_farm_location': 'إدارة موقع مزرعتك',
      'crops': 'المحاصيل',
      'manage_your_crops': 'إدارة محاصيلك',
      'preferences': 'التفضيلات',
      'communication': 'الاتصال',
      'manage_your_communication_preferences': 'إدارة تفضيلات الاتصال الخاصة بك',
      'language': 'اللغة',
      'switch_languages': 'تبديل اللغات',
      'privacy': 'الخصوصية',
      'privacy_and_data_use_notifications': 'الخصوصية وإشعارات استخدام البيانات',
      'help': 'المساعدة',
      'contact': 'اتصل بنا',
      'contact_us_for_help': 'اتصل بنا للحصول على المساعدة',
      'logout': 'تسجيل الخروج',
      'logout_of_your_account': 'تسجيل الخروج من حسابك',
    },
    'zh': {
      'settings': '设置',
      'language_settings': '语言设置',
      'current_language': '当前语言',
      'available_languages': '可用语言',
      'active': '活跃',
      'selected': '已选择',
      'language_changed': '语言已更改为',
      'failed_to_change_language': '更改语言失败。请重试。',
      'account': '账户',
      'profile': '个人资料',
      'edit_your_profile': '编辑您的个人资料',
      'farm_location': '农场位置',
      'manage_your_farm_location': '管理您的农场位置',
      'crops': '作物',
      'manage_your_crops': '管理您的作物',
      'preferences': '偏好设置',
      'communication': '通信',
      'manage_your_communication_preferences': '管理您的通信偏好',
      'language': '语言',
      'switch_languages': '切换语言',
      'privacy': '隐私',
      'privacy_and_data_use_notifications': '隐私和数据使用通知',
      'help': '帮助',
      'contact': '联系',
      'contact_us_for_help': '联系我们寻求帮助',
      'logout': '退出登录',
      'logout_of_your_account': '退出您的账户',
    },
    'hi': {
      'settings': 'सेटिंग्स',
      'language_settings': 'भाषा सेटिंग्स',
      'current_language': 'वर्तमान भाषा',
      'available_languages': 'उपलब्ध भाषाएं',
      'active': 'सक्रिय',
      'selected': 'चयनित',
      'language_changed': 'भाषा बदली गई',
      'failed_to_change_language': 'भाषा बदलने में विफल। कृपया पुनः प्रयास करें।',
      'account': 'खाता',
      'profile': 'प्रोफ़ाइल',
      'edit_your_profile': 'अपनी प्रोफ़ाइल संपादित करें',
      'farm_location': 'खेत का स्थान',
      'manage_your_farm_location': 'अपने खेत के स्थान का प्रबंधन करें',
      'crops': 'फसलें',
      'manage_your_crops': 'अपनी फसलों का प्रबंधन करें',
      'preferences': 'प्राथमिकताएं',
      'communication': 'संचार',
      'manage_your_communication_preferences': 'अपनी संचार प्राथमिकताओं का प्रबंधन करें',
      'language': 'भाषा',
      'switch_languages': 'भाषाएं बदलें',
      'privacy': 'गोपनीयता',
      'privacy_and_data_use_notifications': 'गोपनीयता और डेटा उपयोग सूचनाएं',
      'help': 'सहायता',
      'contact': 'संपर्क',
      'contact_us_for_help': 'सहायता के लिए हमसे संपर्क करें',
      'logout': 'लॉगआउट',
      'logout_of_your_account': 'अपने खाते से लॉगआउट करें',
    },
  };

  String get settings => _localizedValues[locale.languageCode]?['settings'] ?? _localizedValues['en']!['settings']!;
  String get languageSettings => _localizedValues[locale.languageCode]?['language_settings'] ?? _localizedValues['en']!['language_settings']!;
  String get currentLanguage => _localizedValues[locale.languageCode]?['current_language'] ?? _localizedValues['en']!['current_language']!;
  String get availableLanguages => _localizedValues[locale.languageCode]?['available_languages'] ?? _localizedValues['en']!['available_languages']!;
  String get active => _localizedValues[locale.languageCode]?['active'] ?? _localizedValues['en']!['active']!;
  String get selected => _localizedValues[locale.languageCode]?['selected'] ?? _localizedValues['en']!['selected']!;
  String get languageChanged => _localizedValues[locale.languageCode]?['language_changed'] ?? _localizedValues['en']!['language_changed']!;
  String get failedToChangeLanguage => _localizedValues[locale.languageCode]?['failed_to_change_language'] ?? _localizedValues['en']!['failed_to_change_language']!;
  String get account => _localizedValues[locale.languageCode]?['account'] ?? _localizedValues['en']!['account']!;
  String get profile => _localizedValues[locale.languageCode]?['profile'] ?? _localizedValues['en']!['profile']!;
  String get editYourProfile => _localizedValues[locale.languageCode]?['edit_your_profile'] ?? _localizedValues['en']!['edit_your_profile']!;
  String get farmLocation => _localizedValues[locale.languageCode]?['farm_location'] ?? _localizedValues['en']!['farm_location']!;
  String get manageYourFarmLocation => _localizedValues[locale.languageCode]?['manage_your_farm_location'] ?? _localizedValues['en']!['manage_your_farm_location']!;
  String get crops => _localizedValues[locale.languageCode]?['crops'] ?? _localizedValues['en']!['crops']!;
  String get manageYourCrops => _localizedValues[locale.languageCode]?['manage_your_crops'] ?? _localizedValues['en']!['manage_your_crops']!;
  String get preferences => _localizedValues[locale.languageCode]?['preferences'] ?? _localizedValues['en']!['preferences']!;
  String get communication => _localizedValues[locale.languageCode]?['communication'] ?? _localizedValues['en']!['communication']!;
  String get manageYourCommunicationPreferences => _localizedValues[locale.languageCode]?['manage_your_communication_preferences'] ?? _localizedValues['en']!['manage_your_communication_preferences']!;
  String get language => _localizedValues[locale.languageCode]?['language'] ?? _localizedValues['en']!['language']!;
  String get switchLanguages => _localizedValues[locale.languageCode]?['switch_languages'] ?? _localizedValues['en']!['switch_languages']!;
  String get privacy => _localizedValues[locale.languageCode]?['privacy'] ?? _localizedValues['en']!['privacy']!;
  String get privacyAndDataUseNotifications => _localizedValues[locale.languageCode]?['privacy_and_data_use_notifications'] ?? _localizedValues['en']!['privacy_and_data_use_notifications']!;
  String get help => _localizedValues[locale.languageCode]?['help'] ?? _localizedValues['en']!['help']!;
  String get contact => _localizedValues[locale.languageCode]?['contact'] ?? _localizedValues['en']!['contact']!;
  String get contactUsForHelp => _localizedValues[locale.languageCode]?['contact_us_for_help'] ?? _localizedValues['en']!['contact_us_for_help']!;
  String get logout => _localizedValues[locale.languageCode]?['logout'] ?? _localizedValues['en']!['logout']!;
  String get logoutOfYourAccount => _localizedValues[locale.languageCode]?['logout_of_your_account'] ?? _localizedValues['en']!['logout_of_your_account']!;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es', 'fr', 'de', 'pt', 'ar', 'zh', 'hi'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
} 