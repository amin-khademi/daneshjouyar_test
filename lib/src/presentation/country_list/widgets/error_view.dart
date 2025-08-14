import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/theme/app_colors.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const ErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    isDark ? AppColors.cardDark : AppColors.errorContainerLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.dangerPink : AppColors.errorLight,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: isDark ? AppColors.dangerPink : AppColors.errorLight,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? AppColors.dangerPink : AppColors.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: Text(AppLocalizations.of(context)!.retry),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isDark ? AppColors.purple : AppColors.blue700,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
