import 'package:daneshjouyar_test/src/core/error/result.dart';
import 'package:daneshjouyar_test/src/data/datasources/countries_remote_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  // TODO: Re-enable after stabilizing Dio mocking on CI/Windows.
  group('CountriesRemoteDataSourceImpl', () {
    late _MockDio dio;
    late CountriesRemoteDataSourceImpl ds;

    setUpAll(() {
      registerFallbackValue(Options());
    });

    setUp(() {
      dio = _MockDio();
      ds = CountriesRemoteDataSourceImpl(dio);
    });

    test('parses valid list payload', () async {
      final payload = [
        {
          'name': 'فرانسه',
          'capital': 'پاریس',
          'code': 'FR',
          'flag': 'https://flagcdn.com/fr.svg',
        },
        {
          'name': 'آلمان',
          'capital': 'برلین',
          'code': 'DE',
          'flag': 'https://flagcdn.com/de.svg',
        },
      ];

      when(() => dio.get(any(), options: any(named: 'options'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: 'https://example.com'),
          statusCode: 200,
          data: payload,
        ),
      );

      final result = await ds.fetchCountries();
      expect(result.length, 2);
      expect(result.first.name.value, 'France');
    });

    test('throws ValidationError on non-list payload', () async {
      when(() => dio.get(any(), options: any(named: 'options'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: 'https://example.com'),
          statusCode: 200,
          data: {'name': 'x'},
        ),
      );

      expect(
        () async => ds.fetchCountries(),
        throwsA(isA<ValidationError>()),
      );
    });

    test('maps Dio badResponse to ServerError', () async {
      when(() => dio.get(any(), options: any(named: 'options'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: 'https://example.com'),
          statusCode: 500,
          data: 'oops',
        ),
      );

      expect(
        () async => ds.fetchCountries(),
        throwsA(isA<ServerError>()),
      );
    });
  });
}
