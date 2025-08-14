import '../../core/error/result.dart';
import '../entities/country_entity.dart';
import '../repositories/countries_repository.dart';
import 'base_usecase.dart';

/// Use case for fetching countries following Single Responsibility Principle
/// Implements Cache-aside pattern for performance optimization
class GetCountriesUseCase extends NoParamsUseCase<List<CountryEntity>> {
  final CountriesRepository _repository;

  GetCountriesUseCase(this._repository);

  @override
  Future<Result<List<CountryEntity>>> call(NoParams params) async {
    try {
      // First try to get from cache
      final cacheResult = await _repository.getCachedCountries();

      if (cacheResult.isSuccess && cacheResult.dataOrNull!.isNotEmpty) {
        return cacheResult;
      }

      // If cache miss or empty, fetch from network
      final networkResult = await _repository.getCountries();

      if (networkResult.isSuccess) {
        // Cache the result for future use
        await _repository.cacheCountries(networkResult.dataOrNull!);
      }

      return networkResult;
    } catch (e) {
      return Failure(UnknownError(e.toString()));
    }
  }

  /// Execute a fetch with options, e.g. forceRefresh to bypass cache
  Future<Result<List<CountryEntity>>> execute(
      {bool forceRefresh = false}) async {
    if (!forceRefresh) {
      return call(const NoParams());
    }
    try {
      final networkResult = await _repository.getCountries();
      if (networkResult.isSuccess) {
        await _repository.cacheCountries(networkResult.dataOrNull!);
      }
      return networkResult;
    } catch (e) {
      return Failure(UnknownError(e.toString()));
    }
  }
}
