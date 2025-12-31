import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

/// Provider for settings state
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

/// Settings state
class SettingsState {
  final String languageCode;
  final bool isDarkMode;
  final List<String> favoriteCurrencies;

  SettingsState({
    this.languageCode = 'en',
    this.isDarkMode = true,
    this.favoriteCurrencies = const ['THB', 'USD', 'ILS', 'EUR'],
  });

  SettingsState copyWith({
    String? languageCode,
    bool? isDarkMode,
    List<String>? favoriteCurrencies,
  }) {
    return SettingsState(
      languageCode: languageCode ?? this.languageCode,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      favoriteCurrencies: favoriteCurrencies ?? this.favoriteCurrencies,
    );
  }
}

/// Settings notifier
class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState()) {
    loadSettings();
  }

  /// Load settings from storage
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final favoriteCurrenciesJson = prefs.getStringList('favoriteCurrencies');
    final favoriteCurrencies = favoriteCurrenciesJson ?? ['THB', 'USD', 'ILS', 'EUR'];

    state = SettingsState(
      languageCode: prefs.getString('languageCode') ?? 'en',
      isDarkMode: prefs.getBool('isDarkMode') ?? true,
      favoriteCurrencies: favoriteCurrencies,
    );
  }

  /// Set language
  Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
    state = state.copyWith(languageCode: languageCode);
  }

  /// Toggle dark mode
  Future<void> toggleDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    final newValue = !state.isDarkMode;
    await prefs.setBool('isDarkMode', newValue);
    state = state.copyWith(isDarkMode: newValue);
  }

  /// Add currency to favorites
  Future<void> addFavoriteCurrency(String currencyCode) async {
    if (state.favoriteCurrencies.contains(currencyCode)) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final newFavorites = [...state.favoriteCurrencies, currencyCode];
    await prefs.setStringList('favoriteCurrencies', newFavorites);
    state = state.copyWith(favoriteCurrencies: newFavorites);
  }

  /// Remove currency from favorites
  Future<void> removeFavoriteCurrency(String currencyCode) async {
    final prefs = await SharedPreferences.getInstance();
    final newFavorites = state.favoriteCurrencies
        .where((code) => code != currencyCode)
        .toList();
    await prefs.setStringList('favoriteCurrencies', newFavorites);
    state = state.copyWith(favoriteCurrencies: newFavorites);
  }

  /// Reorder favorite currencies
  Future<void> reorderFavoriteCurrencies(int oldIndex, int newIndex) async {
    final prefs = await SharedPreferences.getInstance();
    final newFavorites = List<String>.from(state.favoriteCurrencies);

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final item = newFavorites.removeAt(oldIndex);
    newFavorites.insert(newIndex, item);

    await prefs.setStringList('favoriteCurrencies', newFavorites);
    state = state.copyWith(favoriteCurrencies: newFavorites);
  }
}
