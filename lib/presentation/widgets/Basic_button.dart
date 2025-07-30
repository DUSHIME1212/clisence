import 'package:clisence/core/configs/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BasicButton extends StatelessWidget {

  final VoidCallback callback;
  final String title;
  final Image? logo;
  const BasicButton({
    required this.logo,
    required this.callback,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: AppTheme.lightTheme.elevatedButtonTheme.style,
      onPressed: callback,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (logo != null) ...[logo!, const SizedBox(width: 12)],
          Text(title, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}