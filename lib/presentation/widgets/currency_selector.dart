import 'package:flutter/material.dart';
import '../../core/constants/currency_symbols.dart';

class CurrencySelector extends StatelessWidget {
  final String label;
  final String? selectedCurrency;
  final ValueChanged<String> onCurrencySelected;

  const CurrencySelector({
    super.key,
    required this.label,
    required this.selectedCurrency,
    required this.onCurrencySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _showCurrencyPicker(context),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedCurrency ?? 'Select Currency',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showCurrencyPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.builder(
        itemCount: CurrencySymbols.popularCurrencies.length,
        itemBuilder: (context, index) {
          final currency = CurrencySymbols.popularCurrencies[index];
          final symbol = CurrencySymbols.codeToSymbol[currency] ?? '';

          return ListTile(
            leading: Text(
              symbol,
              style: const TextStyle(fontSize: 24),
            ),
            title: Text(currency),
            selected: currency == selectedCurrency,
            onTap: () {
              onCurrencySelected(currency);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
