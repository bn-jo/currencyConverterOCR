import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/exchange_rate_repository.dart';

/// Provider for currency list state
final currencyListProvider = StateNotifierProvider<CurrencyListNotifier, CurrencyListState>((ref) {
  return CurrencyListNotifier();
});

/// Currency list state
class CurrencyListState {
  final String baseCurrency;
  final double baseAmount;
  final Map<String, double> convertedAmounts;
  final bool isLoading;
  final String? error;

  CurrencyListState({
    this.baseCurrency = 'THB',
    this.baseAmount = 0,
    this.convertedAmounts = const {},
    this.isLoading = false,
    this.error,
  });

  CurrencyListState copyWith({
    String? baseCurrency,
    double? baseAmount,
    Map<String, double>? convertedAmounts,
    bool? isLoading,
    String? error,
  }) {
    return CurrencyListState(
      baseCurrency: baseCurrency ?? this.baseCurrency,
      baseAmount: baseAmount ?? this.baseAmount,
      convertedAmounts: convertedAmounts ?? this.convertedAmounts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Currency list notifier
class CurrencyListNotifier extends StateNotifier<CurrencyListState> {
  final ExchangeRateRepository _repository = ExchangeRateRepository();

  CurrencyListNotifier() : super(CurrencyListState());

  /// Set base currency
  void setBaseCurrency(String currencyCode) {
    state = state.copyWith(baseCurrency: currencyCode);
  }

  /// Set base amount
  void setBaseAmount(double amount) {
    state = state.copyWith(baseAmount: amount);
  }

  /// Convert base amount to all favorite currencies
  Future<void> convertAllCurrencies(double amount) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final Map<String, double> converted = {};

      // We'll convert using the batch conversion service
      // For now, let's do it one by one
      // In a real app, you'd want to optimize this with a batch API call

      converted[state.baseCurrency] = amount;

      state = state.copyWith(
        convertedAmounts: converted,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Get converted amount for a specific currency
  Future<double> convertToCurrency(String targetCurrency, List<String> allCurrencies) async {
    try {
      if (targetCurrency == state.baseCurrency) {
        return state.baseAmount;
      }

      final result = await _repository.convertCurrency(
        from: state.baseCurrency,
        to: targetCurrency,
        amount: state.baseAmount,
      );

      // Update the converted amounts map
      final newConverted = Map<String, double>.from(state.convertedAmounts);
      newConverted[targetCurrency] = result.targetAmount;
      state = state.copyWith(convertedAmounts: newConverted);

      return result.targetAmount;
    } catch (e) {
      return 0.0;
    }
  }

  /// Refresh all conversions
  Future<void> refreshConversions(List<String> currencies) async {
    // Allow refresh even if amount is 0 to clear displayed amounts
    if (state.baseAmount < 0) return;

    print('refreshConversions called with base: ${state.baseCurrency}, amount: ${state.baseAmount}');
    state = state.copyWith(isLoading: true, error: null);

    try {
      final Map<String, double> converted = {};

      // If amount is 0, set all to 0
      if (state.baseAmount == 0) {
        for (final currency in currencies) {
          converted[currency] = 0.0;
        }
        print('Amount is 0, setting all currencies to 0');
      } else {
        // Convert to all currencies
        for (final currency in currencies) {
          if (currency == state.baseCurrency) {
            converted[currency] = state.baseAmount;
            print('$currency (base): ${state.baseAmount}');
          } else {
            try {
              final result = await _repository.convertCurrency(
                from: state.baseCurrency,
                to: currency,
                amount: state.baseAmount,
              );
              converted[currency] = result.targetAmount;
              print('$currency: ${result.targetAmount} (rate: ${result.rate})');
            } catch (e) {
              // Skip currencies that fail to convert
              converted[currency] = 0.0;
              print('$currency: ERROR - $e');
            }
          }
        }
      }

      print('Final converted amounts: $converted');
      state = state.copyWith(
        convertedAmounts: converted,
        isLoading: false,
      );
      print('State updated with converted amounts');
    } catch (e) {
      print('Error in refreshConversions: $e');
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }
}
