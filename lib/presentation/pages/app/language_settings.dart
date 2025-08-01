import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clisence/presentation/providers/language_provider.dart';
import 'package:clisence/core/configs/theme/app_colors.dart';
import 'package:clisence/core/configs/localization/app_localizations.dart';

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({Key? key}) : super(key: key);

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: _buildLanguageContent(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF2E7D32),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        AppLocalizations.of(context).languageSettings,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildLanguageContent() {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        if (languageProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCurrentLanguageCard(languageProvider),
              const SizedBox(height: 24),
              _buildLanguageList(languageProvider),
              const SizedBox(height: 100),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrentLanguageCard(LanguageProvider languageProvider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).currentLanguage,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      languageProvider.getCurrentLanguageFlag(),
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        languageProvider.getCurrentLanguageName(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        languageProvider.getCurrentLanguageNativeName(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    AppLocalizations.of(context).active,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageList(LanguageProvider languageProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).availableLanguages,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: LanguageProvider.supportedLanguages
                .asMap()
                .entries
                .map((entry) {
              final index = entry.key;
              final language = entry.value;
              final isCurrentLanguage = languageProvider.isCurrentLanguage(language['code']);

              return Column(
                children: [
                  _buildLanguageItem(
                    language: language,
                    isCurrentLanguage: isCurrentLanguage,
                    onTap: () => _changeLanguage(languageProvider, language),
                  ),
                  if (index < LanguageProvider.supportedLanguages.length - 1)
                    _buildDivider(),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageItem({
    required Map<String, dynamic> language,
    required bool isCurrentLanguage,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: isCurrentLanguage ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Text(
                  language['flag'] as String,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language['name'] as String,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isCurrentLanguage ? Colors.grey.shade400 : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    language['nativeName'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: isCurrentLanguage ? Colors.grey.shade400 : Colors.grey.shade600,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            if (isCurrentLanguage)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32),
                  borderRadius: BorderRadius.circular(20),
                ),
                                 child: Text(
                   AppLocalizations.of(context).selected,
                   style: const TextStyle(
                     color: Colors.white,
                     fontSize: 10,
                     fontWeight: FontWeight.w600,
                   ),
                 ),
              )
            else
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.only(left: 86),
      height: 1,
      color: Colors.grey.shade200,
    );
  }

  Future<void> _changeLanguage(LanguageProvider languageProvider, Map<String, dynamic> language) async {
    try {
      await languageProvider.changeLanguage(
        language['code'] as String,
        language['countryCode'] as String,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context).languageChanged} ${language['name']}'),
            backgroundColor: const Color(0xFF2E7D32),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).failedToChangeLanguage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
} 