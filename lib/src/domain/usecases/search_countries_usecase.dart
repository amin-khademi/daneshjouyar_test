import '../../core/error/result.dart';
import '../entities/country_entity.dart';
import '../repositories/countries_repository.dart';
import 'base_usecase.dart';

/// Parameters for search countries use case
class SearchCountriesParams {
  final String query;

  const SearchCountriesParams({required this.query});
}

/// Use case for searching countries following Single Responsibility Principle
/// Implements domain validation and business rules
class SearchCountriesUseCase
    extends UseCase<List<CountryEntity>, SearchCountriesParams> {
  final CountriesRepository _repository;

  SearchCountriesUseCase(this._repository);

  @override
  Result<void> validate(SearchCountriesParams params) {
    if (params.query.isEmpty) {
      return const Failure(ValidationError('Search query cannot be empty'));
    }

    if (params.query.length < 2) {
      return const Failure(
          ValidationError('Search query must be at least 2 characters'));
    }

    return const Success(null);
  }

  @override
  Future<Result<List<CountryEntity>>> call(SearchCountriesParams params) async {
    // Validate input
    final validationResult = validate(params);
    if (validationResult.isFailure) {
      return Failure(validationResult.errorOrNull!);
    }

    try {
      // Delegate to repository
      return await _repository.searchCountries(params.query);
    } catch (e) {
      return Failure(UnknownError(e.toString()));
    }
  }
}
