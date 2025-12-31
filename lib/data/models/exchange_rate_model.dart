import 'package:hive/hive.dart';

part 'exchange_rate_model.g.dart';

@HiveType(typeId: 1)
class ExchangeRateModel {
  @HiveField(0)
  final String baseCurrency;

  @HiveField(1)
  final Map<String, double> rates;

  @HiveField(2)
  final DateTime lastUpdated;

  ExchangeRateModel({
    required this.baseCurrency,
    required this.rates,
    required this.lastUpdated,
  });

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) {
    final conversionRates = json['conversion_rates'] as Map<String, dynamic>;
    final rates = conversionRates.map(
      (key, value) => MapEntry(key, (value as num).toDouble()),
    );

    return ExchangeRateModel(
      baseCurrency: json['base_code'] as String,
      rates: rates,
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'base_code': baseCurrency,
      'conversion_rates': rates,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }

  /// Get exchange rate for a specific currency
  double? getRate(String currencyCode) {
    return rates[currencyCode];
  }

  /// Convert amount from base currency to target currency
  double? convert(String targetCurrency, double amount) {
    final rate = getRate(targetCurrency);
    if (rate == null) return null;
    return amount * rate;
  }

  /// Check if rates are still fresh
  bool get isFresh {
    final now = DateTime.now();
    final difference = now.difference(lastUpdated);
    return difference.inHours < 12; // Fresh for 12 hours
  }
}
