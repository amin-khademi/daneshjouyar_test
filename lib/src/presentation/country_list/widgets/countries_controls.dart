import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/theme/app_colors.dart';

enum SortKey { name, code, capital }

class CountriesControls extends StatelessWidget {
  final bool isDark;
  final bool isRtl;
  final int resultCount;
  final int totalCount;
  final SortKey? sortKey;
  final bool ascending;
  final bool onlyFavorites;
  final ValueChanged<SortKey> onSortKey;
  final ValueChanged<bool> onAscending;

  const CountriesControls({
    super.key,
    required this.isDark,
    required this.isRtl,
    required this.resultCount,
    required this.totalCount,
    required this.sortKey,
    required this.ascending,
    required this.onlyFavorites,
    required this.onSortKey,
    required this.onAscending,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.sortBy,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.lavender : AppColors.grey700,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  FilterChip(
                    label: Text(AppLocalizations.of(context)!.name),
                    selected: sortKey == SortKey.name,
                    onSelected: (_) => onSortKey(SortKey.name),
                  ),
                  FilterChip(
                    label: Text(AppLocalizations.of(context)!.code),
                    selected: sortKey == SortKey.code,
                    onSelected: (_) => onSortKey(SortKey.code),
                  ),
                  FilterChip(
                    label: Text(AppLocalizations.of(context)!.capital),
                    selected: sortKey == SortKey.capital,
                    onSelected: (_) => onSortKey(SortKey.capital),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 6, top: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: ascending
                          ? AppLocalizations.of(context)!.orderDesc
                          : AppLocalizations.of(context)!.orderAsc,
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      iconSize: 20,
                      onPressed: () => onAscending(!ascending),
                      icon: Icon(
                        ascending ? Icons.arrow_upward : Icons.arrow_downward,
                        color: isDark
                            ? AppColors.shimmerHighlightLight
                            : AppColors.blue700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                if (onlyFavorites)
                  Text(
                    AppLocalizations.of(context)!.onlyFavorites,
                    style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.lavender : AppColors.grey700),
                  ),
                const Spacer(),
                Text(
                  '${AppLocalizations.of(context)!.results}: $resultCount / $totalCount',
                  style: TextStyle(
                      color: isDark ? AppColors.lavender : AppColors.grey700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
