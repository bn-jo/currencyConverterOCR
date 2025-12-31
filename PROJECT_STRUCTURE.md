# Project Structure Documentation

## Overview

This Flutter application follows **Clean Architecture** principles with clear separation of concerns across three main layers:

1. **Presentation Layer** - UI components
2. **Domain Layer** - Business logic
3. **Data Layer** - Data management

## Directory Structure

```
currencyConverterOCR/
├── lib/
│   ├── core/                           # Core application components
│   │   ├── config/
│   │   │   └── api_keys.dart          # API keys (gitignored)
│   │   ├── constants/
│   │   │   ├── app_constants.dart     # App-wide constants
│   │   │   └── currency_symbols.dart  # Currency mappings
│   │   ├── theme/
│   │   │   └── app_theme.dart         # Light/Dark themes
│   │   └── utils/
│   │       ├── image_utils.dart       # Image preprocessing
│   │       ├── text_parser.dart       # OCR text parsing
│   │       └── validators.dart        # Input validation
│   │
│   ├── data/                          # Data layer
│   │   ├── models/                    # Data models
│   │   │   ├── currency_model.dart
│   │   │   ├── exchange_rate_model.dart
│   │   │   ├── conversion_history_model.dart
│   │   │   └── ocr_result_model.dart
│   │   ├── repositories/              # Data repositories
│   │   │   ├── exchange_rate_repository.dart
│   │   │   └── history_repository.dart
│   │   └── services/                  # External services
│   │       ├── ocr_service.dart       # Google ML Kit OCR
│   │       └── exchange_rate_service.dart  # API client
│   │
│   ├── domain/                        # Business logic layer
│   │   └── providers/                 # Riverpod state management
│   │       ├── camera_provider.dart
│   │       ├── ocr_provider.dart
│   │       ├── conversion_provider.dart
│   │       ├── history_provider.dart
│   │       └── settings_provider.dart
│   │
│   ├── presentation/                  # UI layer
│   │   ├── screens/                   # Full-screen pages
│   │   │   ├── home_screen.dart
│   │   │   ├── camera_screen.dart
│   │   │   ├── history_screen.dart
│   │   │   └── settings_screen.dart
│   │   └── widgets/                   # Reusable components
│   │       ├── camera_capture_button.dart
│   │       ├── conversion_result_card.dart
│   │       ├── currency_selector.dart
│   │       └── history_list_item.dart
│   │
│   └── main.dart                      # Application entry point
│
├── assets/                            # Static assets
│   ├── translations/                  # i18n JSON files
│   │   ├── en.json                    # English
│   │   ├── es.json                    # Spanish
│   │   └── he.json                    # Hebrew
│   ├── images/                        # Image assets
│   ├── icons/                         # Icon assets
│   ├── animations/                    # Lottie animations
│   └── fonts/                         # Custom fonts
│
├── android/                           # Android-specific code
│   └── app/src/main/AndroidManifest.xml
│
├── ios/                              # iOS-specific code
│   └── Runner/Info.plist
│
├── test/                             # Unit & widget tests
│
├── pubspec.yaml                      # Dependencies
├── analysis_options.yaml             # Linting rules
├── .gitignore                        # Git ignore rules
├── README.md                         # Project overview
├── SETUP.md                          # Setup instructions
└── PROJECT_STRUCTURE.md              # This file
```

## Layer Responsibilities

### 1. Core Layer (`lib/core/`)

**Purpose**: Shared utilities and configurations used across all layers

