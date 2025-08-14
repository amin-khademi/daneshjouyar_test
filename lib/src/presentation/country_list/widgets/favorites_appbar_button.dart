import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/theme/app_colors.dart';

class FavoritesAppBarButton extends StatelessWidget {
  final bool isSearching;
  final bool onlyFavorites;
  final VoidCallback onToggle;
  const FavoritesAppBarButton({
    super.key,
    required this.isSearching,
    required this.onlyFavorites,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (isSearching) return const SizedBox.shrink();
    return IconButton(
      tooltip: AppLocalizations.of(context)!.favorites,
      icon: Icon(
        onlyFavorites ? Icons.favorite : Icons.favorite_border,
        color: onlyFavorites ? AppColors.error : AppColors.white,
      ),
      onPressed: onToggle,
    );
  }
}
