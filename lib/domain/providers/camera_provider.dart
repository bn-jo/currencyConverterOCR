import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

/// Provider for camera state
final cameraProvider = StateNotifierProvider<CameraNotifier, CameraState>((ref) {
  return CameraNotifier();
});

/// Camera state
class CameraState {
  final CameraController? controller;
  final bool isInitialized;
  final String? error;

  CameraState({
    this.controller,
    this.isInitialized = false,
    this.error,
  });

  CameraState copyWith({
    CameraController? controller,
    bool? isInitialized,
    String? error,
  }) {
    return CameraState(
      controller: controller ?? this.controller,
      isInitialized: isInitialized ?? this.isInitialized,
      error: error,
    );
  }
}

/// Camera notifier
class CameraNotifier extends StateNotifier<CameraState> {
  CameraNotifier() : super(CameraState());

  final ImagePicker _picker = ImagePicker();

  /// Initialize camera
  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        state = state.copyWith(error: 'No cameras available');
        return;
      }

      final camera = cameras.first;
      final controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await controller.initialize();

      state = state.copyWith(
        controller: controller,
        isInitialized: true,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: 'Failed to initialize camera: $e');
    }
  }

  /// Capture image from camera
  Future<File?> captureImage() async {
    final controller = state.controller;
    if (controller == null || !controller.value.isInitialized) {
      return null;
    }

    try {
      final image = await controller.takePicture();
      return File(image.path);
    } catch (e) {
      state = state.copyWith(error: 'Failed to capture image: $e');
      return null;
    }
  }

  /// Pick image from gallery
  Future<File?> pickImageFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile == null) return null;

      return File(pickedFile.path);
    } catch (e) {
      state = state.copyWith(error: 'Failed to pick image: $e');
      return null;
    }
  }

  /// Dispose camera
  void disposeCamera() {
    state.controller?.dispose();
    state = CameraState();
  }

  @override
  void dispose() {
    disposeCamera();
    super.dispose();
  }
}