**Components**:
- **config/**: API keys and configuration
- **constants/**: App-wide constants and currency mappings
- **theme/**: UI themes (light/dark mode)
- **utils/**: Helper functions for image processing, text parsing, validation

**Dependencies**: None (most independent layer)

---

### 2. Data Layer (`lib/data/`)

**Purpose**: Handles all data operations - API calls, local storage, data models

#### Models (`models/`)
- Define data structures
- Handle JSON serialization
- Hive type adapters for local storage

**Key Models**:
- `ExchangeRateModel` - Exchange rate data with caching logic
- `ConversionHistoryModel` - Conversion records
- `OcrResultModel` - OCR extraction results
- `CurrencyModel` - Currency information

#### Services (`services/`)
- External API communication
- OCR processing via Google ML Kit

**Services**:
- `ExchangeRateService` - Fetch rates from ExchangeRate-API
- `OcrService` - Text extraction from images

#### Repositories (`repositories/`)
- Abstract data sources
- Implement caching strategy
- Handle offline scenarios

**Repositories**:
- `ExchangeRateRepository` - Manages rates with cache
- `HistoryRepository` - CRUD for conversion history

**Dependencies**: Core layer only

---

### 3. Domain Layer (`lib/domain/`)

**Purpose**: Business logic and state management

#### Providers (`providers/`)
Uses Riverpod for state management

**Providers**:
- `camera_provider` - Camera initialization and capture
- `ocr_provider` - OCR processing state
- `conversion_provider` - Currency conversion logic
- `history_provider` - History management
- `settings_provider` - App settings (language, theme, defaults)

**State Management Pattern**:
```dart
StateNotifierProvider<Notifier, State>
```

Each provider:
1. Manages a specific feature's state
2. Exposes methods to modify state
3. Coordinates between data layer and UI

**Dependencies**: Core + Data layers

---

### 4. Presentation Layer (`lib/presentation/`)

**Purpose**: User interface components

#### Screens (`screens/`)
Full-page views representing major app sections

**Screens**:
- `home_screen` - Main conversion interface
- `camera_screen` - Camera capture view
- `history_screen` - Conversion history list
- `settings_screen` - App configuration

#### Widgets (`widgets/`)
Reusable UI components

**Widgets**:
- `camera_capture_button` - Camera trigger button
- `conversion_result_card` - Display conversion result
- `currency_selector` - Currency picker dropdown
- `history_list_item` - Single history entry

**Dependencies**: All layers

---

## Data Flow

### Example: Currency Conversion Flow

```
1. USER ACTION
   ↓
   User captures image in CameraScreen

2. PRESENTATION → DOMAIN
   ↓
   camera_provider.captureImage()

3. DOMAIN → DATA
   ↓
   ocr_service.extractTextFromImage()

4. DATA PROCESSING
   ↓
   text_parser.parseText() extracts currency & amount

5. DOMAIN → DATA
   ↓
   exchange_rate_repository.convertCurrency()

6. DATA → API/CACHE
   ↓
   exchange_rate_service.getExchangeRates()
   (with cache fallback)

7. DATA → DOMAIN
   ↓
   Returns ConversionResult

8. DOMAIN → PRESENTATION
   ↓
   Updates conversion_provider state

9. UI UPDATE
   ↓
   Widget rebuilds with new state
   Displays result in ConversionResultCard
```

## Key Architectural Decisions

### 1. State Management: Riverpod
- **Why**: Type-safe, compile-time DI, excellent testing support
- **Alternative considered**: Bloc (more boilerplate)

### 2. Local Storage: Hive
- **Why**: Fast, lightweight, no native dependencies
- **Use cases**: Exchange rate cache, conversion history, settings

### 3. OCR: Google ML Kit
- **Why**: On-device processing (privacy), free, optimized for mobile
- **Alternative considered**: Cloud Vision API (requires internet, costs money)

### 4. i18n: easy_localization
- **Why**: Simple JSON-based translations, RTL support for Hebrew
- **Supports**: English, Spanish, Hebrew

### 5. HTTP Client: Dio
- **Why**: Interceptors, timeout handling, better error handling than http package

## File Naming Conventions

- **Screens**: `*_screen.dart`
- **Widgets**: `*_widget.dart` or descriptive name
- **Providers**: `*_provider.dart`
- **Models**: `*_model.dart`
- **Services**: `*_service.dart`
- **Repositories**: `*_repository.dart`
- **Utils**: `*_utils.dart` or `*_helper.dart`

## Code Generation

Files requiring code generation (run `flutter pub run build_runner build`):

- `*.g.dart` - Hive type adapters
- `*.freezed.dart` - Freezed models (if added later)

## Testing Strategy

```
test/
├── unit/              # Pure logic tests
│   ├── utils/
│   ├── services/
│   └── repositories/
├── widget/            # Widget tests
│   └── presentation/
└── integration/       # E2E tests
```

## Common Patterns

### 1. Repository Pattern
```dart
class ExchangeRateRepository {
  final ExchangeRateService _service;

  Future<Data> getData() async {
    // Check cache
    // Fetch from API if needed
    // Update cache
    // Return data
  }
}
```

### 2. Provider Pattern
```dart
final provider = StateNotifierProvider<Notifier, State>((ref) {
  final dependency = ref.watch(dependencyProvider);
  return Notifier(dependency);
});
```

### 3. Screen Structure
```dart
class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myProvider);

    return Scaffold(
      appBar: AppBar(...),
      body: ...,
    );
  }
}
```

## Best Practices

1. **Separation of Concerns**: Each layer has clear responsibilities
2. **Dependency Injection**: Use Riverpod providers
3. **Error Handling**: Catch errors at service/repository level
4. **Null Safety**: Leverage Dart's null safety features
5. **Immutability**: Use `copyWith` for state updates
6. **Resource Management**: Dispose controllers, close streams
7. **Localization**: All user-facing text uses `.tr()`
8. **Constants**: Magic numbers/strings in constants files

## Future Enhancements

Potential additions to the architecture:

1. **Use Cases Layer**: Add between domain and data for complex business logic
2. **Freezed**: Immutable models with code generation
3. **Injectable**: Automated dependency injection
4. **Flavor Configuration**: Dev/Staging/Prod environments
5. **Analytics**: Firebase Analytics integration
6. **Crashlytics**: Error reporting
