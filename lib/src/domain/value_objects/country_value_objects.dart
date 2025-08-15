import 'package:equatable/equatable.dart';

/// Value Object for Country Code following DDD principles
class CountryCode extends Equatable {
  final String value;

  const CountryCode._(this.value);

  /// Factory constructor with validation (Domain Rules)
  factory CountryCode.create(String code) {
    if (code.isEmpty) {
      throw ArgumentError('Country code cannot be empty');
    }
    if (code.length < 2 || code.length > 3) {
      throw ArgumentError('Country code must be 2-3 characters');
    }
    return CountryCode._(code.toUpperCase());
  }

  @override
  List<Object?> get props => [value];

  @override
  String toString() => value;
}

/// Value Object for Country Name following DDD principles
class CountryName extends Equatable {
  final String value;

  const CountryName._(this.value);

  /// Factory constructor with validation
  factory CountryName.create(String name) {
    if (name.isEmpty) {
      throw ArgumentError('Country name cannot be empty');
    }
    if (name.length > 100) {
      throw ArgumentError('Country name too long');
    }
    return CountryName._(name.trim());
  }

  @override
  List<Object?> get props => [value];

  @override
  String toString() => value;
}

/// Value Object for Capital Name following DDD principles
class CapitalName extends Equatable {
  final String value;

  const CapitalName._(this.value);

  /// Factory constructor with validation
  factory CapitalName.create(String capital) {
    if (capital.isEmpty) {
      throw ArgumentError('Capital name cannot be empty');
    }
    return CapitalName._(capital.trim());
  }

  @override
  List<Object?> get props => [value];

  @override
  String toString() => value;
}

/// Value Object for Flag URL following DDD principles
class FlagUrl extends Equatable {
  final String value;

  const FlagUrl._(this.value);

  /// Factory constructor with validation
  factory FlagUrl.create(String url) {
    if (url.isEmpty) {
      throw ArgumentError('Flag URL cannot be empty');
    }

    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasAbsolutePath) {
      throw ArgumentError('Invalid flag URL format');
    }

    return FlagUrl._(url);
  }

  @override
  List<Object?> get props => [value];

  @override
  String toString() => value;
}
