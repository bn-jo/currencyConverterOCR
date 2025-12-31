# Exchange Rate Module - Quick Reference

## Quick Start

### 1. Basic Conversion

```dart
// Get the exchange rate manager
final manager = ref.watch(exchangeRateManagerProvider.notifier);

// Load rates for USD
await manager.loadRates('USD');

// Convert $100 to EUR
final euros = manager.convert(
  from: 'USD',
  to: 'EUR',
  amount: 100,
);
```

### 2. Using the Repository Directly

```dart
final repository = ref.watch(exchangeRateRepositoryProvider);

// Get exchange rates
final rates = await repository.getExchangeRates('USD');

// Convert with details
final result = await repository.convertCurrency(
  from: 'USD',
  to: 'EUR',
  amount: 100,
);

print('Amount: ${result.targetAmount}');
print('Rate: ${result.rate}');
print('From cache: ${result.fromCache}');
```

### 3. Batch Conversion

```dart
final batchService = ref.watch(batchConversionServiceProvider);

// Convert to multiple currencies at once
final result = await batchService.convertToMultipleCurrencies(
  sourceCurrency: 'USD',
  targetCurrencies: ['EUR', 'GBP', 'JPY', 'CAD'],
  amount: 100,
);

// Access results
final eurAmount = result.getConversion('EUR')?.convertedAmount;
```

### 4. Check Network Status

```dart
final networkService = ref.watch(networkServiceProvider);

final hasInternet = await networkService.hasInternetConnection();
final isApiAvailable = await networkService.isExchangeRateApiAvailable();

if (hasInternet && isApiAvailable) {
  // Safe to fetch rates
}
```

### 5. Background Refresh

```dart
// Auto-starts via provider
final scheduler = ref.watch(rateRefreshSchedulerProvider);

// Add currency to auto-refresh
scheduler.addCurrency('CAD');

// Manual refresh
await scheduler.refresh();

// Check status
print('Running: ${scheduler.isRunning}');
```

---

## Common Tasks

### Preload Popular Currencies

```dart
@override
void initState() {
  super.initState();
  Future.microtask(() {
    ref.read(exchangeRateManagerProvider.notifier)
       .preloadPopularCurrencies();
  });
}
```

### Handle Offline Mode

```dart
final state = ref.watch(exchangeRateManagerProvider);

if (!state.isOnline) {
  return OfflineIndicator(
    isOffline: true,
    lastUpdate: state.lastRefresh,
  );
}
```

### Show Cache Age

```dart
final repository = ref.watch(exchangeRateRepositoryProvider);
final cacheAge = await repository.getCacheAge('USD');

if (cacheAge != null) {
  final ageText = OfflineHandler.getCacheAgeDescription(
    DateTime.now().subtract(cacheAge),
  );
  print('Rates from: $ageText');
}
```

### Clear Cache

```dart
final manager = ref.watch(exchangeRateManagerProvider.notifier);
await manager.clearCache();
```

### Get Currency Info

```dart
final metadata = CurrencyDatabase.get('USD');
print('${metadata.flag} ${metadata.name}'); // 🇺🇸 US Dollar
print('Symbol: ${metadata.symbol}'); // $

// Format amount
final formatted = CurrencyDatabase.formatAmount(1234.56, 'EUR');
print(formatted); // €1234.56
```

### Search Currencies

```dart
final results = CurrencyDatabase.search('dollar');
// Returns: USD, CAD, AUD, NZD, SGD, HKD
```

### Compare Rates

```dart
final comparison = RateComparison.compare(1.18, 1.20);
print('Increased: ${comparison.hasIncreased}'); // true
print('Change: ${comparison.percentageChange}%'); // +1.69%
```

### Validate Cached Data

```dart
final rates = await repository.getExchangeRates('USD');

// Check if usable
final canUse = OfflineHandler.canUseCachedData(rates);

// Validate integrity
final isValid = OfflineHandler.validateCachedData(rates);

// Check if should refresh
final needsRefresh = OfflineHandler.shouldRefresh(rates);
```

---

## Providers Reference

```dart
// Services
final networkServiceProvider
final exchangeRateServiceProvider
final batchConversionServiceProvider
final rateRefreshSchedulerProvider

// Repositories
final exchangeRateRepositoryProvider
final historyRepositoryProvider

// State Management
final exchangeRateManagerProvider
final conversionProvider
final favoriteCurrenciesProvider
```

---

## Error Handling

```dart
try {
  final result = await repository.convertCurrency(
    from: 'USD',
    to: 'EUR',
    amount: 100,
  );
} on DioException catch (e) {
  if (e.type == DioExceptionType.connectionTimeout) {
    showError('Connection timeout');
  } else if (e.type == DioExceptionType.connectionError) {
    showError('No internet connection');
  }
} catch (e) {
  showError('Conversion failed: $e');
}
```

---

## Constants

```dart
// Cache duration
const cacheDuration = Duration(hours: 12);

// Refresh interval
const refreshInterval = Duration(hours: 6);

// Max cache age (offline)
const maxCacheAge = Duration(days: 7);

// Timeout
const apiTimeout = Duration(seconds: 10);
```

---

## Supported Currencies

**26 Major Currencies**:
USD 🇺🇸, EUR 🇪🇺, GBP 🇬🇧, JPY 🇯🇵, CHF 🇨🇭, CAD 🇨🇦, AUD 🇦🇺, CNY 🇨🇳, INR 🇮🇳, MXN 🇲🇽, BRL 🇧🇷, RUB 🇷🇺, KRW 🇰🇷, ILS 🇮🇱, SEK 🇸🇪, NOK 🇳🇴, DKK 🇩🇰, PLN 🇵🇱, TRY 🇹🇷, NZD 🇳🇿, SGD 🇸🇬, HKD 🇭🇰, ZAR 🇿🇦, THB 🇹🇭, AED 🇦🇪, SAR 🇸🇦

---

## Performance Tips

1. **Preload frequently used currencies** at app start
2. **Use batch conversion** for multiple targets
3. **Don't clear cache** unless necessary
4. **Let scheduler handle refreshes** automatically
5. **Check network before fetching** to avoid errors

---

## Testing Helpers

```dart
// Mock repository
class MockExchangeRateRepository extends Mock
    implements ExchangeRateRepository {}

// Mock network service
class MockNetworkService extends Mock
    implements NetworkService {}

// Create test rates
final testRates = ExchangeRateModel(
  baseCurrency: 'USD',
  rates: {'EUR': 0.85, 'GBP': 0.73},
  lastUpdated: DateTime.now(),
);
```

---

For complete documentation, see: **EXCHANGE_RATE_MODULE.md**
