import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ConversionResultCard extends StatelessWidget {
  final double sourceAmount;
  final String sourceCurrency;
  final double targetAmount;
  final String targetCurrency;
  final double exchangeRate;
  final bool fromCache;

  const ConversionResultCard({
    super.key,
    required this.sourceAmount,
    required this.sourceCurrency,
    required this.targetAmount,
    required this.targetCurrency,
    required this.exchangeRate,
    required this.fromCache,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Source Amount
            Text(
              '$sourceAmount $sourceCurrency',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),

            // Arrow
            const Icon(Icons.arrow_downward, size: 32),
            const SizedBox(height: 8),

            // Target Amount
            Text(
              '${targetAmount.toStringAsFixed(2)} $targetCurrency',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // Exchange Rate
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '1 $sourceCurrency = ${exchangeRate.toStringAsFixed(4)} $targetCurrency',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),

            // Cache Indicator
            if (fromCache) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Colors.orange[700],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'using_cached_rates'.tr(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange[700],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
