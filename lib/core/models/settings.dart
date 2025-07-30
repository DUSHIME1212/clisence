import 'package:flutter/material.dart';

class SettingsSectionModel {
  final String title;
  final List<SettingsItemModel> items;

  SettingsSectionModel({
    required this.title,
    required this.items,
  });
}

class SettingsItemModel {
  final IconData icon;
  final String title;
  final String subtitle;
  final Function() onTap;
  final bool showDivider;
  final Color? titleColor;
  final Color? iconColor;

  SettingsItemModel({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.showDivider = true,
    this.titleColor,
    this.iconColor,
  });
}
