import '../../core/error/result.dart';
import '../../domain/entities/country_entity.dart';
import '../../domain/value_objects/country_value_objects.dart';

/// Data model extending domain entity
/// Handles JSON serialization/deserialization with proper error handling
class CountryModel extends CountryEntity {
  const CountryModel({
    required super.name,
    required super.capital,
    required super.code,
    required super.flag,
  });

  /// Factory constructor with comprehensive error handling
  /// Follows Fail-Fast principle for validation
  factory CountryModel.fromJson(Map<String, dynamic> json) {
    try {
      final name = json['name'] as String? ?? '';
      final capital = json['capital'] as String? ?? '';
      final code = json['code'] as String? ?? '';
      final flag = json['flag'] as String? ?? '';

      // Validate required fields
      if (name.isEmpty) throw ArgumentError('Country name is required');
      if (code.isEmpty) throw ArgumentError('Country code is required');
      if (capital.isEmpty) throw ArgumentError('Capital is required');
      if (flag.isEmpty) throw ArgumentError('Flag URL is required');

      return CountryModel(
        name: CountryName.create(name),
        capital: CapitalName.create(capital),
        code: CountryCode.create(code),
        flag: FlagUrl.create(flag),
      );
    } catch (e) {
      throw ArgumentError('Invalid country data: ${e.toString()}');
    }
  }

  /// Safe factory constructor that returns Result instead of throwing
  static Result<CountryModel> fromJsonSafe(Map<String, dynamic> json) {
    try {
      return Success(CountryModel.fromJson(json));
    } catch (e) {
      return Failure(
          ValidationError('Failed to parse country: ${e.toString()}'));
    }
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name.value,
      'capital': capital.value,
      'code': code.value,
      'flag': flag.value,
    };
  }

  /// Create from entity (for caching purposes)
  factory CountryModel.fromEntity(CountryEntity entity) {
    return CountryModel(
      name: entity.name,
      capital: entity.capital,
      code: entity.code,
      flag: entity.flag,
    );
  }
}
