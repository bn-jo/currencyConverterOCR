import 'dart:async';
import 'package:flutter/foundation.dart';
import '../repositories/exchange_rate_repository.dart';
import 'network_service.dart';

/// Background service to refresh exchange rates periodically
class RateRefreshScheduler {
  final ExchangeRateRepository _repository;
  final NetworkService _networkService;

  Timer? _timer;
  bool _isRefreshing = false;

  final List<String> _currenciesToRefresh;
  final Duration _refreshInterval;

  RateRefreshScheduler({
    required ExchangeRateRepository repository,
    required NetworkService networkService,
    List<String> currenciesToRefresh = const ['USD', 'EUR', 'GBP'],
    Duration refreshInterval = const Duration(hours: 6),
  })  : _repository = repository,
        _networkService = networkService,
        _currenciesToRefresh = currenciesToRefresh,
        _refreshInterval = refreshInterval;

  /// Start background refresh
  void start() {
    if (_timer != null) {
      debugPrint('Rate refresh scheduler already running');
      return;
    }

    debugPrint('Starting rate refresh scheduler (interval: $_refreshInterval)');

    // Refresh immediately on start
    _refreshRates();

    // Schedule periodic refresh
    _timer = Timer.periodic(_refreshInterval, (_) {
      _refreshRates();
    });
  }

  /// Stop background refresh
  void stop() {
    _timer?.cancel();
    _timer = null;
    debugPrint('Stopped rate refresh scheduler');
  }

  /// Manually trigger refresh
  Future<void> refresh() async {
    await _refreshRates();
  }

  /// Add currency to refresh list
  void addCurrency(String currencyCode) {
    if (!_currenciesToRefresh.contains(currencyCode)) {
      _currenciesToRefresh.add(currencyCode);
      debugPrint('Added $currencyCode to refresh list');
    }
  }

  /// Remove currency from refresh list
  void removeCurrency(String currencyCode) {
    _currenciesToRefresh.remove(currencyCode);
    debugPrint('Removed $currencyCode from refresh list');
  }

  /// Internal refresh logic
  Future<void> _refreshRates() async {
    if (_isRefreshing) {
      debugPrint('Refresh already in progress, skipping');
      return;
    }

    _isRefreshing = true;

    try {
      // Check network connectivity
      final hasInternet = await _networkService.hasInternetConnection();

      if (!hasInternet) {
        debugPrint('No internet connection, skipping refresh');
        return;
      }

      debugPrint('Refreshing rates for ${_currenciesToRefresh.length} currencies');

      // Refresh rates for each currency
      for (final currency in _currenciesToRefresh) {
        try {
          await _repository.getExchangeRates(currency);
          debugPrint('Refreshed rates for $currency');
        } catch (e) {
          debugPrint('Failed to refresh $currency: $e');
        }

        // Small delay between requests to avoid rate limiting
        await Future.delayed(const Duration(milliseconds: 500));
      }

      debugPrint('Rate refresh completed');
    } catch (e) {
      debugPrint('Rate refresh error: $e');
    } finally {
      _isRefreshing = false;
    }
  }

  /// Check if scheduler is running
  bool get isRunning => _timer != null && _timer!.isActive;

  /// Get currencies being refreshed
  List<String> get currencies => List.unmodifiable(_currenciesToRefresh);

  /// Dispose resources
  void dispose() {
    stop();
  }
}
