import 'package:hive/hive.dart';
import '../models/conversion_history_model.dart';
import '../../core/constants/app_constants.dart';

/// Repository for managing conversion history
class HistoryRepository {
  final String _boxName = 'conversion_history';

  /// Save conversion to history
  Future<void> saveConversion(ConversionHistoryModel conversion) async {
    final box = await Hive.openBox<ConversionHistoryModel>(_boxName);
    await box.put(conversion.id, conversion);

    // Limit history size
    await _limitHistorySize(box);
  }

  /// Get all conversion history
  Future<List<ConversionHistoryModel>> getHistory() async {
    final box = await Hive.openBox<ConversionHistoryModel>(_boxName);
    final history = box.values.toList();

    // Sort by timestamp, newest first
    history.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return history;
  }

  /// Get history filtered by date range
  Future<List<ConversionHistoryModel>> getHistoryByDateRange({
    required DateTime start,
    required DateTime end,
  }) async {
    final allHistory = await getHistory();

    return allHistory.where((item) {
      return item.timestamp.isAfter(start) && item.timestamp.isBefore(end);
    }).toList();
  }

  /// Get history for specific currency pair
  Future<List<ConversionHistoryModel>> getHistoryByCurrencyPair({
    required String sourceCurrency,
    required String targetCurrency,
  }) async {
    final allHistory = await getHistory();

    return allHistory.where((item) {
      return item.sourceCurrency == sourceCurrency &&
             item.targetCurrency == targetCurrency;
    }).toList();
  }

  /// Delete conversion from history
  Future<void> deleteConversion(String id) async {
    final box = await Hive.openBox<ConversionHistoryModel>(_boxName);
    await box.delete(id);
  }

  /// Clear all history
  Future<void> clearHistory() async {
    final box = await Hive.openBox<ConversionHistoryModel>(_boxName);
    await box.clear();
  }

  /// Limit history size to max items
  Future<void> _limitHistorySize(Box<ConversionHistoryModel> box) async {
    if (box.length > AppConstants.maxHistoryItems) {
      final items = box.values.toList();
      items.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      // Remove oldest items
      final itemsToRemove = items.take(box.length - AppConstants.maxHistoryItems);
      for (var item in itemsToRemove) {
        await box.delete(item.id);
      }
    }
  }

  /// Get statistics
  Future<HistoryStatistics> getStatistics() async {
    final history = await getHistory();

    final totalConversions = history.length;
    final uniqueCurrencies = <String>{};
    double totalAmount = 0;

    for (var item in history) {
      uniqueCurrencies.add(item.sourceCurrency);
      uniqueCurrencies.add(item.targetCurrency);
      totalAmount += item.sourceAmount;
    }

    return HistoryStatistics(
      totalConversions: totalConversions,
      uniqueCurrencies: uniqueCurrencies.length,
      totalAmount: totalAmount,
    );
  }
}

/// History statistics
class HistoryStatistics {
  final int totalConversions;
  final int uniqueCurrencies;
  final double totalAmount;

  HistoryStatistics({
    required this.totalConversions,
    required this.uniqueCurrencies,
    required this.totalAmount,
  });
}
