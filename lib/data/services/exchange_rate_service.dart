import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import '../../core/config/api_keys.dart';
import '../models/exchange_rate_model.dart';

/// Service for fetching exchange rates from API
class ExchangeRateService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.exchangeRateApiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  /// Fetch latest exchange rates for a base currency
  Future<ExchangeRateModel> getExchangeRates(String baseCurrency) async {
    try {
      final response = await _dio.get(
        '/latest',
        queryParameters: {'from': baseCurrency},
      );

      if (response.statusCode == 200) {
        // Transform the response to match our model
        final data = response.data;
        print('API Response for $baseCurrency: ${data.keys}');

        // Frankfurter API returns rates without including the base currency
        // So we need to add it manually with rate 1.0
        final ratesData = data['rates'] as Map<String, dynamic>;
        final rates = ratesData.map(
          (key, value) => MapEntry(key, (value as num).toDouble()),
        );

        // Add the base currency with rate 1.0
        rates[baseCurrency] = 1.0;

        print('Base: ${data['base']}, Number of rates: ${rates.length}');

        return ExchangeRateModel(
          baseCurrency: data['base'] ?? baseCurrency,
          rates: rates,
          lastUpdated: DateTime.now(),
        );
      } else {
        throw Exception('Failed to fetch exchange rates: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('No internet connection.');
      } else {
        throw Exception('Failed to fetch exchange rates: ${e.message}');
      }
    } catch (e) {
      print('Error in getExchangeRates: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  /// Convert amount between two currencies
  Future<double> convertCurrency({
    required String from,
    required String to,
    required double amount,
  }) async {
    final rates = await getExchangeRates(from);
    final rate = rates.getRate(to);

    if (rate == null) {
      throw Exception('Exchange rate not found for $to');
    }

    return amount * rate;
  }

  /// Get exchange rate between two currencies
  Future<double> getRate({
    required String from,
    required String to,
  }) async {
    final rates = await getExchangeRates(from);
    final rate = rates.getRate(to);

    if (rate == null) {
      throw Exception('Exchange rate not found for $to');
    }

    return rate;
  }
}
