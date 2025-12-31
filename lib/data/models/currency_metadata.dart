/// Complete currency metadata
class CurrencyMetadata {
  final String code;
  final String name;
  final String symbol;
  final String? flag;
  final int decimalDigits;
  final String? namePlural;
  final List<String> countries;

  const CurrencyMetadata({
    required this.code,
    required this.name,
    required this.symbol,
    this.flag,
    this.decimalDigits = 2,
    this.namePlural,
    required this.countries,
  });
}

/// Complete list of supported currencies with metadata
class CurrencyDatabase {
  static const Map<String, CurrencyMetadata> currencies = {
    'USD': CurrencyMetadata(
      code: 'USD',
      name: 'US Dollar',
      symbol: '\$',
      flag: '🇺🇸',
      namePlural: 'US dollars',
      countries: ['United States'],
    ),
    'EUR': CurrencyMetadata(
      code: 'EUR',
      name: 'Euro',
      symbol: '€',
      flag: '🇪🇺',
      namePlural: 'euros',
      countries: ['Germany', 'France', 'Italy', 'Spain', 'Netherlands'],
    ),
    'GBP': CurrencyMetadata(
      code: 'GBP',
      name: 'British Pound',
      symbol: '£',
      flag: '🇬🇧',
      namePlural: 'pounds sterling',
      countries: ['United Kingdom'],
    ),
    'JPY': CurrencyMetadata(
      code: 'JPY',
      name: 'Japanese Yen',
      symbol: '¥',
      flag: '🇯🇵',
      decimalDigits: 0,
      namePlural: 'yen',
      countries: ['Japan'],
    ),
    'CHF': CurrencyMetadata(
      code: 'CHF',
      name: 'Swiss Franc',
      symbol: 'CHF',
      flag: '🇨🇭',
      namePlural: 'Swiss francs',
      countries: ['Switzerland'],
    ),
    'CAD': CurrencyMetadata(
      code: 'CAD',
      name: 'Canadian Dollar',
      symbol: 'C\$',
      flag: '🇨🇦',
      namePlural: 'Canadian dollars',
      countries: ['Canada'],
    ),
    'AUD': CurrencyMetadata(
      code: 'AUD',
      name: 'Australian Dollar',
      symbol: 'A\$',
      flag: '🇦🇺',
      namePlural: 'Australian dollars',
      countries: ['Australia'],
    ),
    'CNY': CurrencyMetadata(
      code: 'CNY',
      name: 'Chinese Yuan',
      symbol: '¥',
      flag: '🇨🇳',
      namePlural: 'yuan',
      countries: ['China'],
    ),
    'INR': CurrencyMetadata(
      code: 'INR',
      name: 'Indian Rupee',
      symbol: '₹',
      flag: '🇮🇳',
      namePlural: 'rupees',
      countries: ['India'],
    ),
    'MXN': CurrencyMetadata(
      code: 'MXN',
      name: 'Mexican Peso',
      symbol: '\$',
      flag: '🇲🇽',
      namePlural: 'Mexican pesos',
      countries: ['Mexico'],
    ),
    'BRL': CurrencyMetadata(
      code: 'BRL',
      name: 'Brazilian Real',
      symbol: 'R\$',
      flag: '🇧🇷',
      namePlural: 'reais',
      countries: ['Brazil'],
    ),
    'RUB': CurrencyMetadata(
      code: 'RUB',
      name: 'Russian Ruble',
      symbol: '₽',
      flag: '🇷🇺',
      namePlural: 'rubles',
      countries: ['Russia'],
    ),
    'KRW': CurrencyMetadata(
      code: 'KRW',
      name: 'South Korean Won',
      symbol: '₩',
      flag: '🇰🇷',
      decimalDigits: 0,
      namePlural: 'won',
      countries: ['South Korea'],
    ),
    'ILS': CurrencyMetadata(
      code: 'ILS',
      name: 'Israeli Shekel',
      symbol: '₪',
      flag: '🇮🇱',
      namePlural: 'shekels',
      countries: ['Israel'],
    ),
    'SEK': CurrencyMetadata(
      code: 'SEK',
      name: 'Swedish Krona',
      symbol: 'kr',
      flag: '🇸🇪',
      namePlural: 'kronor',
      countries: ['Sweden'],
    ),
    'NOK': CurrencyMetadata(
      code: 'NOK',
      name: 'Norwegian Krone',
      symbol: 'kr',
      flag: '🇳🇴',
      namePlural: 'kroner',
      countries: ['Norway'],
    ),
    'DKK': CurrencyMetadata(
      code: 'DKK',
      name: 'Danish Krone',
      symbol: 'kr',
      flag: '🇩🇰',
      namePlural: 'kroner',
      countries: ['Denmark'],
    ),
    'PLN': CurrencyMetadata(
      code: 'PLN',
      name: 'Polish Zloty',
      symbol: 'zł',
      flag: '🇵🇱',
      namePlural: 'zlotys',
      countries: ['Poland'],
    ),
    'TRY': CurrencyMetadata(
      code: 'TRY',
      name: 'Turkish Lira',
      symbol: '₺',
      flag: '🇹🇷',
      namePlural: 'lira',
      countries: ['Turkey'],
    ),
    'NZD': CurrencyMetadata(
      code: 'NZD',
      name: 'New Zealand Dollar',
      symbol: 'NZ\$',
      flag: '🇳🇿',
      namePlural: 'New Zealand dollars',
      countries: ['New Zealand'],
    ),
    'SGD': CurrencyMetadata(
      code: 'SGD',
      name: 'Singapore Dollar',
      symbol: 'S\$',
      flag: '🇸🇬',
      namePlural: 'Singapore dollars',
      countries: ['Singapore'],
    ),
    'HKD': CurrencyMetadata(
      code: 'HKD',
      name: 'Hong Kong Dollar',
      symbol: 'HK\$',
      flag: '🇭🇰',
      namePlural: 'Hong Kong dollars',
      countries: ['Hong Kong'],
    ),
    'ZAR': CurrencyMetadata(
      code: 'ZAR',
      name: 'South African Rand',
      symbol: 'R',
      flag: '🇿🇦',
      namePlural: 'rand',
      countries: ['South Africa'],
    ),
    'THB': CurrencyMetadata(
      code: 'THB',
      name: 'Thai Baht',
      symbol: '฿',
      flag: '🇹🇭',
      namePlural: 'baht',
      countries: ['Thailand'],
    ),
    'AED': CurrencyMetadata(
      code: 'AED',
      name: 'UAE Dirham',
      symbol: 'د.إ',
      flag: '🇦🇪',
      namePlural: 'dirhams',
      countries: ['United Arab Emirates'],
    ),
    'SAR': CurrencyMetadata(
      code: 'SAR',
      name: 'Saudi Riyal',
      symbol: '﷼',
      flag: '🇸🇦',
      namePlural: 'riyals',
      countries: ['Saudi Arabia'],
    ),
  };

  /// Get currency metadata by code
  static CurrencyMetadata? get(String code) {
    return currencies[code.toUpperCase()];
  }

  /// Get all currency codes
  static List<String> getAllCodes() {
    return currencies.keys.toList();
  }

  /// Search currencies by name or code
  static List<CurrencyMetadata> search(String query) {
    final lowerQuery = query.toLowerCase();
    return currencies.values.where((currency) {
      return currency.code.toLowerCase().contains(lowerQuery) ||
             currency.name.toLowerCase().contains(lowerQuery) ||
             currency.countries.any(
               (country) => country.toLowerCase().contains(lowerQuery),
             );
    }).toList();
  }

  /// Get popular currencies
  static List<String> getPopularCurrencies() {
    return [
      'USD',
      'EUR',
      'GBP',
      'JPY',
      'CAD',
      'AUD',
      'CHF',
      'CNY',
      'INR',
      'MXN',
    ];
  }

  /// Format amount with currency
  static String formatAmount(double amount, String currencyCode) {
    final currency = get(currencyCode);
    if (currency == null) {
      return '$amount $currencyCode';
    }

    final formatted = amount.toStringAsFixed(currency.decimalDigits);
    return '${currency.symbol}$formatted';
  }
}
