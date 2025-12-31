import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:camera/camera.dart';
import '../../domain/providers/camera_provider.dart';
import '../../domain/providers/ocr_provider.dart';

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cameraProvider.notifier).initializeCamera();
    });
  }

  @override
  void dispose() {
    // Don't access ref in dispose - the camera provider will auto-dispose
    super.dispose();
  }

  Future<void> _captureAndProcess() async {
    final imageFile = await ref.read(cameraProvider.notifier).captureImage();

    if (imageFile != null && mounted) {
      // Process with OCR
      await ref.read(ocrProvider.notifier).processImage(imageFile);

      // Return to previous screen
      if (mounted) {
        Navigator.pop(context, imageFile);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cameraState = ref.watch(cameraProvider);
    final ocrState = ref.watch(ocrProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('capture_image'.tr()),
      ),
      body: Stack(
        children: [
          // Camera Preview
          if (cameraState.isInitialized && cameraState.controller != null)
            Center(
              child: CameraPreview(cameraState.controller!),
            )
          else if (cameraState.error != null)
            Center(
              child: Text(
                cameraState.error!,
                style: const TextStyle(color: Colors.white),
              ),
            )
          else
            const Center(
              child: CircularProgressIndicator(),
            ),

          // Processing Overlay
          if (ocrState.isProcessing)
            Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      'processing_image'.tr(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

          // Capture Button
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton.large(
                heroTag: 'capture_fab',
                onPressed: cameraState.isInitialized && !ocrState.isProcessing
                    ? _captureAndProcess
                    : null,
                child: const Icon(Icons.camera, size: 36),
              ),
            ),
          ),

          // Gallery Button
          Positioned(
            bottom: 48,
            left: 32,
            child: FloatingActionButton(
              heroTag: 'gallery_fab',
              onPressed: () async {
                final imageFile =
                    await ref.read(cameraProvider.notifier).pickImageFromGallery();
                if (imageFile != null && mounted) {
                  await ref.read(ocrProvider.notifier).processImage(imageFile);
                  if (mounted) {
                    Navigator.pop(context, imageFile);
                  }
                }
              },
              child: const Icon(Icons.photo_library),
            ),
          ),
        ],
      ),
    );
  }
}
