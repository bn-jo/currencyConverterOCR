import 'package:flutter/material.dart';
import '../../data/models/currency_metadata.dart';

/// Currency picker screen for selecting a currency to add
class CurrencyPickerScreen extends StatefulWidget {
  const CurrencyPickerScreen({super.key});

  @override
  State<CurrencyPickerScreen> createState() => _CurrencyPickerScreenState();
}

class _CurrencyPickerScreenState extends State<CurrencyPickerScreen> {
  String _searchQuery = '';
  List<CurrencyMetadata> _allCurrencies = [];
  List<CurrencyMetadata> _filteredCurrencies = [];

  @override
  void initState() {
    super.initState();
    _allCurrencies = CurrencyDatabase.currencies.values.toList();
    _allCurrencies.sort((a, b) => a.name.compareTo(b.name));
    _filteredCurrencies = _allCurrencies;
  }

  void _filterCurrencies(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredCurrencies = _allCurrencies;
      } else {
        _filteredCurrencies = _allCurrencies.where((currency) {
          final lowerQuery = query.toLowerCase();
          return currency.code.toLowerCase().contains(lowerQuery) ||
                 currency.name.toLowerCase().contains(lowerQuery) ||
                 currency.countries.any((country) => country.toLowerCase().contains(lowerQuery));
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Add Currency'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: _filterCurrencies,
              decoration: InputDecoration(
                hintText: 'Search currency...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),

          // Currency list
          Expanded(
            child: _filteredCurrencies.isEmpty
                ? Center(
                    child: Text(
                      'No currencies found',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredCurrencies.length,
                    itemBuilder: (context, index) {
                      final currency = _filteredCurrencies[index];

                      return ListTile(
                        onTap: () {
                          Navigator.pop(context, currency.code);
                        },
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white24,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              currency.flag ?? '🏳️',
                              style: const TextStyle(fontSize: 28),
                            ),
                          ),
                        ),
                        title: Text(
                          currency.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          '${currency.code} • ${currency.symbol}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        trailing: Icon(
                          Icons.add_circle_outline,
                          color: Theme.of(context).primaryColor,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
