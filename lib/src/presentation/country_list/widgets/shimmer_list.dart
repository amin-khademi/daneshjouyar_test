import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/theme/app_colors.dart';

class ShimmerList extends StatelessWidget {
  const ShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor =
        isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBaseLight;
    final highlightColor = isDark
        ? AppColors.shimmerHighlightDark
        : AppColors.shimmerHighlightLight;
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: 8,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          enabled: true,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: isDark ? 0.3 : 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  height: 56,
                  width: 88,
                  decoration: BoxDecoration(
                    color:
                        isDark ? AppColors.appBarDark : AppColors.lilacSurface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: 180,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.appBarDark
                              : AppColors.lilacSurface,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 14,
                        width: 120,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.appBarDark
                              : AppColors.lilacSurface,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 24,
                  width: 40,
                  decoration: BoxDecoration(
                    color:
                        isDark ? AppColors.appBarDark : AppColors.lilacSurface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
