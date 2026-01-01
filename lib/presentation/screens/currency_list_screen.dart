import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/currency_card.dart';
import '../../domain/providers/settings_provider.dart';
import '../../domain/providers/currency_list_provider.dart';
import '../../domain/providers/ocr_provider.dart';
import 'currency_picker_screen.dart';
import 'camera_screen.dart';
import 'settings_screen.dart';

/// Currency list screen showing all favorite currencies
class CurrencyListScreen extends ConsumerStatefulWidget {
  const CurrencyListScreen({super.key});

  @override
  ConsumerState<CurrencyListScreen> createState() => _CurrencyListScreenState();
}

class _CurrencyListScreenState extends ConsumerState<CurrencyListScreen> {
  @override
  void initState() {
    super.initState();
    // Load conversions after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = ref.read(settingsProvider);
      final currencyList = ref.read(currencyListProvider.notifier);
      currencyList.refreshConversions(settings.favoriteCurrencies);
    });
  }

  /// Open camera and process OCR for a specific currency
  Future<void> _openCameraForCurrency(String currencyCode) async {
    // Navigate to camera screen
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CameraScreen(),
      ),
    );

    if (!mounted) return;

    // Get OCR result
    final ocrState = ref.read(ocrProvider);

    if (ocrState.parseResult != null && ocrState.parseResult!.isValid) {
      final amount = ocrState.parseResult!.amount!; // Safe to use ! because isValid checks it's not null
      final detectedCurrency = ocrState.parseResult!.currency;

      // If currency was detected in OCR and it's different from selected,
      // use detected currency, otherwise use the tapped currency
      final baseCurrency = (detectedCurrency != null && detectedCurrency != currencyCode)
          ? detectedCurrency
          : currencyCode;

      // Set base currency and amount
      ref.read(currencyListProvider.notifier).setBaseCurrency(baseCurrency);
      ref.read(currencyListProvider.notifier).setBaseAmount(amount);

      // Refresh all conversions
      final settings = ref.read(settingsProvider);
      await ref.read(currencyListProvider.notifier).refreshConversions(settings.favoriteCurrencies);

      // Clear OCR results
      ref.read(ocrProvider.notifier).clearResults();
    }
  }

  /// Show amount input dialog
  Future<void> _showAmountInputDialog(String currencyCode, double currentAmount) async {
    final controller = TextEditingController(text: currentAmount > 0 ? currentAmount.toString() : '');

    final result = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
          title: Text('Enter Amount ($currencyCode)'),
          content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(fontSize: 24),
            cursorColor: Theme.of(context).primaryColor,
            decoration: InputDecoration(
              hintText: '0.00',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  controller.clear();
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final amount = double.tryParse(controller.text);
                Navigator.pop(context, amount);
              },
              child: Text(
                'OK',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
    );

    if (result != null && mounted) {
      // Set base currency and amount
      final notifier = ref.read(currencyListProvider.notifier);
      final settings = ref.read(settingsProvider);

      // Debug print
      print('Input amount: $result for currency: $currencyCode');
      print('Favorite currencies: ${settings.favoriteCurrencies}');

      notifier.setBaseCurrency(currencyCode);
      notifier.setBaseAmount(result);

      // Always refresh conversions to update all currencies
      print('Starting conversion refresh...');
      await notifier.refreshConversions(settings.favoriteCurrencies);
      print('Conversion refresh complete');
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final currencyListState = ref.watch(currencyListProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/app_logo.png',
              width: 40,
              height: 40,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              // Clear all amounts
              final notifier = ref.read(currencyListProvider.notifier);
              final settings = ref.read(settingsProvider);
              notifier.setBaseAmount(0);
              await notifier.refreshConversions(settings.favoriteCurrencies);
            },
            tooltip: 'Clear all amounts',
          ),
        ],
      ),
      body: Column(
        children: [
          // Currency list
          Expanded(
            child: settings.favoriteCurrencies.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.currency_exchange,
                          size: 64,
                          color: Theme.of(context).iconTheme.color?.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No currencies added',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap + to add currencies',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      await ref
                          .read(currencyListProvider.notifier)
                          .refreshConversions(settings.favoriteCurrencies);
                    },
                    child: ReorderableListView.builder(
                      padding: const EdgeInsets.only(top: 16),
                      itemCount: settings.favoriteCurrencies.length,
                      onReorder: (oldIndex, newIndex) async {
                        await ref.read(settingsProvider.notifier).reorderFavoriteCurrencies(oldIndex, newIndex);
                      },
                      itemBuilder: (context, index) {
                        final currencyCode = settings.favoriteCurrencies[index];
                        final amount = currencyListState.convertedAmounts[currencyCode] ?? 0.0;

                        return CurrencyCard(
                          key: ValueKey('card_$currencyCode'),
                          currencyCode: currencyCode,
                          amount: amount,
                          onCameraPressed: () {
                            // Open camera for this currency
                            _openCameraForCurrency(currencyCode);
                          },
                          onAmountTap: () {
                            // Show amount input dialog
                            _showAmountInputDialog(currencyCode, amount);
                          },
                          onDelete: () async {
                            await ref.read(settingsProvider.notifier).removeFavoriteCurrency(currencyCode);
                          },
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_currency_fab',
        onPressed: () async {
          // Navigate to currency picker
          final result = await Navigator.push<String>(
            context,
            MaterialPageRoute(
              builder: (_) => const CurrencyPickerScreen(),
            ),
          );

          if (result != null && mounted) {
            await ref.read(settingsProvider.notifier).addFavoriteCurrency(result);
            // Refresh conversions
            final settings = ref.read(settingsProvider);
            await ref.read(currencyListProvider.notifier).refreshConversions(settings.favoriteCurrencies);
          }
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
