import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  final Dio dio;

  ApiClient(this.dio) {
    // Resolve base URL from environment (fallback empty means use absolute URLs per-call)
    final baseUrl =
        dotenv.env['API_BASE_URL'] ?? dotenv.env['COUNTRIES_URL'] ?? '';

    dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      validateStatus: (status) =>
          status != null && status >= 200 && status < 400,
      headers: <String, dynamic>{
        'Accept': 'application/json',
      },
    );

    // Interceptors
    dio.interceptors.addAll([
      // Retry simple network/transient errors with backoff (idempotent GETs only)
      InterceptorsWrapper(
        onError: (e, handler) async {
          const maxRetries = 2;
          final requestOptions = e.requestOptions;
          final method = (requestOptions.method).toUpperCase();
          final isIdempotent = method == 'GET' || method == 'HEAD';

          // Track retry count on extra map
          final currentRetries =
              (requestOptions.extra['__retries'] as int?) ?? 0;
          final shouldRetry =
              _shouldRetry(e) && isIdempotent && currentRetries < maxRetries;

          if (shouldRetry) {
            final nextAttempt = currentRetries + 1;
            requestOptions.extra['__retries'] = nextAttempt;
            // Exponential backoff with jitter: 200ms * 2^(n-1) +/- 50ms
            final baseDelayMs = 200 * (1 << (nextAttempt - 1));
            final jitterMs = math.Random().nextInt(100) - 50; // [-50, +49]
            final delay =
                Duration(milliseconds: math.max(0, baseDelayMs + jitterMs));
            await Future<void>.delayed(delay);
            try {
              final response = await dio.fetch(requestOptions);
              return handler.resolve(response);
            } catch (err) {
              return handler.next(err is DioException ? err : e);
            }
          }
          return handler.next(e);
        },
      ),
      if (kDebugMode)
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
        ),
    ]);
  }

  /// Update the base URL at runtime (e.g., after loading remote config).
  void updateBaseUrl(String baseUrl) {
    dio.options.baseUrl = baseUrl;
  }

  static bool _shouldRetry(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode ?? 0;
        // Retry on 502/503/504 (transient server/network issues)
        return status == 502 || status == 503 || status == 504;
      case DioExceptionType.unknown:
        // Treat some unknowns (e.g., SocketException) as retryable
        return true;
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
        return false;
    }
  }
}
