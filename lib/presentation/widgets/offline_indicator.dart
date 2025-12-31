import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/utils/offline_handler.dart';

/// Widget to display offline mode status
class OfflineIndicator extends StatelessWidget {
  final bool isOffline;
  final DateTime? lastUpdate;

  const OfflineIndicator({
    super.key,
    required this.isOffline,
    this.lastUpdate,
  });

  @override
  Widget build(BuildContext context) {
    if (!isOffline) {
      return const SizedBox.shrink();
    }

    final ageDescription = lastUpdate != null
        ? OfflineHandler.getCacheAgeDescription(lastUpdate!)
        : 'Unknown';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.orange[100],
      child: Row(
        children: [
          Icon(
            Icons.cloud_off,
            size: 20,
            color: Colors.orange[900],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'offline_mode'.tr() + ' • $ageDescription',
              style: TextStyle(
                color: Colors.orange[900],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Banner showing cache status
class CacheStatusBanner extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color? color;

  const CacheStatusBanner({
    super.key,
    required this.message,
    this.icon = Icons.info_outline,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final bannerColor = color ?? Colors.blue[100];
    final textColor = color != null ? Colors.white : Colors.blue[900];

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bannerColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: textColor, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
