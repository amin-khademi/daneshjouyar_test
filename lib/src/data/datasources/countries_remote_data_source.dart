import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../core/error/result.dart';
import '../models/country_model.dart';

/// Abstract contract for remote data source following Interface Segregation
abstract class CountriesRemoteDataSource {
  Future<List<CountryModel>> fetchCountries();
}

/// Remote data source implementation with comprehensive error handling
/// Follows Single Responsibility and Open/Closed principles
class CountriesRemoteDataSourceImpl implements CountriesRemoteDataSource {
  final Dio _dio;

  CountriesRemoteDataSourceImpl(this._dio);

  static final _url = dotenv.maybeGet('COUNTRIES_URL')?.trim().isNotEmpty ==
          true
      ? dotenv.get('COUNTRIES_URL')
      : 'https://raw.githubusercontent.com/PouriaMoradi021/countries-api/refs/heads/main/countries.json';

  @override
  Future<List<CountryModel>> fetchCountries() async {
    try {
      final response = await _dio.get(
        _url,
        options: Options(
          responseType: ResponseType.json,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw ServerError(
          'Server returned ${response.statusCode}',
          response.statusCode!,
        );
      }

      final List<dynamic> jsonList = _parseResponse(response.data);

      final countries = <CountryModel>[];
      for (final jsonItem in jsonList) {
        final result =
            CountryModel.fromJsonSafe(jsonItem as Map<String, dynamic>);
        if (result.isSuccess) {
          countries.add(result.dataOrNull!);
        }
        // Skip invalid items instead of failing the entire request
      }

      if (countries.isEmpty) {
        throw const ServerError('No valid countries found in response', 200);
      }

      return countries;
    } on SocketException {
      throw const NetworkError('No internet connection');
    } on DioException catch (e) {
      throw _handleDioError(e);
    } on FormatException catch (e) {
      throw ValidationError('Invalid JSON format: ${e.message}');
    } catch (e) {
      if (e is AppError) rethrow;
      throw UnknownError('Failed to fetch countries: ${e.toString()}');
    }
  }

  /// Parse response data to ensure it's a valid list
  List<dynamic> _parseResponse(dynamic data) {
    if (data is Uint8List) {
      final decodedStr = utf8.decode(data);
      final decoded = jsonDecode(decodedStr);
      if (decoded is! List) {
        throw const ValidationError('Expected JSON array');
      }
      return decoded;
    } else if (data is String) {
      final decoded = jsonDecode(data);
      if (decoded is! List) {
        throw const ValidationError('Expected JSON array');
      }
      return decoded;
    } else if (data is List) {
      return data;
    } else {
      throw const ValidationError('Unsupported response format');
    }
  }

  /// Handle Dio errors with specific error types
  AppError _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkError('Request timeout');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 0;
        return ServerError(
          'Server error: ${e.message}',
          statusCode,
        );
      case DioExceptionType.cancel:
        return const NetworkError('Request cancelled');
      case DioExceptionType.connectionError:
        return const NetworkError('Connection error');
      case DioExceptionType.badCertificate:
        return const NetworkError('Bad certificate');
      default:
        return NetworkError('Network error: ${e.message}');
    }
  }
}
