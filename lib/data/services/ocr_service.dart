import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../models/ocr_result_model.dart';

/// Service for OCR text recognition
class OcrService {
  final TextRecognizer _textRecognizer = TextRecognizer();

  /// Extract text from image file
  Future<OcrResultModel> extractTextFromImage(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      final blocks = recognizedText.blocks.map((block) {
        final boundingBox = block.boundingBox;
        return OcrTextBlock(
          text: block.text,
          confidence: 1.0, // Google ML Kit doesn't provide confidence at block level
          boundingBox: BoundingBox(
            left: boundingBox.left,
            top: boundingBox.top,
            width: boundingBox.width,
            height: boundingBox.height,
          ),
        );
      }).toList();

      // Use a default confidence since Google ML Kit doesn't provide it
      final averageConfidence = 0.8;

      return OcrResultModel(
        text: recognizedText.text,
        confidence: averageConfidence,
        blocks: blocks,
      );
    } catch (e) {
      throw Exception('OCR failed: $e');
    }
  }

  /// Extract text with multiple attempts and preprocessing
  Future<OcrResultModel> extractTextWithRetry(
    File imageFile, {
    int maxRetries = 3,
  }) async {
    OcrResultModel? bestResult;
    double bestConfidence = 0.0;

    for (int i = 0; i < maxRetries; i++) {
      try {
        final result = await extractTextFromImage(imageFile);

        if (result.confidence > bestConfidence) {
          bestResult = result;
          bestConfidence = result.confidence;
        }

        // If confidence is high enough, return immediately
        if (result.confidence >= 0.9) {
          return result;
        }
      } catch (e) {
        if (i == maxRetries - 1) {
          rethrow;
        }
      }
    }

    if (bestResult == null) {
      throw Exception('OCR failed after multiple attempts');
    }

    return bestResult;
  }

  /// Close the text recognizer
  void dispose() {
    _textRecognizer.close();
  }
}
