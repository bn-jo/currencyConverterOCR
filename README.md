# Currency Converter OCR

A cross-platform mobile application that uses OCR (Optical Character Recognition) to scan currency amounts from images and convert them to different currencies.

## Features

- 📸 Camera integration for capturing currency images
- 🔍 OCR text extraction using Google ML Kit
- 💱 Real-time currency conversion
- 🌍 Multi-language support (English, Spanish, Hebrew)
- 📊 Conversion history
- 💾 Offline support with cached exchange rates
- 🎨 Modern, intuitive UI

## Tech Stack

- **Framework:** Flutter
- **State Management:** Riverpod
- **OCR Engine:** Google ML Kit (on-device)
- **Exchange Rates API:** ExchangeRate-API.com
- **Local Storage:** Hive
- **Localization:** easy_localization

## Project Structure

```
lib/
├── core/           # Core utilities, constants, themes
├── data/           # Data layer (models, repositories, services)
├── domain/         # Business logic layer
├── presentation/   # UI layer (screens, widgets)
└── main.dart       # Entry point
```

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK
- iOS: Xcode (for iOS development)
- Android: Android Studio

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate Hive adapters:
   ```bash
   flutter pub run build_runner build
   ```

4. Run the app:
   ```bash
   flutter run
   ```

### API Configuration

1. Get a free API key from [ExchangeRate-API.com](https://www.exchangerate-api.com/)
2. Create `lib/core/config/api_keys.dart`:
   ```dart
   class ApiKeys {
     static const String exchangeRateApiKey = 'YOUR_API_KEY_HERE';
   }
   ```

## Supported Platforms

- ✅ iOS
- ✅ Android

## Languages

- English (en)
- Spanish (es)
- Hebrew (he) - RTL support

## License

MIT License
