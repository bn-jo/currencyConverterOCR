import '../models/exchange_rate_model.dart';
import '../repositories/exchange_rate_repository.dart';
import '../../core/utils/exchange_rate_utils.dart';

/// Service for batch currency conversions
class BatchConversionService {
  final ExchangeRateRepository _repository;

  BatchConversionService(this._repository);

  /// Convert one amount to multiple target currencies
  Future<BatchConversionResult> convertToMultipleCurrencies({
    required String sourceCurrency,
    required List<String> targetCurrencies,
    required double amount,
  }) async {
    final rates = await _repository.getExchangeRates(sourceCurrency);

    final conversions = <String, ConversionDetail>{};

    for (final targetCurrency in targetCurrencies) {
      final rate = ExchangeRateUtils.calculateCrossRate(
        baseRates: rates,
        fromCurrency: sourceCurrency,
        toCurrency: targetCurrency,
      );

      if (rate != null) {
        conversions[targetCurrency] = ConversionDetail(
          targetCurrency: targetCurrency,
          rate: rate,
          convertedAmount: amount * rate,
        );
      }
    }

    return BatchConversionResult(
      sourceCurrency: sourceCurrency,
      sourceAmount: amount,
      conversions: conversions,
      timestamp: DateTime.now(),
      fromCache: !rates.isFresh,
    );
  }

  /// Convert multiple amounts in the same source currency
  Future<Map<double, double>> convertMultipleAmounts({
    required String sourceCurrency,
    required String targetCurrency,
    required List<double> amounts,
  }) async {
    final rates = await _repository.getExchangeRates(sourceCurrency);

    final rate = ExchangeRateUtils.calculateCrossRate(
      baseRates: rates,
      fromCurrency: sourceCurrency,
      toCurrency: targetCurrency,
    );

    if (rate == null) {
      throw Exception('Exchange rate not available');
    }

    final results = <double, double>{};
    for (final amount in amounts) {
      results[amount] = amount * rate;
    }

    return results;
  }

  /// Convert amount to all available currencies
  Future<BatchConversionResult> convertToAllCurrencies({
    required String sourceCurrency,
    required double amount,
  }) async {
    final rates = await _repository.getExchangeRates(sourceCurrency);

    final conversions = <String, ConversionDetail>{};

    for (final entry in rates.rates.entries) {
      final targetCurrency = entry.key;
      final rate = entry.value;

      conversions[targetCurrency] = ConversionDetail(
        targetCurrency: targetCurrency,
        rate: rate,
        convertedAmount: amount * rate,
      );
    }

    return BatchConversionResult(
      sourceCurrency: sourceCurrency,
      sourceAmount: amount,
      conversions: conversions,
      timestamp: DateTime.now(),
      fromCache: !rates.isFresh,
    );
  }

  /// Get conversion table for multiple source and target currencies
  Future<ConversionTable> getConversionTable({
    required List<String> sourceCurrencies,
    required List<String> targetCurrencies,
    double baseAmount = 1.0,
  }) async {
    final table = <String, Map<String, double>>{};

    for (final source in sourceCurrencies) {
      final rates = await _repository.getExchangeRates(source);
      final row = <String, double>{};

      for (final target in targetCurrencies) {
        final rate = ExchangeRateUtils.calculateCrossRate(
          baseRates: rates,
          fromCurrency: source,
          toCurrency: target,
        );

        if (rate != null) {
          row[target] = baseAmount * rate;
        }
      }

      table[source] = row;
    }

    return ConversionTable(
      table: table,
      baseAmount: baseAmount,
      timestamp: DateTime.now(),
    );
  }
}

/// Result of batch conversion
class BatchConversionResult {
  final String sourceCurrency;
  final double sourceAmount;
  final Map<String, ConversionDetail> conversions;
  final DateTime timestamp;
  final bool fromCache;

  BatchConversionResult({
    required this.sourceCurrency,
    required this.sourceAmount,
    required this.conversions,
    required this.timestamp,
    required this.fromCache,
  });

  /// Get conversion for specific currency
  ConversionDetail? getConversion(String targetCurrency) {
    return conversions[targetCurrency];
  }

  /// Get all target currencies
  List<String> get targetCurrencies => conversions.keys.toList();

  /// Get total number of conversions
  int get conversionCount => conversions.length;
}

/// Detail of a single conversion
class ConversionDetail {
  final String targetCurrency;
  final double rate;
  final double convertedAmount;

  ConversionDetail({
    required this.targetCurrency,
    required this.rate,
    required this.convertedAmount,
  });
}

/// Conversion table for multiple currencies
class ConversionTable {
  final Map<String, Map<String, double>> table;
  final double baseAmount;
  final DateTime timestamp;

  ConversionTable({
    required this.table,
    required this.baseAmount,
    required this.timestamp,
  });

  /// Get rate between two currencies
  double? getRate(String from, String to) {
    return table[from]?[to];
  }

  /// Get all source currencies
  List<String> get sourceCurrencies => table.keys.toList();
}
