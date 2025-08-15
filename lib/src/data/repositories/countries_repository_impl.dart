import '../../core/error/result.dart';
import '../../domain/entities/country_entity.dart';
import '../../domain/repositories/countries_repository.dart';
import '../datasources/countries_local_data_source.dart';
import '../datasources/countries_remote_data_source.dart';

/// Repository implementation following Dependency Inversion Principle
/// Implements Repository pattern with caching strategy
class CountriesRepositoryImpl implements CountriesRepository {
  final CountriesRemoteDataSource _remoteDataSource;
  final CountriesLocalDataSource _localDataSource;

  CountriesRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  @override
  Future<Result<List<CountryEntity>>> getCountries() async {
    try {
      final countries = await _remoteDataSource.fetchCountries();
      return Success(countries);
    } on NetworkError catch (e) {
      return Failure(e);
    } on ServerError catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(
          UnknownError('Failed to fetch countries: ${e.toString()}'));
    }
  }

  @override
  Future<Result<List<CountryEntity>>> getCachedCountries() async {
    try {
      final countries = await _localDataSource.getCachedCountries();
      return Success(countries);
    } on CacheError catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(
          UnknownError('Failed to get cached countries: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void>> cacheCountries(List<CountryEntity> countries) async {
    try {
      await _localDataSource.cacheCountries(countries);
      return const Success(null);
    } on CacheError catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(
          UnknownError('Failed to cache countries: ${e.toString()}'));
    }
  }

  @override
  Future<Result<List<CountryEntity>>> searchCountries(String query) async {
    try {
      // First try cache
      final cacheResult = await getCachedCountries();
      if (cacheResult.isSuccess) {
        final filteredCountries = cacheResult.dataOrNull!
            .where((country) =>
                country.name.value
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                country.capital.value
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                country.code.value.toLowerCase().contains(query.toLowerCase()))
            .toList();
        return Success(filteredCountries);
      }

      // If no cache, fetch from remote and filter
      final remoteResult = await getCountries();
      if (remoteResult.isSuccess) {
        final filteredCountries = remoteResult.dataOrNull!
            .where((country) =>
                country.name.value
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                country.capital.value
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                country.code.value.toLowerCase().contains(query.toLowerCase()))
            .toList();
        return Success(filteredCountries);
      }

      return remoteResult;
    } catch (e) {
      return Failure(
          UnknownError('Failed to search countries: ${e.toString()}'));
    }
  }
}
