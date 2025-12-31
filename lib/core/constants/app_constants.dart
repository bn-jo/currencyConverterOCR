/// Application-wide constants
class AppConstants {
  // App Info
  static const String appName = 'Currency Converter OCR';
  static const String appVersion = '1.0.0';

  // Exchange Rate API
  static const String exchangeRateApiBaseUrl = 'https://api.frankfurter.app';

  // Cache Settings
  static const Duration exchangeRateCacheDuration = Duration(hours: 12);
  static const int maxHistoryItems = 100;

  // OCR Settings
  static const double minOcrConfidence = 0.7;
  static const int maxOcrRetries = 3;

  // Image Processing
  static const int maxImageWidth = 1920;
  static const int maxImageHeight = 1080;
  static const int imageQuality = 85;

  // Supported Languages
  static const List<String> supportedLanguages = ['en', 'es', 'he'];

  // Default Currency
  static const String defaultSourceCurrency = 'USD';
  static const String defaultTargetCurrency = 'EUR';
}
