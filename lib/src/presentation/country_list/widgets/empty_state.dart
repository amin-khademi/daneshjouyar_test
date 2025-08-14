import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/theme/app_colors.dart';

class EmptyState extends StatelessWidget {
  final bool isRtl;
  final bool isDark;
  final List<String> suggestions;
  final ValueChanged<String> onSelectSuggestion;
  const EmptyState({
    super.key,
    required this.isRtl,
    required this.isDark,
    required this.suggestions,
    required this.onSelectSuggestion,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              color: isDark ? AppColors.lavender : AppColors.grey700,
              size: 64,
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.noResults,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.shimmerHighlightLight
                    : AppColors.blue800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.tryOneOfThese,
              style: TextStyle(
                  color: isDark ? AppColors.lavender : AppColors.grey700),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: suggestions
                  .map((s) => ActionChip(
                        label: Text(s),
                        onPressed: () => onSelectSuggestion(s),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
