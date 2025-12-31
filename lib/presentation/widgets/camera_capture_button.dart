import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../screens/camera_screen.dart';

class CameraCaptureButton extends StatelessWidget {
  final VoidCallback? onImageCaptured;

  const CameraCaptureButton({
    super.key,
    this.onImageCaptured,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CameraScreen()),
          );

          if (result != null && onImageCaptured != null) {
            onImageCaptured!();
          }
        },
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.camera_alt,
                size: 64,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              Text(
                'capture_currency'.tr(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'tap_to_start'.tr(),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
