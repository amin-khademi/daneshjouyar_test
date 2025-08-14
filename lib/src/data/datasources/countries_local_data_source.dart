import '../../domain/entities/country_entity.dart';

/// Abstract contract for local data source following Interface Segregation
abstract class CountriesLocalDataSource {
  /// Get cached countries
  Future<List<CountryEntity>> getCachedCountries();

  /// Cache countries locally
  Future<void> cacheCountries(List<CountryEntity> countries);

  /// Clear cache
  Future<void> clearCache();

  /// Check if cache exists and is valid
  Future<bool> isCacheValid();
}
