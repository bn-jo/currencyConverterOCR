import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/repositories/exchange_rate_repository.dart';
import '../../data/repositories/history_repository.dart';
import '../../data/models/conversion_history_model.dart';

/// Provider for exchange rate repository
final exchangeRateRepositoryProvider = Provider<ExchangeRateRepository>((ref) {
  return ExchangeRateRepository();
});

/// Provider for history repository
final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepository();
});

/// Provider for conversion state
final conversionProvider = StateNotifierProvider<ConversionNotifier, ConversionState>((ref) {
  final exchangeRateRepo = ref.watch(exchangeRateRepositoryProvider);
  final historyRepo = ref.watch(historyRepositoryProvider);
  return ConversionNotifier(exchangeRateRepo, historyRepo);
});

/// Conversion state
class ConversionState {
  final bool isLoading;
  final double? convertedAmount;
  final double? exchangeRate;
  final String? error;
  final bool fromCache;

  ConversionState({
    this.isLoading = false,
    this.convertedAmount,
    this.exchangeRate,
    this.error,
    this.fromCache = false,
  });

  ConversionState copyWith({
    bool? isLoading,
    double? convertedAmount,
    double? exchangeRate,
    String? error,
    bool? fromCache,
  }) {
    return ConversionState(
      isLoading: isLoading ?? this.isLoading,
      convertedAmount: convertedAmount ?? this.convertedAmount,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      error: error,
      fromCache: fromCache ?? this.fromCache,
    );
  }
}

/// Conversion notifier
class ConversionNotifier extends StateNotifier<ConversionState> {
  final ExchangeRateRepository _exchangeRateRepo;
  final HistoryRepository _historyRepo;

  ConversionNotifier(this._exchangeRateRepo, this._historyRepo)
      : super(ConversionState());

  /// Convert currency
  Future<void> convertCurrency({
    required String from,
    required String to,
    required double amount,
    String? ocrText,
    double? ocrConfidence,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _exchangeRateRepo.convertCurrency(
        from: from,
        to: to,
        amount: amount,
      );

      state = state.copyWith(
        isLoading: false,
        convertedAmount: result.targetAmount,
        exchangeRate: result.rate,
        fromCache: result.fromCache,
        error: null,
      );

      // Save to history
      final history = ConversionHistoryModel(
        id: const Uuid().v4(),
        sourceCurrency: from,
        targetCurrency: to,
        sourceAmount: amount,
        targetAmount: result.targetAmount,
        exchangeRate: result.rate,
        timestamp: DateTime.now(),
        ocrText: ocrText,
        ocrConfidence: ocrConfidence,
      );

      await _historyRepo.saveConversion(history);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Conversion failed: $e',
      );
    }
  }

  /// Clear conversion results
  void clearResults() {
    state = ConversionState();
  }

  /// Refresh exchange rates (clear cache)
  Future<void> refreshRates() async {
    await _exchangeRateRepo.clearCache();
  }
}
