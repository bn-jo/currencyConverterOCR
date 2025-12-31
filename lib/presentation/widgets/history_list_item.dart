import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/conversion_history_model.dart';

class HistoryListItem extends StatelessWidget {
  final ConversionHistoryModel item;
  final VoidCallback onDelete;

  const HistoryListItem({
    super.key,
    required this.item,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMd().add_jm();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(item.sourceCurrency.substring(0, 1)),
        ),
        title: Text(
          '${item.sourceAmount.toStringAsFixed(2)} ${item.sourceCurrency} → ${item.targetAmount.toStringAsFixed(2)} ${item.targetCurrency}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rate: ${item.exchangeRate.toStringAsFixed(4)}'),
            Text(
              dateFormat.format(item.timestamp),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            if (item.ocrConfidence != null)
              Row(
                children: [
                  const Icon(Icons.camera_alt, size: 12),
                  const SizedBox(width: 4),
                  Text(
                    'OCR: ${(item.ocrConfidence! * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
