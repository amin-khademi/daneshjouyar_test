class CountriesCacheConfig {
  final String countriesKey;
  final String timestampKey;
  final Duration cacheExpiry;

  const CountriesCacheConfig({
    this.countriesKey = 'cached_countries',
    this.timestampKey = 'countries_cache_timestamp',
    this.cacheExpiry = const Duration(hours: 24),
  });

  static const CountriesCacheConfig defaults = CountriesCacheConfig();
}
