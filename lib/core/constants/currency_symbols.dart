/// Currency symbols and their corresponding currency codes
class CurrencySymbols {
  static const Map<String, String> symbolToCode = {
    '\$': 'USD',
    '€': 'EUR',
    '£': 'GBP',
    '¥': 'JPY',
    '₹': 'INR',
    '₽': 'RUB',
    'C\$': 'CAD',
    'A\$': 'AUD',
    'CHF': 'CHF',
    '¢': 'USD',
    '₩': 'KRW',
    '₪': 'ILS',
    'R\$': 'BRL',
    'kr': 'SEK',
    'zł': 'PLN',
    '₺': 'TRY',
  };

  static const Map<String, List<String>> ambiguousSymbols = {
    '\$': ['USD', 'CAD', 'AUD', 'NZD', 'SGD', 'HKD'],
    '¥': ['JPY', 'CNY'],
    'kr': ['SEK', 'NOK', 'DKK'],
  };

  static const Map<String, String> codeToSymbol = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'JPY': '¥',
    'INR': '₹',
    'RUB': '₽',
    'CAD': 'C\$',
    'AUD': 'A\$',
    'CHF': 'CHF',
    'KRW': '₩',
    'ILS': '₪',
    'BRL': 'R\$',
    'SEK': 'kr',
    'PLN': 'zł',
    'TRY': '₺',
    'CNY': '¥',
  };

  static const List<String> popularCurrencies = [
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
