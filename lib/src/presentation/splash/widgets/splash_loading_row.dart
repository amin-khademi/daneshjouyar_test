import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/theme/app_colors.dart';

class SplashLoadingRow extends StatelessWidget {
  const SplashLoadingRow({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            strokeCap: StrokeCap.round,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          AppLocalizations.of(context)!.loading,
          style: (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
            color: AppColors.white70,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
