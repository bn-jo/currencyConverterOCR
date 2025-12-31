import 'package:hive/hive.dart';
import '../models/exchange_rate_model.dart';
import '../services/exchange_rate_service.dart';

/// Repository for managing exchange rates with caching
class ExchangeRateRepository {
  final ExchangeRateService _service = ExchangeRateService();
  final String _boxName = 'exchange_rates';

  /// Get exchange rates with cache fallback
  Future<ExchangeRateModel> getExchangeRates(String baseCurrency) async {
    // Temporarily disable caching until Hive adapters are generated
    // Just fetch from API directly
    try {
      final rates = await _service.getExchangeRates(baseCurrency);
      return rates;
    } catch (e) {
      rethrow;
    }
  }

  /// Convert amount between currencies
  Future<ConversionResult> convertCurrency({
    required String from,
    required String to,
    required double amount,
  }) async {
    final rates = await getExchangeRates(from);
    final rate = rates.getRate(to);

    if (rate == null) {
      throw Exception('Exchange rate not found for $to');
    }

    final convertedAmount = amount * rate;

    return ConversionResult(
      sourceAmount: amount,
      targetAmount: convertedAmount,
      rate: rate,
      fromCache: rates.isFresh == false,
    );
  }

  /// Clear cached rates
  Future<void> clearCache() async {
    final box = await Hive.openBox<ExchangeRateModel>(_boxName);
    await box.clear();
  }

  /// Get cache age for a currency
  Future<Duration?> getCacheAge(String baseCurrency) async {
    final box = await Hive.openBox<ExchangeRateModel>(_boxName);
    final cached = box.get(baseCurrency);

    if (cached == null) return null;

    return DateTime.now().difference(cached.lastUpdated);
  }
}

/// Result of currency conversion
class ConversionResult {
  final double sourceAmount;
  final double targetAmount;
  final double rate;
  final bool fromCache;

  ConversionResult({
    required this.sourceAmount,
    required this.targetAmount,
    required this.rate,
    required this.fromCache,
  });
}
