import 'package:equatable/equatable.dart';

import '../value_objects/country_value_objects.dart';

/// Domain Entity representing a Country with Value Objects
/// Follows DDD principles with encapsulated business logic
class CountryEntity extends Equatable {
  final CountryName name;
  final CountryCode code;
  final CapitalName capital;
  final FlagUrl flag;

  const CountryEntity({
    required this.name,
    required this.code,
    required this.capital,
    required this.flag,
  });

  /// Factory constructor with validation
  factory CountryEntity.create({
    required String name,
    required String code,
    required String capital,
    required String flag,
  }) {
    return CountryEntity(
      name: CountryName.create(name),
      code: CountryCode.create(code),
      capital: CapitalName.create(capital),
      flag: FlagUrl.create(flag),
    );
  }

  /// Business rule: Check if country is in Europe
  bool get isInEurope {
    // Simple implementation - in real app, this could be more sophisticated
    const europeanCodes = [
      'AD',
      'AL',
      'AT',
      'BY',
      'BE',
      'BA',
      'BG',
      'HR',
      'CY',
      'CZ',
      'DK',
      'EE',
      'FI',
      'FR',
      'DE',
      'GR',
      'HU',
      'IS',
      'IE',
      'IT',
      'LV',
      'LI',
      'LT',
      'LU',
      'MT',
      'MD',
      'MC',
      'ME',
      'NL',
      'MK',
      'NO',
      'PL',
      'PT',
      'RO',
      'RU',
      'SM',
      'RS',
      'SK',
      'SI',
      'ES',
      'SE',
      'CH',
      'UA',
      'GB',
      'VA'
    ];
    return europeanCodes.contains(code.value);
  }

  /// Business rule: Check if country has same capital name
  bool get hasSameCapitalName {
    return name.value.toLowerCase() == capital.value.toLowerCase();
  }

  @override
  List<Object> get props => [name, code, capital, flag];
}
