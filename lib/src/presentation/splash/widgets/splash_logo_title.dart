import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/theme/app_colors.dart';

class SplashLogoTitle extends StatelessWidget {
  const SplashLogoTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.splashLogoGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.blue700.withValues(alpha: 0.4),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Icon(
            Icons.public,
            size: 60,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          AppLocalizations.of(context)!.appTitle,
          style: (theme.textTheme.headlineSmall ?? const TextStyle()).copyWith(
            color: AppColors.white,
            letterSpacing: 1.2,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.appSubtitle,
          style: (theme.textTheme.titleMedium ?? const TextStyle()).copyWith(
            color: AppColors.lavender,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 64),
      ],
    );
  }
}
