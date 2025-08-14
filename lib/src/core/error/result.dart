import 'package:equatable/equatable.dart';

/// Generic Result type following Railway-oriented programming
/// Implements Either pattern for better error handling
sealed class Result<T> extends Equatable {
  const Result();
}

/// Success case containing data
class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  List<Object?> get props => [data];
}

/// Failure case containing error
class Failure<T> extends Result<T> {
  final AppError error;

  const Failure(this.error);

  @override
  List<Object?> get props => [error];
}

/// Base error class following clean architecture
abstract class AppError extends Equatable {
  final String message;
  final String? code;

  const AppError(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Network related errors
class NetworkError extends AppError {
  const NetworkError(super.message, {super.code});
}

/// Server related errors
class ServerError extends AppError {
  final int statusCode;

  const ServerError(super.message, this.statusCode, {super.code});

  @override
  List<Object?> get props => [message, code, statusCode];
}

/// Cache related errors
class CacheError extends AppError {
  const CacheError(super.message, {super.code});
}

/// Validation errors
class ValidationError extends AppError {
  const ValidationError(super.message, {super.code});
}

/// Unknown errors
class UnknownError extends AppError {
  const UnknownError([super.message = 'An unknown error occurred']);
}

/// Extensions for better usability
extension ResultExtensions<T> on Result<T> {
  /// Check if result is success
  bool get isSuccess => this is Success<T>;

  /// Check if result is failure
  bool get isFailure => this is Failure<T>;

  /// Get data if success, null otherwise
  T? get dataOrNull => switch (this) {
        Success(data: final data) => data,
        Failure() => null,
      };

  /// Get error if failure, null otherwise
  AppError? get errorOrNull => switch (this) {
        Success() => null,
        Failure(error: final error) => error,
      };

  /// Fold the result to a single value
  R fold<R>(
    R Function(T data) onSuccess,
    R Function(AppError error) onFailure,
  ) {
    return switch (this) {
      Success(data: final data) => onSuccess(data),
      Failure(error: final error) => onFailure(error),
    };
  }

  /// Map the success value
  Result<R> map<R>(R Function(T) mapper) {
    return switch (this) {
      Success(data: final data) => Success(mapper(data)),
      Failure(error: final error) => Failure(error),
    };
  }
}
