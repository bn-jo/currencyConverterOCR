import 'package:flutter/foundation.dart';
import '../../data/models/exchange_rate_model.dart';

/// Handles offline mode and cached data
class OfflineHandler {
  /// Check if cached data is usable in offline mode
  static bool canUseCachedData(ExchangeRateModel rates, {
    Duration maxAge = const Duration(days: 7),
  }) {
    final age = DateTime.now().difference(rates.lastUpdated);
    return age <= maxAge;
  }

  /// Get warning message based on cache age
  static String? getCacheWarning(ExchangeRateModel rates) {
    final age = DateTime.now().difference(rates.lastUpdated);

    if (age.inHours < 1) {
      return null; // Fresh data
    } else if (age.inHours < 24) {
      return 'Rates updated ${age.inHours} hours ago';
    } else if (age.inDays < 7) {
      return 'Rates updated ${age.inDays} days ago';
    } else {
      return 'Rates are more than a week old';
    }
  }

  /// Get cache age description
  static String getCacheAgeDescription(DateTime lastUpdated) {
    final age = DateTime.now().difference(lastUpdated);

    if (age.inMinutes < 1) {
      return 'Just now';
    } else if (age.inMinutes < 60) {
      return '${age.inMinutes} minute${age.inMinutes > 1 ? 's' : ''} ago';
    } else if (age.inHours < 24) {
      return '${age.inHours} hour${age.inHours > 1 ? 's' : ''} ago';
    } else if (age.inDays < 30) {
      return '${age.inDays} day${age.inDays > 1 ? 's' : ''} ago';
    } else {
      return 'Over a month ago';
    }
  }

  /// Determine if data should be refreshed
  static bool shouldRefresh(ExchangeRateModel rates, {
    Duration refreshThreshold = const Duration(hours: 12),
  }) {
    final age = DateTime.now().difference(rates.lastUpdated);
    return age >= refreshThreshold;
  }

  /// Get priority for refresh based on age
  static RefreshPriority getRefreshPriority(ExchangeRateModel rates) {
    final age = DateTime.now().difference(rates.lastUpdated);

    if (age.inHours < 6) {
      return RefreshPriority.low;
    } else if (age.inHours < 24) {
      return RefreshPriority.medium;
    } else {
      return RefreshPriority.high;
    }
  }

  /// Validate cached data integrity
  static bool validateCachedData(ExchangeRateModel rates) {
    // Check if rates map is not empty
    if (rates.rates.isEmpty) {
      debugPrint('Cached rates are empty');
      return false;
    }

    // Check for invalid rates (zero or negative)
    for (final entry in rates.rates.entries) {
      if (entry.value <= 0) {
        debugPrint('Invalid rate for ${entry.key}: ${entry.value}');
        return false;
      }
    }

    // Check if timestamp is valid
    if (rates.lastUpdated.isAfter(DateTime.now())) {
      debugPrint('Invalid timestamp: rate is from the future');
      return false;
    }

    return true;
  }

  /// Get offline mode strategy
  static OfflineStrategy getOfflineStrategy(ExchangeRateModel? rates) {
    if (rates == null) {
      return OfflineStrategy.noData;
    }

    final age = DateTime.now().difference(rates.lastUpdated);

    if (age.inDays > 7) {
      return OfflineStrategy.staleData;
    } else if (age.inHours > 24) {
      return OfflineStrategy.oldData;
    } else {
      return OfflineStrategy.recentData;
    }
  }
}

/// Refresh priority levels
enum RefreshPriority {
  low,
  medium,
  high,
}

/// Offline strategy
enum OfflineStrategy {
  noData,       // No cached data available
  staleData,    // Data is over a week old
  oldData,      // Data is 1-7 days old
  recentData,   // Data is less than 24 hours old
}

/// Offline mode status
class OfflineStatus {
  final bool isOffline;
  final OfflineStrategy strategy;
  final String? message;
  final DateTime? lastUpdate;

  OfflineStatus({
    required this.isOffline,
    required this.strategy,
    this.message,
    this.lastUpdate,
  });

  bool get hasUsableData =>
      strategy != OfflineStrategy.noData &&
      strategy != OfflineStrategy.staleData;

  bool get shouldWarnUser =>
      strategy == OfflineStrategy.oldData ||
      strategy == OfflineStrategy.staleData;
}
