import 'package:daneshjouyar_test/src/core/constants/figma_design_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'src/core/constants/app_strings.dart';
import 'src/core/di/injector.dart';
import 'src/core/localization/app_localization_config.dart';
import 'src/core/router/app_router.dart';
import 'src/core/theme/app_theme.dart';
import 'src/core/widgets/dismiss_keyboard.dart';
import 'src/presentation/country_list/cubit/countries_cubit.dart';
import 'src/presentation/settings/cubit/settings_cubit.dart';

/// Application entry point following Clean Architecture
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load environment variables from .env (e.g., API URLs, feature flags)
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // Non-fatal: app can still run without .env
  }
  await configureDependencies();
  final settingsCubit = getIt<SettingsCubit>()..initialize();
  runApp(MyApp(settingsCubit: settingsCubit));
}

/// Main application widget following Single Responsibility Principle
class MyApp extends StatelessWidget {
  final SettingsCubit settingsCubit;
  const MyApp({super.key, required this.settingsCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsCubit>.value(
      value: settingsCubit,
      child: BlocProvider<CountriesCubit>(
        create: (_) => getIt<CountriesCubit>(),
        child: Builder(
          builder: (context) {
            return BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, settingsState) {
                return ScreenUtilInit(
                  designSize: figmaDesignSize,
                  minTextAdapt: true,
                  splitScreenMode: true,
                  builder: (context, child) => DismissKeyboard(child: child!),
                  child: MaterialApp.router(
                    key: ValueKey(settingsState.locale.languageCode),
                    title: AppStrings.appTitle,
                    debugShowCheckedModeBanner: false,
                    locale: settingsState.locale,
                    supportedLocales: AppLocalizationConfig.supportedLocales,
                    localizationsDelegates: AppLocalizationConfig.delegates,
                    routerConfig: AppRouter.router,
                    theme: AppThemeConfig.lightTheme,
                    darkTheme: AppThemeConfig.darkTheme,
                    themeMode: settingsState.themeMode,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
