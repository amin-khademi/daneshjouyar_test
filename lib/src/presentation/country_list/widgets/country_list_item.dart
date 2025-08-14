import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/country_entity.dart';

class CountryListItem extends StatelessWidget {
  final CountryEntity country;
  final String searchQuery;
  final bool isFavorite;
  final bool isDark;
  final VoidCallback onToggleFavorite;

  const CountryListItem({
    super.key,
    required this.country,
    required this.searchQuery,
    required this.isFavorite,
    required this.isDark,
    required this.onToggleFavorite,
  });

  TextSpan _highlight(
      String text, String query, TextStyle normal, TextStyle highlight) {
    if (query.isEmpty) return TextSpan(text: text, style: normal);
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;
    while (true) {
      final index = lowerText.indexOf(lowerQuery, start);
      if (index < 0) {
        spans.add(TextSpan(text: text.substring(start), style: normal));
        break;
      }
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index), style: normal));
      }
      spans.add(TextSpan(
          text: text.substring(index, index + lowerQuery.length),
          style: highlight));
      start = index + lowerQuery.length;
      if (start >= text.length) break;
    }
    return TextSpan(children: spans);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final c = country;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 3,
        shadowColor: isDark ? AppColors.black54 : AppColors.black26,
        color: isDark ? AppColors.cardDark : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: isDark
                  ? [AppColors.cardDark, AppColors.appBarDark]
                  : [AppColors.white, AppColors.neutralLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color:
                        AppColors.black.withValues(alpha: isDark ? 0.3 : 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: c.flag.value,
                  width: 72,
                  height: 48,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 72,
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 72,
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:
                        Icon(Icons.flag_outlined, color: colorScheme.primary),
                  ),
                ),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: _highlight(
                    c.name.value,
                    searchQuery,
                    (textTheme.titleMedium ?? const TextStyle())
                        .copyWith(fontWeight: FontWeight.w700),
                    (textTheme.titleMedium ?? const TextStyle()).copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: isFavorite
                      ? AppLocalizations.of(context)!.unfavorite
                      : AppLocalizations.of(context)!.favorite,
                  onPressed: onToggleFavorite,
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 28, minHeight: 28),
                  iconSize: 18,
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite
                        ? colorScheme.error
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: RichText(
                    text: _highlight(
                      '${AppLocalizations.of(context)!.capital}: ${c.capital.value}',
                      searchQuery,
                      (textTheme.bodyMedium ?? const TextStyle()).copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      (textTheme.bodyMedium ?? const TextStyle()).copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [AppColors.purple, AppColors.purple700]),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.purple.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      c.code.value,
                      style:
                          (textTheme.labelSmall ?? const TextStyle()).copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
