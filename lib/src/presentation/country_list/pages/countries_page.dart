import 'dart:async';

import 'package:daneshjouyar_test/src/core/constants/app_routes.dart';
import 'package:daneshjouyar_test/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/exit_confirm_dialog.dart';
import '../../../domain/entities/country_entity.dart';
import '../cubit/countries_cubit.dart';
import '../widgets/countries_controls.dart' as controls;
import '../widgets/country_list_item.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_view.dart';
import '../widgets/favorites_appbar_button.dart';
import '../widgets/shimmer_list.dart';

class CountriesPage extends StatefulWidget {
  const CountriesPage({super.key});

  @override
  State<CountriesPage> createState() => _CountriesPageState();
}

enum _SortKey { name, code, capital }

class _CountriesPageState extends State<CountriesPage> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  String _query = '';
  Timer? _debounce;

  _SortKey? _sortKey = _SortKey.name;
  bool _ascending = true;
  bool _onlyFavorites = false;
  final Set<String> _favorites = <String>{}; // stores country codes

  @override
  void initState() {
    super.initState();
    // Ensure data is loaded if arriving here directly (e.g., splash skipped)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final cubit = context.read<CountriesCubit>();
      if (cubit.state.status == CountriesStatus.initial) {
        cubit.loadCountries();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _startSearch() {
    setState(() => _isSearching = true);
    _searchFocus.requestFocus();
  }

  void _cancelSearch() {
    setState(() {
      _isSearching = false;
      _query = '';
      _searchController.clear();
    });
    _searchFocus.unfocus();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() => _query = value);
    });
  }

  void _toggleFavorite(CountryEntity c) {
    setState(() {
      if (_favorites.contains(c.code.value)) {
        _favorites.remove(c.code.value);
      } else {
        _favorites.add(c.code.value);
      }
    });
  }

  List<CountryEntity> _filter(List<CountryEntity> items) {
    final q = _query.trim().toLowerCase();
    Iterable<CountryEntity> result = items;

    if (_onlyFavorites) {
      result = result.where((c) => _favorites.contains(c.code.value));
    }

    if (q.isNotEmpty) {
      result = result.where((c) =>
          c.name.value.toLowerCase().contains(q) ||
          c.capital.value.toLowerCase().contains(q) ||
          c.code.value.toLowerCase().contains(q));
    }

    var list = result.toList();

    if (_sortKey != null) {
      switch (_sortKey!) {
        case _SortKey.name:
          list.sort((a, b) => a.name.value.compareTo(b.name.value));
          break;
        case _SortKey.code:
          list.sort((a, b) => a.code.value.compareTo(b.code.value));
          break;
        case _SortKey.capital:
          list.sort((a, b) => a.capital.value.compareTo(b.capital.value));
          break;
      }
      if (!_ascending) list = list.reversed.toList();
    }

    return list;
  }

  // Controls extracted to CountriesControls widget

  List<String> _suggestions(List<CountryEntity> all) {
    final q = _query.trim();
    if (q.isNotEmpty) {
      final starts = all
          .where((c) => c.name.value.toLowerCase().startsWith(q.toLowerCase()))
          .map((c) => c.name.value)
          .toSet()
          .take(6)
          .toList();
      if (starts.isNotEmpty) return starts;
    }
    // fallback: top few countries alphabetically
    final names = all.map((c) => c.name.value).toList()..sort();
    return names.take(6).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRtl = Localizations.localeOf(context).languageCode == 'fa';

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor:
            isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          leading: _isSearching
              ? null
              : FavoritesAppBarButton(
                  isSearching: _isSearching,
                  onlyFavorites: _onlyFavorites,
                  onToggle: () =>
                      setState(() => _onlyFavorites = !_onlyFavorites),
                ),
          title: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _isSearching
                ? TextField(
                    key: const ValueKey('searchField'),
                    controller: _searchController,
                    focusNode: _searchFocus,
                    decoration: InputDecoration(
                      hintText:
                          AppLocalizations.of(context)!.searchCountriesHint,
                      hintStyle: TextStyle(
                        color: AppColors.white.withValues(alpha: 0.85),
                      ),
                      border: InputBorder.none,
                      suffixIcon: _query.isNotEmpty
                          ? IconButton(
                              tooltip: AppLocalizations.of(context)!.cancel,
                              icon: const Icon(Icons.clear,
                                  color: AppColors.white),
                              onPressed: _cancelSearch,
                            )
                          : null,
                    ),
                    style: const TextStyle(color: AppColors.white),
                    onChanged: _onQueryChanged,
                  )
                : Text(
                    '${AppLocalizations.of(context)!.appTitle} 🌍',
                    key: const ValueKey('title'),
                  ),
          ),
          actions: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _isSearching
                  ? Row(
                      key: const ValueKey('searchActions'),
                      children: [
                        IconButton(
                          tooltip: AppLocalizations.of(context)!.favorites,
                          icon: Icon(
                            _onlyFavorites
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: _onlyFavorites
                                ? AppColors.error
                                : AppColors.white,
                          ),
                          onPressed: () =>
                              setState(() => _onlyFavorites = !_onlyFavorites),
                        ),
                        TextButton(
                          onPressed: _cancelSearch,
                          child: Text(
                            AppLocalizations.of(context)!.cancel,
                            style: const TextStyle(color: AppColors.white),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      key: const ValueKey('actionsRow'),
                      children: [
                        IconButton(
                          tooltip:
                              AppLocalizations.of(context)!.searchCountriesHint,
                          icon:
                              const Icon(Icons.search, color: AppColors.white),
                          onPressed: _startSearch,
                        ),
                        IconButton(
                          tooltip: AppLocalizations.of(context)!.settings,
                          icon: const Icon(Icons.settings,
                              color: AppColors.white),
                          onPressed: () {
                            context.push(AppRoutes.settings);
                          },
                        ),
                      ],
                    ),
            ),
          ],
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.appBarDark, AppColors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;
              // If in search mode, cancel it instead of exiting
              if (_isSearching) {
                _cancelSearch();
                return;
              }
              HapticFeedback.lightImpact();
              final shouldExit = await showDialog<bool>(
                context: context,
                builder: (ctx) => const ExitConfirmDialog(),
              );
              if (shouldExit == true) {
                SystemNavigator.pop();
              }
            },
            child: BlocListener<CountriesCubit, CountriesState>(
              listenWhen: (prev, curr) =>
                  prev.status != curr.status &&
                  curr.status == CountriesStatus.failure,
              listener: (context, state) {
                final msg = state.error ?? AppLocalizations.of(context)!.error;
                final retry = AppLocalizations.of(context)!.retry;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(msg),
                    action: SnackBarAction(
                      label: retry,
                      onPressed: () => context
                          .read<CountriesCubit>()
                          .loadCountries(forceRefresh: true),
                    ),
                  ),
                );
              },
              child: BlocBuilder<CountriesCubit, CountriesState>(
                builder: (context, state) {
                  switch (state.status) {
                    case CountriesStatus.loading:
                      {
                        final all = state.countries;
                        // If we have no data yet (initial load), show full shimmer; otherwise show controls + shimmer items
                        if (all.isEmpty) {
                          return const ShimmerList();
                        }
                        final filtered = _filter(all);
                        return Column(
                          children: [
                            controls.CountriesControls(
                              isDark: isDark,
                              isRtl: isRtl,
                              resultCount: filtered.length,
                              totalCount: all.length,
                              sortKey: _sortKey == null
                                  ? null
                                  : controls.SortKey.values[_sortKey!.index],
                              ascending: _ascending,
                              onlyFavorites: _onlyFavorites,
                              onSortKey: (key) => setState(() {
                                _sortKey = _SortKey.values[key.index];
                              }),
                              onAscending: (asc) =>
                                  setState(() => _ascending = asc),
                            ),
                            const Expanded(
                              child: ShimmerList(),
                            ),
                          ],
                        );
                      }
                    case CountriesStatus.failure:
                      return ErrorView(
                        message:
                            state.error ?? AppLocalizations.of(context)!.error,
                        onRetry: () => context
                            .read<CountriesCubit>()
                            .loadCountries(forceRefresh: true),
                      );
                    case CountriesStatus.success:
                      final all = state.countries;
                      final filtered = _filter(all);
                      return Column(
                        children: [
                          controls.CountriesControls(
                            isDark: isDark,
                            isRtl: isRtl,
                            resultCount: filtered.length,
                            totalCount: all.length,
                            sortKey: _sortKey == null
                                ? null
                                : controls.SortKey.values[_sortKey!.index],
                            ascending: _ascending,
                            onlyFavorites: _onlyFavorites,
                            onSortKey: (key) => setState(() {
                              _sortKey = _SortKey.values[key.index];
                            }),
                            onAscending: (asc) =>
                                setState(() => _ascending = asc),
                          ),
                          Expanded(
                            child: filtered.isEmpty
                                ? EmptyState(
                                    isRtl: isRtl,
                                    isDark: isDark,
                                    suggestions: _suggestions(all),
                                    onSelectSuggestion: (s) {
                                      setState(() {
                                        _isSearching = true;
                                        _searchController.text = s;
                                        _query = s;
                                      });
                                      _searchFocus.requestFocus();
                                    },
                                  )
                                : RefreshIndicator(
                                    onRefresh: () => context
                                        .read<CountriesCubit>()
                                        .loadCountries(forceRefresh: true),
                                    child: ListView.separated(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      itemCount: filtered.length,
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(height: 8),
                                      itemBuilder: (context, index) {
                                        final c = filtered[index];
                                        return CountryListItem(
                                          country: c,
                                          searchQuery: _query,
                                          isFavorite:
                                              _favorites.contains(c.code.value),
                                          isDark: isDark,
                                          onToggleFavorite: () =>
                                              _toggleFavorite(c),
                                        );
                                      },
                                    ),
                                  ),
                          ),
                        ],
                      );
                    case CountriesStatus.initial:
                      return const ShimmerList();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
