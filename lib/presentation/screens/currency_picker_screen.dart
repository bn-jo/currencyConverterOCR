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
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        title: const Text(
          'Add Currency',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: _filterCurrencies,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search currency...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF2C2C2C),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF4CAF50),
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
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 16,
                      ),
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
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          '${currency.code} • ${currency.symbol}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.add_circle_outline,
                          color: Color(0xFF4CAF50),
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
