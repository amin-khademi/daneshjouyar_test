import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/error/result.dart';
import '../../../domain/entities/country_entity.dart';
import '../../../domain/usecases/base_usecase.dart';
import '../../../domain/usecases/get_countries_usecase.dart';

part 'countries_state.dart';

class CountriesCubit extends Cubit<CountriesState> {
  final GetCountriesUseCase _getCountries;
  CountriesCubit(this._getCountries) : super(const CountriesState.initial());

  Future<void> loadCountries({bool forceRefresh = false}) async {
    if (state.status == CountriesStatus.loading && !forceRefresh) {
      return;
    }
    emit(state.copyWith(status: CountriesStatus.loading));
    try {
      final result = forceRefresh
          ? await _getCountries.execute(forceRefresh: true)
          : await _getCountries(const NoParams());

      result.fold(
        (countries) => emit(state.copyWith(
          status: CountriesStatus.success,
          countries: countries,
        )),
        (error) {
          String message = 'خطا در دریافت اطلاعات';
          if (error is NetworkError) message = 'مشکل در اتصال اینترنت';
          if (error is ValidationError) message = 'خطا در پردازش داده‌ها';
          if (error is CacheError) message = 'مشکل در ذخیره‌سازی';
          emit(state.copyWith(status: CountriesStatus.failure, error: message));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: CountriesStatus.failure,
        error: 'خطای غیرمنتظره: ${e.toString()}',
      ));
    }
  }
}
