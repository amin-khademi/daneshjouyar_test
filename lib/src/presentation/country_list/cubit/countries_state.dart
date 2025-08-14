part of 'countries_cubit.dart';

enum CountriesStatus { initial, loading, success, failure }

class CountriesState extends Equatable {
  final CountriesStatus status;
  final List<CountryEntity> countries;
  final String? error;

  const CountriesState({
    required this.status,
    required this.countries,
    this.error,
  });

  const CountriesState.initial()
      : status = CountriesStatus.initial,
        countries = const [],
        error = null;

  CountriesState copyWith({
    CountriesStatus? status,
    List<CountryEntity>? countries,
    String? error,
  }) {
    return CountriesState(
      status: status ?? this.status,
      countries: countries ?? this.countries,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, countries, error];
}
