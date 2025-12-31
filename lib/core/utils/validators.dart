/// Validation utilities
class Validators {
  /// Validate currency code format
  static bool isValidCurrencyCode(String code) {
    return RegExp(r'^[A-Z]{3}$').hasMatch(code);
  }

  /// Validate amount
  static bool isValidAmount(double? amount) {
    if (amount == null) return false;
    return amount > 0 && amount < double.maxFinite;
  }

  /// Validate exchange rate
  static bool isValidExchangeRate(double? rate) {
    if (rate == null) return false;
    return rate > 0 && rate < double.maxFinite;
  }

  /// Validate language code
  static bool isValidLanguageCode(String code) {
    const validCodes = ['en', 'es', 'he'];
    return validCodes.contains(code);
  }
}
