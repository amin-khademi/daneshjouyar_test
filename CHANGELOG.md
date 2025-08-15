# Changelog

All notable changes to this project will be documented in this file.

## [1.0.3] - 2025-08-15
### Fixed
- CI release workflow: Flutter setup uses channel stable and caches SDK.
- Added Java 17 setup for Android builds.

### Changed
- Android build tooling upgraded: Gradle 8.7, AGP 8.5.2, Kotlin 1.9.24.

### Release
- Split-per-ABI APKs uploaded via GitHub Actions on tag push.

## [1.0.0] - 2025-08-15
### Added
- Initial release (samim) with Clean Architecture, BLoC/Cubit, Dio, GoRouter, localization (en/fa), caching, and tests.
