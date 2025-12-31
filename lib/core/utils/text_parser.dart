import '../constants/currency_symbols.dart';

/// Utility class for parsing currency and amount from OCR text
class TextParser {
  /// Extract currency code from text
  static String? extractCurrencyCode(String text) {
    // Check for currency symbols
    for (var entry in CurrencySymbols.symbolToCode.entries) {
      if (text.contains(entry.key)) {
        return entry.value;
      }
    }

    // Check for currency codes (USD, EUR, etc.)
    final codeRegex = RegExp(r'\b([A-Z]{3})\b');
    final match = codeRegex.firstMatch(text);
    if (match != null) {
      final code = match.group(1);
      if (CurrencySymbols.codeToSymbol.containsKey(code)) {
        return code;
      }
    }

    return null;
  }

  /// Extract numeric amount from text
  static double? extractAmount(String text) {
    // Remove currency symbols and letters
    String cleaned = text;
    for (var symbol in CurrencySymbols.symbolToCode.keys) {
      cleaned = cleaned.replaceAll(symbol, '');
    }
    cleaned = cleaned.replaceAll(RegExp(r'[A-Za-z]'), '');

    // Handle different number formats
    // European format: 1.234,56 -> 1234.56
    // US format: 1,234.56 -> 1234.56

    // Count commas and periods
    final commaCount = ','.allMatches(cleaned).length;
    final periodCount = '.'.allMatches(cleaned).length;

    if (commaCount > 0 && periodCount > 0) {
      // Both present - determine which is decimal separator
      final lastCommaIndex = cleaned.lastIndexOf(',');
      final lastPeriodIndex = cleaned.lastIndexOf('.');

      if (lastCommaIndex > lastPeriodIndex) {
        // European format
        cleaned = cleaned.replaceAll('.', '').replaceAll(',', '.');
      } else {
        // US format
        cleaned = cleaned.replaceAll(',', '');
      }
    } else if (commaCount > 0) {
      // Only commas - could be thousands separator or decimal
      if (commaCount == 1 && cleaned.indexOf(',') > cleaned.length - 4) {
        // Likely decimal separator
        cleaned = cleaned.replaceAll(',', '.');
      } else {
        // Thousands separator
        cleaned = cleaned.replaceAll(',', '');
      }
    }

    // Extract number
    final numberRegex = RegExp(r'-?\d+\.?\d*');
    final match = numberRegex.firstMatch(cleaned);

    if (match != null) {
      try {
        return double.parse(match.group(0)!);
      } catch (e) {
        return null;
      }
    }

    return null;
  }

  /// Get possible currency codes for ambiguous symbols
  static List<String> getPossibleCurrencies(String symbol) {
    return CurrencySymbols.ambiguousSymbols[symbol] ?? [];
  }

  /// Parse complete text to extract both currency and amount
  static ParseResult parseText(String text) {
    final currency = extractCurrencyCode(text);
    final amount = extractAmount(text);

    List<String>? possibleCurrencies;
    if (currency != null) {
      final symbol = CurrencySymbols.codeToSymbol.entries
          .firstWhere(
            (e) => e.value == currency,
            orElse: () => const MapEntry('', ''),
          )
          .key;
      if (symbol.isNotEmpty && CurrencySymbols.ambiguousSymbols.containsKey(symbol)) {
        possibleCurrencies = CurrencySymbols.ambiguousSymbols[symbol];
      }
    }

    return ParseResult(
      currency: currency,
      amount: amount,
      possibleCurrencies: possibleCurrencies,
      rawText: text,
    );
  }
}

/// Result of text parsing
class ParseResult {
  final String? currency;
  final double? amount;
  final List<String>? possibleCurrencies;
  final String rawText;

  ParseResult({
    this.currency,
    this.amount,
    this.possibleCurrencies,
    required this.rawText,
  });

  bool get isValid => currency != null && amount != null;
}
