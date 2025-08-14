import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/error/result.dart';
import '../../domain/entities/country_entity.dart';
import '../models/country_model.dart';
import 'countries_cache_config.dart';
import 'countries_local_data_source.dart';

/// Local data source implementation using SharedPreferences
/// Follows Single Responsibility and Dependency Inversion principles
class CountriesLocalDataSourceImpl implements CountriesLocalDataSource {
  final SharedPreferences _sharedPreferences;
  final CountriesCacheConfig _config;

  CountriesLocalDataSourceImpl(
    this._sharedPreferences, {
    CountriesCacheConfig config = CountriesCacheConfig.defaults,
  }) : _config = config;

  @override
  Future<List<CountryEntity>> getCachedCountries() async {
    try {
      final countriesJson = _sharedPreferences.getString(_config.countriesKey);

      if (countriesJson == null) {
        throw const CacheError('No cached countries found');
      }

      if (!await isCacheValid()) {
        throw const CacheError('Cache expired');
      }

      final List<dynamic> jsonList = json.decode(countriesJson);
      final countries = jsonList
          .map((jsonItem) =>
              CountryModel.fromJson(jsonItem as Map<String, dynamic>))
          .toList();

      return countries;
    } catch (e) {
      if (e is CacheError) rethrow;
      throw CacheError('Failed to get cached countries: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheCountries(List<CountryEntity> countries) async {
    try {
      final jsonList = countries
          .map((country) => CountryModel.fromEntity(country).toJson())
          .toList();

      final jsonString = json.encode(jsonList);

      await _sharedPreferences.setString(_config.countriesKey, jsonString);
      await _sharedPreferences.setInt(
          _config.timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      throw CacheError('Failed to cache countries: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _sharedPreferences.remove(_config.countriesKey);
      await _sharedPreferences.remove(_config.timestampKey);
    } catch (e) {
      throw CacheError('Failed to clear cache: ${e.toString()}');
    }
  }

  @override
  Future<bool> isCacheValid() async {
    try {
      final timestamp = _sharedPreferences.getInt(_config.timestampKey);

      if (timestamp == null) return false;

      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();

      return now.difference(cacheTime) < _config.cacheExpiry;
    } catch (e) {
      return false;
    }
  }
}
