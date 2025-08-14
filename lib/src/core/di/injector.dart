import 'package:daneshjouyar_test/src/core/network/api_client.dart';
import 'package:daneshjouyar_test/src/core/services/settings_service.dart';
import 'package:daneshjouyar_test/src/data/datasources/countries_local_data_source.dart';
import 'package:daneshjouyar_test/src/data/datasources/countries_local_data_source_impl.dart';
import 'package:daneshjouyar_test/src/data/datasources/countries_remote_data_source.dart';
import 'package:daneshjouyar_test/src/data/repositories/countries_repository_impl.dart';
import 'package:daneshjouyar_test/src/domain/repositories/countries_repository.dart';
import 'package:daneshjouyar_test/src/domain/usecases/get_countries_usecase.dart';
import 'package:daneshjouyar_test/src/presentation/country_list/cubit/countries_cubit.dart';
import 'package:daneshjouyar_test/src/presentation/settings/cubit/settings_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Services
  getIt.registerLazySingleton<SettingsService>(() => SettingsService());

  // External
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<ApiClient>(() => ApiClient(getIt()));

  // Data sources
  getIt.registerLazySingleton<CountriesRemoteDataSource>(
      () => CountriesRemoteDataSourceImpl(getIt<Dio>()));

  getIt.registerLazySingleton<CountriesLocalDataSource>(
      () => CountriesLocalDataSourceImpl(getIt<SharedPreferences>()));

  // Repositories
  getIt.registerLazySingleton<CountriesRepository>(
      () => CountriesRepositoryImpl(getIt(), getIt()));

  // Use cases
  getIt.registerFactory(() => GetCountriesUseCase(getIt()));

  // Cubits
  getIt.registerFactory(() => CountriesCubit(getIt()));
  getIt.registerFactory(() => SettingsCubit(getIt<SettingsService>()));
}
