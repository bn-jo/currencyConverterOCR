import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/ocr_result_model.dart';
import '../../data/services/ocr_service.dart';
import '../../core/utils/image_utils.dart';
import '../../core/utils/text_parser.dart';

/// Provider for OCR service
final ocrServiceProvider = Provider<OcrService>((ref) {
  return OcrService();
});

/// Provider for OCR state
final ocrProvider = StateNotifierProvider<OcrNotifier, OcrState>((ref) {
  final service = ref.watch(ocrServiceProvider);
  return OcrNotifier(service);
});

/// OCR state
class OcrState {
  final bool isProcessing;
  final OcrResultModel? result;
  final ParseResult? parseResult;
  final String? error;

  OcrState({
    this.isProcessing = false,
    this.result,
    this.parseResult,
    this.error,
  });

  OcrState copyWith({
    bool? isProcessing,
    OcrResultModel? result,
    ParseResult? parseResult,
    String? error,
  }) {
    return OcrState(
      isProcessing: isProcessing ?? this.isProcessing,
      result: result ?? this.result,
      parseResult: parseResult ?? this.parseResult,
      error: error,
    );
  }
}

/// OCR notifier
class OcrNotifier extends StateNotifier<OcrState> {
  final OcrService _service;

  OcrNotifier(this._service) : super(OcrState());

  /// Process image and extract text
  Future<void> processImage(File imageFile) async {
    state = state.copyWith(isProcessing: true, error: null);

    try {
      // Preprocess image
      final processedImage = await ImageUtils.preprocessImage(imageFile);

      // Extract text with OCR
      final result = await _service.extractTextWithRetry(processedImage);

      // Parse text to extract currency and amount
      final parseResult = TextParser.parseText(result.text);

      state = state.copyWith(
        isProcessing: false,
        result: result,
        parseResult: parseResult,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        error: 'Failed to process image: $e',
      );
    }
  }

  /// Clear OCR results
  void clearResults() {
    state = OcrState();
  }

  /// Update parse result manually (e.g., user correction)
  void updateParseResult(ParseResult parseResult) {
    state = state.copyWith(parseResult: parseResult);
  }
}
