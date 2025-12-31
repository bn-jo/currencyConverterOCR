# Setup Instructions

This document provides step-by-step instructions to set up and run the Currency Converter OCR app.

## Prerequisites

1. **Flutter SDK** (>= 3.0.0)
   - Download from: https://flutter.dev/docs/get-started/install
   - Verify installation: `flutter doctor`

2. **Development Environment**
   - **iOS**: Xcode (macOS only)
   - **Android**: Android Studio with Android SDK

3. **API Key**
   - Sign up for a free API key at: https://www.exchangerate-api.com/

## Step-by-Step Setup

### 1. Install Dependencies

```bash
cd currencyConverterOCR
flutter pub get
```

### 2. Configure API Key

Create the API keys file:

```bash
cp lib/core/config/api_keys.example.dart lib/core/config/api_keys.dart
```

Edit `lib/core/config/api_keys.dart` and add your API key:

```dart
class ApiKeys {
  static const String exchangeRateApiKey = 'YOUR_ACTUAL_API_KEY_HERE';
}
```

### 3. Generate Hive Adapters

Run the build runner to generate Hive type adapters:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Create Asset Directories

```bash
mkdir -p assets/images
mkdir -p assets/icons
mkdir -p assets/animations
mkdir -p assets/fonts
```

### 5. Add Fonts (Optional)

Download Roboto fonts and place them in `assets/fonts/`:
- `Roboto-Regular.ttf`
- `Roboto-Bold.ttf`

Or remove the fonts section from `pubspec.yaml` if you prefer to use system fonts.

### 6. iOS Setup

```bash
cd ios
pod install
cd ..
```

If you encounter issues, try:
```bash
cd ios
pod deintegrate
pod install
cd ..
```

### 7. Android Setup

No additional setup required. Ensure you have Android SDK installed.

### 8. Run the App

For iOS:
```bash
flutter run -d ios
```

For Android:
```bash
flutter run -d android
```

Or simply:
```bash
flutter run
```

## Troubleshooting

### Camera Permission Issues

**iOS**: Ensure `Info.plist` has camera permissions (already configured)

**Android**: Ensure `AndroidManifest.xml` has camera permissions (already configured)

### Build Runner Errors

If you get errors about missing generated files:

```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Hive Errors

If Hive throws initialization errors, ensure:
1. Build runner has generated the adapters
2. Adapters are registered in `main.dart`
3. You've uncommented the adapter registration lines in `main.dart`

### ML Kit Issues

**Android**: Ensure Google Play Services is updated on your test device

**iOS**: ML Kit works on device only, not on simulator

### Missing Fonts

If you see font errors:
- Download Roboto fonts from Google Fonts
- Place them in `assets/fonts/`
- Or remove the fonts section from `pubspec.yaml`

## Project Structure

```
currencyConverterOCR/
├── lib/
│   ├── core/                 # Core utilities, constants, themes
│   │   ├── config/           # API keys configuration
│   │   ├── constants/        # App constants
│   │   ├── theme/            # App themes
│   │   └── utils/            # Utility functions
│   ├── data/                 # Data layer
│   │   ├── models/           # Data models
│   │   ├── repositories/     # Data repositories
│   │   └── services/         # External services
│   ├── domain/               # Business logic layer
│   │   └── providers/        # Riverpod providers
│   ├── presentation/         # UI layer
│   │   ├── screens/          # App screens
│   │   └── widgets/          # Reusable widgets
│   └── main.dart             # App entry point
├── assets/
│   ├── translations/         # i18n files
│   ├── images/               # Images
│   ├── icons/                # Icons
│   ├── animations/           # Lottie animations
│   └── fonts/                # Custom fonts
└── test/                     # Test files
```

## Next Steps

1. Test camera functionality
2. Test OCR with different currency images
3. Verify exchange rate API is working
4. Test all three languages (EN, ES, HE)
5. Test history saving and retrieval

## Support

For issues or questions:
- Check Flutter documentation: https://flutter.dev/docs
- Google ML Kit docs: https://pub.dev/packages/google_ml_kit
- Riverpod docs: https://riverpod.dev
