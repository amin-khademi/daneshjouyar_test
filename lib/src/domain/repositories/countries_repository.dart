import '../../core/error/result.dart';
import '../entities/country_entity.dart';

/// Repository contract following Interface Segregation Principle
/// Uses Result pattern for better error handling
abstract class CountriesRepository {
  /// Fetch all countries from remote data source
  Future<Result<List<CountryEntity>>> getCountries();

  /// Fetch countries from cache
  Future<Result<List<CountryEntity>>> getCachedCountries();

  /// Cache countries locally
  Future<Result<void>> cacheCountries(List<CountryEntity> countries);

  /// Search countries by name
  Future<Result<List<CountryEntity>>> searchCountries(String query);
}
