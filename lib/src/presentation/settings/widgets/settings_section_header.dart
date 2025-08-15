import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class SettingsSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isDark;

  const SettingsSectionHeader({
    super.key,
    required this.title,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [AppColors.purple, AppColors.purple700]),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.white : AppColors.black87,
          ),
        ),
      ],
    );
  }
}
