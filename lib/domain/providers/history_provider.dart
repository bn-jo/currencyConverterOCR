import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/conversion_history_model.dart';
import '../../data/repositories/history_repository.dart';
import 'conversion_provider.dart';

/// Provider for history state
final historyProvider = StateNotifierProvider<HistoryNotifier, HistoryState>((ref) {
  final repo = ref.watch(historyRepositoryProvider);
  return HistoryNotifier(repo);
});

/// History state
class HistoryState {
  final List<ConversionHistoryModel> items;
  final bool isLoading;
  final String? error;

  HistoryState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  HistoryState copyWith({
    List<ConversionHistoryModel>? items,
    bool? isLoading,
    String? error,
  }) {
    return HistoryState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// History notifier
class HistoryNotifier extends StateNotifier<HistoryState> {
  final HistoryRepository _repository;

  HistoryNotifier(this._repository) : super(HistoryState()) {
    loadHistory();
  }

  /// Load conversion history
  Future<void> loadHistory() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final items = await _repository.getHistory();
      state = state.copyWith(
        items: items,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load history: $e',
      );
    }
  }

  /// Delete conversion from history
  Future<void> deleteConversion(String id) async {
    try {
      await _repository.deleteConversion(id);
      await loadHistory();
    } catch (e) {
      state = state.copyWith(error: 'Failed to delete: $e');
    }
  }

  /// Clear all history
  Future<void> clearHistory() async {
    try {
      await _repository.clearHistory();
      state = state.copyWith(items: []);
    } catch (e) {
      state = state.copyWith(error: 'Failed to clear history: $e');
    }
  }

  /// Filter history by currency pair
  void filterByCurrencyPair(String source, String target) {
    final filtered = state.items.where((item) {
      return item.sourceCurrency == source && item.targetCurrency == target;
    }).toList();

    state = state.copyWith(items: filtered);
  }
}
