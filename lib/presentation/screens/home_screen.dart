import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/camera_capture_button.dart';
import '../widgets/conversion_result_card.dart';
import '../widgets/currency_selector.dart';
import '../../domain/providers/ocr_provider.dart';
import '../../domain/providers/conversion_provider.dart';
import '../../domain/providers/settings_provider.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? _sourceCurrency;
  String? _targetCurrency;
  double? _amount;

  @override
  void initState() {
    super.initState();
    // Initialize with default currencies
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = ref.read(settingsProvider);
      setState(() {
        _sourceCurrency = settings.defaultSourceCurrency;
        _targetCurrency = settings.defaultTargetCurrency;
      });
    });
  }

  void _handleOcrComplete() {
    final ocrState = ref.read(ocrProvider);
    if (ocrState.parseResult != null && ocrState.parseResult!.isValid) {
      setState(() {
        _sourceCurrency = ocrState.parseResult!.currency;
        _amount = ocrState.parseResult!.amount;
      });

      // Auto-convert if we have all required data
      if (_sourceCurrency != null && _targetCurrency != null && _amount != null) {
        _performConversion();
      }
    }
  }

  void _performConversion() {
    if (_sourceCurrency == null || _targetCurrency == null || _amount == null) {
      return;
    }

    final ocrState = ref.read(ocrProvider);
    ref.read(conversionProvider.notifier).convertCurrency(
          from: _sourceCurrency!,
          to: _targetCurrency!,
          amount: _amount!,
          ocrText: ocrState.result?.text,
          ocrConfidence: ocrState.result?.confidence,
        );
  }

  @override
  Widget build(BuildContext context) {
    final ocrState = ref.watch(ocrProvider);
    final conversionState = ref.watch(conversionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('app_title'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Camera Capture Button
              CameraCaptureButton(
                onImageCaptured: _handleOcrComplete,
              ),
              const SizedBox(height: 24),

              // OCR Result Display
              if (ocrState.result != null) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ocr_result'.tr(),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ocrState.result!.text,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: ocrState.result!.confidence,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            ocrState.result!.isConfident
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                        Text(
                          '${'confidence'.tr()}: ${(ocrState.result!.confidence * 100).toStringAsFixed(1)}%',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Currency Selectors
              CurrencySelector(
                label: 'from_currency'.tr(),
                selectedCurrency: _sourceCurrency,
                onCurrencySelected: (currency) {
                  setState(() {
                    _sourceCurrency = currency;
                  });
                },
              ),
              const SizedBox(height: 16),

              CurrencySelector(
                label: 'to_currency'.tr(),
                selectedCurrency: _targetCurrency,
                onCurrencySelected: (currency) {
                  setState(() {
                    _targetCurrency = currency;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Amount Input
              TextField(
                decoration: InputDecoration(
                  labelText: 'amount'.tr(),
                  prefixIcon: const Icon(Icons.money),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _amount = double.tryParse(value);
                  });
                },
                controller: _amount != null
                    ? TextEditingController(text: _amount.toString())
                    : null,
              ),
              const SizedBox(height: 24),

              // Convert Button
              ElevatedButton(
                onPressed: _sourceCurrency != null &&
                        _targetCurrency != null &&
                        _amount != null &&
                        !conversionState.isLoading
                    ? _performConversion
                    : null,
                child: conversionState.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('convert'.tr()),
              ),
              const SizedBox(height: 24),

              // Conversion Result
              if (conversionState.convertedAmount != null)
                ConversionResultCard(
                  sourceAmount: _amount!,
                  sourceCurrency: _sourceCurrency!,
                  targetAmount: conversionState.convertedAmount!,
                  targetCurrency: _targetCurrency!,
                  exchangeRate: conversionState.exchangeRate!,
                  fromCache: conversionState.fromCache,
                ),

              // Error Display
              if (conversionState.error != null)
                Card(
                  color: Colors.red[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      conversionState.error!,
                      style: TextStyle(color: Colors.red[900]),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
