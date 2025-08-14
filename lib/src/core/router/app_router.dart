import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/country_list/pages/countries_page.dart';
import '../../presentation/settings/pages/settings_page.dart';
import '../../presentation/splash/splash_screen.dart';
import '../constants/app_routes.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.countries,
        name: 'countries',
        builder: (context, state) => const CountriesPage(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.uri}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.countries),
              child: const Text('Go to Countries'),
            ),
          ],
        ),
      ),
    ),
  );

  static GoRouter get router => _router;
}
