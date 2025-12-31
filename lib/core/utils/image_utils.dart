import 'dart:io';
import 'package:image/image.dart' as img;
import '../constants/app_constants.dart';

/// Utility class for image processing operations
class ImageUtils {
  /// Compress and resize image to optimize for OCR
  static Future<File> preprocessImage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    img.Image? image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // Resize if too large
    if (image.width > AppConstants.maxImageWidth ||
        image.height > AppConstants.maxImageHeight) {
      image = img.copyResize(
        image,
        width: AppConstants.maxImageWidth,
        height: AppConstants.maxImageHeight,
      );
    }

    // Enhance contrast for better OCR
    image = img.adjustColor(
      image,
      contrast: 1.2,
      brightness: 1.1,
    );

    // Convert to grayscale for better text recognition
    image = img.grayscale(image);

    // Save processed image
    final processedBytes = img.encodeJpg(
      image,
      quality: AppConstants.imageQuality,
    );

    await imageFile.writeAsBytes(processedBytes);
    return imageFile;
  }

  /// Rotate image by specified degrees
  static Future<File> rotateImage(File imageFile, int degrees) async {
    final bytes = await imageFile.readAsBytes();
    img.Image? image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    final rotated = img.copyRotate(image, angle: degrees);
    final rotatedBytes = img.encodeJpg(rotated, quality: 85);

    await imageFile.writeAsBytes(rotatedBytes);
    return imageFile;
  }

  /// Check if image file is valid
  static Future<bool> isValidImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);
      return image != null;
    } catch (e) {
      return false;
    }
  }
}
