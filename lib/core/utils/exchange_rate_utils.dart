import '../../data/models/exchange_rate_model.dart';

/// Utilities for exchange rate operations
class ExchangeRateUtils {
  /// Compare two exchange rates and get percentage change
  static double getPercentageChange(double oldRate, double newRate) {
    if (oldRate == 0) return 0;
    return ((newRate - oldRate) / oldRate) * 100;
  }

  /// Check if rate has increased
  static bool hasIncreased(double oldRate, double newRate) {
    return newRate > oldRate;
  }

  /// Get rate change direction
  static RateChangeDirection getRateChangeDirection(double oldRate, double newRate) {
    if (newRate > oldRate) return RateChangeDirection.up;
    if (newRate < oldRate) return RateChangeDirection.down;
    return RateChangeDirection.unchanged;
  }

  /// Calculate cross rate between two currencies
  /// Example: If we have USD->EUR and USD->GBP, calculate EUR->GBP
  static double? calculateCrossRate({
    required ExchangeRateModel baseRates,
    required String fromCurrency,
    required String toCurrency,
  }) {
    // If asking for rate to base currency
    if (toCurrency == baseRates.baseCurrency) {
      final fromRate = baseRates.getRate(fromCurrency);
      if (fromRate == null || fromRate == 0) return null;
      return 1 / fromRate;
    }

    // If asking for rate from base currency
    if (fromCurrency == baseRates.baseCurrency) {
      return baseRates.getRate(toCurrency);
    }

    // Cross rate calculation
    final fromRate = baseRates.getRate(fromCurrency);
    final toRate = baseRates.getRate(toCurrency);

    if (fromRate == null || toRate == null || fromRate == 0) {
      return null;
    }

    return toRate / fromRate;
  }

  /// Batch convert multiple amounts
  static Map<String, double> batchConvert({
    required ExchangeRateModel rates,
    required String sourceCurrency,
    required List<String> targetCurrencies,
    required double amount,
  }) {
    final results = <String, double>{};

    for (final targetCurrency in targetCurrencies) {
      final crossRate = calculateCrossRate(
        baseRates: rates,
        fromCurrency: sourceCurrency,
        toCurrency: targetCurrency,
      );

      if (crossRate != null) {
        results[targetCurrency] = amount * crossRate;
      }
    }

    return results;
  }

  /// Get inverse rate (e.g., USD->EUR to EUR->USD)
  static double? getInverseRate(double rate) {
    if (rate == 0) return null;
    return 1 / rate;
  }

  /// Round to currency precision
  static double roundToCurrencyPrecision(double amount, int decimalPlaces) {
    final factor = pow10(decimalPlaces);
    return (amount * factor).round() / factor;
  }

  /// Calculate margin/spread between two rates
  static double calculateSpread(double buyRate, double sellRate) {
    return ((sellRate - buyRate) / buyRate) * 100;
  }

  /// Get best rate from multiple sources
  static ExchangeRateModel getBestRate(List<ExchangeRateModel> ratesList) {
    if (ratesList.isEmpty) {
      throw Exception('No rates available');
    }

    // Return the most recent rate
    ratesList.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
    return ratesList.first;
  }

  /// Check if rates are stale
  static bool areRatesStale(ExchangeRateModel rates, Duration threshold) {
    final now = DateTime.now();
    final age = now.difference(rates.lastUpdated);
    return age > threshold;
  }

  /// Format rate with appropriate precision
  static String formatRate(double rate) {
    if (rate >= 100) {
      return rate.toStringAsFixed(2);
    } else if (rate >= 10) {
      return rate.toStringAsFixed(3);
    } else if (rate >= 1) {
      return rate.toStringAsFixed(4);
    } else {
      return rate.toStringAsFixed(6);
    }
  }

  /// Calculate power of 10
  static double pow10(int exponent) {
    double result = 1;
    for (int i = 0; i < exponent; i++) {
      result *= 10;
    }
    return result;
  }
}

/// Direction of rate change
enum RateChangeDirection {
  up,
  down,
  unchanged,
}

/// Rate comparison result
class RateComparison {
  final double oldRate;
  final double newRate;
  final double percentageChange;
  final RateChangeDirection direction;

  RateComparison({
    required this.oldRate,
    required this.newRate,
    required this.percentageChange,
    required this.direction,
  });

  factory RateComparison.compare(double oldRate, double newRate) {
    return RateComparison(
      oldRate: oldRate,
      newRate: newRate,
      percentageChange: ExchangeRateUtils.getPercentageChange(oldRate, newRate),
      direction: ExchangeRateUtils.getRateChangeDirection(oldRate, newRate),
    );
  }

  bool get hasChanged => direction != RateChangeDirection.unchanged;
  bool get hasIncreased => direction == RateChangeDirection.up;
  bool get hasDecreased => direction == RateChangeDirection.down;
}
