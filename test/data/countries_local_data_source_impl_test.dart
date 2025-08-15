import 'dart:convert';

import 'package:daneshjouyar_test/src/core/error/result.dart';
import 'package:daneshjouyar_test/src/data/datasources/countries_cache_config.dart';
import 'package:daneshjouyar_test/src/data/datasources/countries_local_data_source_impl.dart';
import 'package:daneshjouyar_test/src/domain/entities/country_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('CountriesLocalDataSourceImpl', () {
    late SharedPreferences prefs;
    late CountriesLocalDataSourceImpl ds;
    const cfg = CountriesCacheConfig();

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      ds = CountriesLocalDataSourceImpl(prefs, config: cfg);
    });

    test('returns cached countries when cache valid', () async {
      final jsonList = [
        {
          'name': 'فرانسه',
          'capital': 'پاریس',
          'code': 'FR',
          'flag': 'https://flagcdn.com/w320/fr.png',
        }
      ];
      await prefs.setString(cfg.countriesKey, json.encode(jsonList));
      await prefs.setInt(
          cfg.timestampKey, DateTime.now().millisecondsSinceEpoch);

  final list = await ds.getCachedCountries();
  expect(list.length, 1);
  // Assert on stable field (country code) to avoid locale-specific names
  expect(list.first.code.value, 'FR');
    });

    test('throws when no cache', () async {
      expect(() => ds.getCachedCountries(), throwsA(isA<CacheError>()));
    });

    test('throws when cache expired', () async {
      final jsonList = [
        {
          'name': 'فرانسه',
          'capital': 'پاریس',
          'code': 'FR',
          'flag': 'https://flagcdn.com/w320/fr.png',
        }
      ];
      await prefs.setString(cfg.countriesKey, json.encode(jsonList));
      final old = DateTime.now().subtract(const Duration(days: 2));
      await prefs.setInt(cfg.timestampKey, old.millisecondsSinceEpoch);

      expect(() => ds.getCachedCountries(), throwsA(isA<CacheError>()));
    });

    test('cacheCountries writes data and timestamp', () async {
      final items = [
        CountryEntity.create(
            name: 'آلمان',
            code: 'DE',
            capital: 'برلین',
            flag: 'https://flagcdn.com/w320/de.png'),
      ];
      await ds.cacheCountries(items);
      final stored = prefs.getString(cfg.countriesKey);
      final ts = prefs.getInt(cfg.timestampKey);
      expect(stored, isNotNull);
      expect(ts, isNotNull);
      final decoded = json.decode(stored!) as List<dynamic>;
      expect(decoded.first['code'], 'DE');
    });

    test('clearCache removes keys', () async {
      await prefs.setString(cfg.countriesKey, '[]');
      await prefs.setInt(
          cfg.timestampKey, DateTime.now().millisecondsSinceEpoch);
      await ds.clearCache();
      expect(prefs.getString(cfg.countriesKey), isNull);
      expect(prefs.getInt(cfg.timestampKey), isNull);
    });

    test('isCacheValid returns false when no timestamp', () async {
      expect(await ds.isCacheValid(), isFalse);
    });
  });
}
