import 'package:clisence/presentation/pages/app/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clisence/core/models/settings.dart';
import 'package:clisence/core/configs/theme/app_colors.dart';
import 'package:clisence/presentation/providers/auth_provider.dart';
import 'package:clisence/core/configs/localization/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late List<SettingsSectionModel> settingsSections;

  @override
  void initState() {
    super.initState();
    _initializeSettingsSections();
  }

  void _initializeSettingsSections() {
    settingsSections = [
      SettingsSectionModel(
        title: AppLocalizations.of(context).account,
        items: [
          SettingsItemModel(
            icon: Icons.person_outline,
            title: AppLocalizations.of(context).profile,
            subtitle: AppLocalizations.of(context).editYourProfile,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            ),
          ),
          SettingsItemModel(
            icon: Icons.location_on_outlined,
            title: AppLocalizations.of(context).farmLocation,
            subtitle: AppLocalizations.of(context).manageYourFarmLocation,
            onTap: () => _navigateToFarmLocation(),
          ),

          SettingsItemModel(
            icon: Icons.agriculture_outlined,
            title: AppLocalizations.of(context).crops,
            subtitle: AppLocalizations.of(context).manageYourCrops,
            onTap: () => _navigateToManageCrops(),
            showDivider: false,
          ),
        ],
      ),

      SettingsSectionModel(
        title: AppLocalizations.of(context).preferences,
        items: [
          SettingsItemModel(
            icon: Icons.notifications_outlined,
            title: AppLocalizations.of(context).communication,
            subtitle: AppLocalizations.of(context).manageYourCommunicationPreferences,
            onTap: () => _navigateToCommunicationPrefs(),
          ),
          SettingsItemModel(
            icon: Icons.language_outlined,
            title: AppLocalizations.of(context).language,
            subtitle: AppLocalizations.of(context).switchLanguages,
            onTap: () => _navigateToLanguageSettings(),
            showDivider: false,
          ),
        ],
      ),
      SettingsSectionModel(
        title: AppLocalizations.of(context).privacy,
        items: [
          SettingsItemModel(
            icon: Icons.privacy_tip_outlined,
            title: AppLocalizations.of(context).privacy,
            subtitle: AppLocalizations.of(context).privacyAndDataUseNotifications,
            onTap: () => _navigateToPrivacySettings(),
            showDivider: false,
          ),
        ],
      ),
      SettingsSectionModel(
        title: AppLocalizations.of(context).help,
        items: [
          SettingsItemModel(
            icon: Icons.help_outline,
            title: AppLocalizations.of(context).contact,
            subtitle: AppLocalizations.of(context).contactUsForHelp,
            onTap: () => _navigateToContactSupport(),
            showDivider: false,
          ),
        ],
      ),
      // logout
      SettingsSectionModel(
        title: AppLocalizations.of(context).logout,
        items: [
          SettingsItemModel(
            icon: Icons.logout_outlined,
            title: AppLocalizations.of(context).logout,
            subtitle: AppLocalizations.of(context).logoutOfYourAccount,
            showDivider: false,
            onTap: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await authProvider.signOut();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: _buildSettingsContent(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Color(0xFF2E7D32),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        AppLocalizations.of(context).settings,
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

  Widget _buildSettingsContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...settingsSections.map((section) => _buildSection(section)),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildSection(SettingsSectionModel section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(section.title),
        const SizedBox(height: 12),
        _buildSettingsCard(
          section.items.map((item) => [
            _buildSettingsItem(item),
            if (item.showDivider) _buildDivider(),
          ]).expand((widgets) => widgets).toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
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
      child: Column(children: children),
    );
  }

  Widget _buildSettingsItem(SettingsItemModel item) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                item.icon,
                size: 20,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
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
      margin: const EdgeInsets.only(left: 76),
      height: 1,
      color: Colors.grey.shade200,
    );
  }

  // Navigation methods
  void _navigateToProfile() => Navigator.pushNamed(context, '/profile');
  void _navigateToFarmLocation() => Navigator.pushNamed(context, '/farm-location');
  void _navigateToManageCrops() => Navigator.pushNamed(context, '/manage-crops');
  void _navigateToCommunicationPrefs() => Navigator.pushNamed(context, '/communication-preferences');
  void _navigateToLanguageSettings() => Navigator.pushNamed(context, '/language-settings');
  void _navigateToPrivacySettings() => Navigator.pushNamed(context, '/privacy-settings');
  void _navigateToContactSupport() => Navigator.pushNamed(context, '/contact-support');
}
