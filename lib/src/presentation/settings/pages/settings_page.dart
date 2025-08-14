import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../cubit/settings_cubit.dart';
import '../widgets/info_item.dart';
import '../widgets/language_option.dart';
import '../widgets/settings_card.dart';
import '../widgets/settings_section_header.dart';
import '../widgets/theme_option.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRtl = Localizations.localeOf(context).languageCode == 'fa';

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor:
            isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.settings,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.white,
            ),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Theme Section
                  SettingsSectionHeader(
                    title: AppLocalizations.of(context)!.themeAndAppearance,
                    icon: Icons.palette_outlined,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),
                  SettingsCard(
                    isDark: isDark,
                    child: Column(
                      children: [
                        ThemeOption(
                          title: AppLocalizations.of(context)!.lightMode,
                          subtitle: AppLocalizations.of(context)!.useLightTheme,
                          icon: Icons.light_mode,
                          isSelected: state.themeMode == ThemeMode.light,
                          onTap: () {
                            if (state.themeMode != ThemeMode.light) {
                              context.read<SettingsCubit>().toggleTheme();
                            }
                          },
                          isDark: isDark,
                        ),
                        const Divider(height: 1),
                        ThemeOption(
                          title: AppLocalizations.of(context)!.darkMode,
                          subtitle: AppLocalizations.of(context)!.useDarkTheme,
                          icon: Icons.dark_mode,
                          isSelected: state.themeMode == ThemeMode.dark,
                          onTap: () {
                            if (state.themeMode != ThemeMode.dark) {
                              context.read<SettingsCubit>().toggleTheme();
                            }
                          },
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Language Section
                  SettingsSectionHeader(
                    title: AppLocalizations.of(context)!.language,
                    icon: Icons.language_outlined,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),
                  SettingsCard(
                    isDark: isDark,
                    child: Column(
                      children: [
                        LanguageOption(
                          title: AppLocalizations.of(context)!.english,
                          subtitle: AppLocalizations.of(context)!.englishFull,
                          flag: '🇺🇸',
                          isSelected: state.locale.languageCode == 'en',
                          onTap: () {
                            context.read<SettingsCubit>().changeLanguage(
                                  const Locale('en', 'US'),
                                );
                          },
                          isDark: isDark,
                        ),
                        const Divider(height: 1),
                        LanguageOption(
                          title: AppLocalizations.of(context)!.persian,
                          subtitle: AppLocalizations.of(context)!.persianFull,
                          flag: '🇮🇷',
                          isSelected: state.locale.languageCode == 'fa',
                          onTap: () {
                            context.read<SettingsCubit>().changeLanguage(
                                  const Locale('fa', 'IR'),
                                );
                          },
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // About Section
                  SettingsSectionHeader(
                    title: AppLocalizations.of(context)!.about,
                    icon: Icons.info_outline,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),
                  SettingsCard(
                    isDark: isDark,
                    child: Column(
                      children: [
                        InfoItem(
                          title: AppLocalizations.of(context)!.appNameLabel,
                          value: AppLocalizations.of(context)!.appTitle,
                          icon: Icons.apps,
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
