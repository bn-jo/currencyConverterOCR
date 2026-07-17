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
    // Try to find any number in the text - be very aggressive

    // First, try to find numbers with decimal points or commas
    // Match patterns like: 123.45, 123,45, 1,234.56, 1.234,56
    final complexNumberRegex = RegExp(r'\d{1,3}(?:[,.]\d{3})*(?:[,.]\d{1,2})?|\d+[,.]\d{1,2}|\d+');
    final matches = complexNumberRegex.allMatches(text);

    double? bestNumber;

    for (final match in matches) {
      String numberStr = match.group(0)!;

      // Count commas and periods
      final commaCount = ','.allMatches(numberStr).length;
      final periodCount = '.'.allMatches(numberStr).length;

      String cleaned = numberStr;

      if (commaCount > 0 && periodCount > 0) {
        // Both present - determine which is decimal separator
        final lastCommaIndex = cleaned.lastIndexOf(',');
        final lastPeriodIndex = cleaned.lastIndexOf('.');

        if (lastCommaIndex > lastPeriodIndex) {
          // European format: 1.234,56
          cleaned = cleaned.replaceAll('.', '').replaceAll(',', '.');
        } else {
          // US format: 1,234.56
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

      try {
        final num = double.parse(cleaned);
        // Prefer larger numbers (likely to be prices) over small numbers
        if (bestNumber == null || num > bestNumber) {
          bestNumber = num;
        }
      } catch (e) {
        // Skip invalid numbers
      }
    }

    return bestNumber;
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

  // Valid if we have an amount - currency is optional
  bool get isValid => amount != null;
}
