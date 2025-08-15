import 'package:daneshjouyar_test/src/core/error/result.dart';
import 'package:daneshjouyar_test/src/data/datasources/countries_local_data_source.dart';
import 'package:daneshjouyar_test/src/data/datasources/countries_remote_data_source.dart';
import 'package:daneshjouyar_test/src/data/models/country_model.dart';
import 'package:daneshjouyar_test/src/data/repositories/countries_repository_impl.dart';
import 'package:daneshjouyar_test/src/domain/entities/country_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRemote extends Mock implements CountriesRemoteDataSource {}

class _MockLocal extends Mock implements CountriesLocalDataSource {}

void main() {
  group('CountriesRepositoryImpl', () {
    late _MockRemote remote;
    late _MockLocal local;
    late CountriesRepositoryImpl repo;

    setUp(() {
      remote = _MockRemote();
      local = _MockLocal();
      repo = CountriesRepositoryImpl(remote, local);
    });

    test('getCountries returns Success on remote ok', () async {
      final items = [
        CountryModel.fromEntity(
          CountryEntity.create(
              name: 'فرانسه',
              code: 'FR',
              capital: 'پاریس',
              flag: 'https://flagcdn.com/w320/fr.png'),
        ),
      ];
      when(() => remote.fetchCountries()).thenAnswer((_) async => items);
      final res = await repo.getCountries();
      expect(res.isSuccess, isTrue);
      expect(res.dataOrNull!.first.code.value, 'FR');
    });

    test('getCountries returns Failure on remote error', () async {
      when(() => remote.fetchCountries()).thenThrow(const NetworkError('x'));
      final res = await repo.getCountries();
      expect(res.isFailure, isTrue);
      expect(res.errorOrNull, isA<NetworkError>());
    });

    test('getCachedCountries returns Success when local ok', () async {
      when(() => local.getCachedCountries()).thenAnswer((_) async => []);
      final res = await repo.getCachedCountries();
      expect(res.isSuccess, isTrue);
    });

    test('cacheCountries returns Success when local ok', () async {
      when(() => local.cacheCountries(any())).thenAnswer((_) async {});
      final res = await repo.cacheCountries(const []);
      expect(res.isSuccess, isTrue);
    });

    test('searchCountries uses cache first when available', () async {
      final items = [
        CountryEntity.create(
            name: 'فرانسه',
            code: 'FR',
            capital: 'پاریس',
            flag: 'https://flagcdn.com/w320/fr.png'),
        CountryEntity.create(
            name: 'آلمان',
            code: 'DE',
            capital: 'برلین',
            flag: 'https://flagcdn.com/w320/de.png'),
      ];
      when(() => local.getCachedCountries()).thenAnswer((_) async => items);
      final res = await repo.searchCountries('fr');
      expect(res.isSuccess, isTrue);
      expect(res.dataOrNull!.length, 1);
      expect(res.dataOrNull!.first.code.value, 'FR');
    });
  });
}
