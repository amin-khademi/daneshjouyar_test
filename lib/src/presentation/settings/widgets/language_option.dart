import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class LanguageOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final String flag;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const LanguageOption({
    super.key,
    required this.title,
    required this.subtitle,
    required this.flag,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (isDark ? AppColors.appBarDark : AppColors.grey100),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          flag,
          style: textTheme.titleMedium,
        ),
      ),
      title: Text(
        title,
        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style:
            textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: colorScheme.primary,
            )
          : null,
      onTap: onTap,
    );
  }
}
