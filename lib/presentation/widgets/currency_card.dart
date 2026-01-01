import 'package:flutter/material.dart';
import '../../data/models/currency_metadata.dart';

/// Currency card widget displaying currency with converted amount
class CurrencyCard extends StatelessWidget {
  final String currencyCode;
  final double amount;
  final VoidCallback? onCameraPressed;
  final VoidCallback? onAmountTap;
  final VoidCallback? onDelete;

  const CurrencyCard({
    super.key,
    required this.currencyCode,
    required this.amount,
    this.onCameraPressed,
    this.onAmountTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final currency = CurrencyDatabase.get(currencyCode);
    if (currency == null) {
      return const SizedBox.shrink();
    }

    return Dismissible(
      key: Key('currency_card_$currencyCode'),
      direction: onDelete != null ? DismissDirection.endToStart : DismissDirection.none,
      onDismissed: (_) => onDelete?.call(),
      confirmDismiss: (_) async {
        return onDelete != null;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: Color(0xFF0175C2), // Blue border
            width: 2,
          ),
        ),
        color: const Color(0xFF2C2C2C), // Dark background
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            children: [
              // Camera icon button
              InkWell(
                onTap: onCameraPressed,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0175C2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Left side: Symbol and amount (tappable)
              Expanded(
                flex: 4,
                child: InkWell(
                  onTap: onAmountTap,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          currency.symbol,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Flexible(
                          child: Text(
                            amount.toStringAsFixed(currency.decimalDigits),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Right side: Currency code, name and flag
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currencyCode,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            currency.name,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.end,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Flag
                    Container(
                      width: 40,
                      height: 40,
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
                          style: const TextStyle(fontSize: 26),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
