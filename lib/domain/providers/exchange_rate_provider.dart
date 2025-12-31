import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/exchange_rate_model.dart';
import '../../data/repositories/exchange_rate_repository.dart';
import '../../data/services/network_service.dart';
import '../../data/services/rate_refresh_scheduler.dart';
import '../../data/services/batch_conversion_service.dart';
import 'conversion_provider.dart';

/// Provider for network service
final networkServiceProvider = Provider<NetworkService>((ref) {
  return NetworkService();
});

/// Provider for batch conversion service
final batchConversionServiceProvider = Provider<BatchConversionService>((ref) {
  final repository = ref.watch(exchangeRateRepositoryProvider);
  return BatchConversionService(repository);
});

/// Provider for rate refresh scheduler
final rateRefreshSchedulerProvider = Provider<RateRefreshScheduler>((ref) {
  final repository = ref.watch(exchangeRateRepositoryProvider);
  final networkService = ref.watch(networkServiceProvider);

  final scheduler = RateRefreshScheduler(
    repository: repository,
    networkService: networkService,
    refreshInterval: const Duration(hours: 6),
  );

  // Auto-start scheduler
  scheduler.start();

  // Cleanup when provider is disposed
  ref.onDispose(() {
    scheduler.dispose();
  });

  return scheduler;
});

/// Provider for exchange rate manager
final exchangeRateManagerProvider =
    StateNotifierProvider<ExchangeRateManager, ExchangeRateManagerState>((ref) {
  final repository = ref.watch(exchangeRateRepositoryProvider);
  final networkService = ref.watch(networkServiceProvider);
  final scheduler = ref.watch(rateRefreshSchedulerProvider);

  return ExchangeRateManager(
    repository: repository,
    networkService: networkService,
    scheduler: scheduler,
  );
});

/// Exchange rate manager state
class ExchangeRateManagerState {
  final Map<String, ExchangeRateModel> rates;
  final bool isLoading;
  final bool isOnline;
  final String? error;
  final DateTime? lastRefresh;

  ExchangeRateManagerState({
    this.rates = const {},
    this.isLoading = false,
    this.isOnline = true,
    this.error,
    this.lastRefresh,
  });

  ExchangeRateManagerState copyWith({
    Map<String, ExchangeRateModel>? rates,
    bool? isLoading,
    bool? isOnline,
    String? error,
    DateTime? lastRefresh,
  }) {
    return ExchangeRateManagerState(
      rates: rates ?? this.rates,
      isLoading: isLoading ?? this.isLoading,
      isOnline: isOnline ?? this.isOnline,
      error: error,
      lastRefresh: lastRefresh ?? this.lastRefresh,
    );
  }

  /// Get rate for a specific base currency
  ExchangeRateModel? getRates(String baseCurrency) {
    return rates[baseCurrency];
  }

  /// Check if we have fresh rates for a currency
  bool hasFreshRates(String baseCurrency) {
    final rateModel = rates[baseCurrency];
    return rateModel != null && rateModel.isFresh;
  }
}

/// Exchange rate manager
class ExchangeRateManager extends StateNotifier<ExchangeRateManagerState> {
  final ExchangeRateRepository _repository;
  final NetworkService _networkService;
  final RateRefreshScheduler _scheduler;

  ExchangeRateManager({
    required ExchangeRateRepository repository,
    required NetworkService networkService,
    required RateRefreshScheduler scheduler,
  })  : _repository = repository,
        _networkService = networkService,
        _scheduler = scheduler,
        super(ExchangeRateManagerState()) {
    _checkNetworkStatus();
  }

  /// Check network status
  Future<void> _checkNetworkStatus() async {
    final isOnline = await _networkService.hasInternetConnection();
    state = state.copyWith(isOnline: isOnline);
  }

  /// Load exchange rates for a currency
  Future<void> loadRates(String baseCurrency) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final rates = await _repository.getExchangeRates(baseCurrency);

      final updatedRates = Map<String, ExchangeRateModel>.from(state.rates);
      updatedRates[baseCurrency] = rates;

      // Add to scheduler for background refresh
      _scheduler.addCurrency(baseCurrency);

      state = state.copyWith(
        rates: updatedRates,
        isLoading: false,
        lastRefresh: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load rates: $e',
      );
    }
  }

  /// Refresh all loaded rates
  Future<void> refreshAllRates() async {
    final currencies = state.rates.keys.toList();

    for (final currency in currencies) {
      await loadRates(currency);
    }
  }

  /// Clear cached rates
  Future<void> clearCache() async {
    await _repository.clearCache();
    state = state.copyWith(rates: {});
  }

  /// Get cache age for a currency
  Future<Duration?> getCacheAge(String baseCurrency) async {
    return await _repository.getCacheAge(baseCurrency);
  }

  /// Preload popular currencies
  Future<void> preloadPopularCurrencies() async {
    final popularCurrencies = ['USD', 'EUR', 'GBP', 'JPY'];

    for (final currency in popularCurrencies) {
      try {
        await loadRates(currency);
      } catch (e) {
        // Continue loading others even if one fails
        continue;
      }
    }
  }

  /// Get network status
  Future<void> updateNetworkStatus() async {
    await _checkNetworkStatus();
  }

  /// Get rate between two currencies
  double? getRate(String from, String to) {
    final rates = state.getRates(from);
    if (rates == null) return null;

    if (to == from) return 1.0;

    return rates.getRate(to);
  }

  /// Convert amount
  double? convert({
    required String from,
    required String to,
    required double amount,
  }) {
    final rate = getRate(from, to);
    if (rate == null) return null;

    return amount * rate;
  }
}

/// Provider for favorite currencies
final favoriteCurrenciesProvider =
    StateNotifierProvider<FavoriteCurrenciesNotifier, List<String>>((ref) {
  return FavoriteCurrenciesNotifier();
});

/// Favorite currencies notifier
class FavoriteCurrenciesNotifier extends StateNotifier<List<String>> {
  FavoriteCurrenciesNotifier() : super(['USD', 'EUR', 'GBP']);

  /// Add currency to favorites
  void addFavorite(String currencyCode) {
    if (!state.contains(currencyCode)) {
      state = [...state, currencyCode];
    }
  }

  /// Remove currency from favorites
  void removeFavorite(String currencyCode) {
    state = state.where((c) => c != currencyCode).toList();
  }

  /// Toggle favorite status
  void toggleFavorite(String currencyCode) {
    if (state.contains(currencyCode)) {
      removeFavorite(currencyCode);
    } else {
      addFavorite(currencyCode);
    }
  }

  /// Check if currency is favorite
  bool isFavorite(String currencyCode) {
    return state.contains(currencyCode);
  }
}
