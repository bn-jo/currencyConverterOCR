/// OCR extraction result
class OcrResultModel {
  final String text;
  final double confidence;
  final List<OcrTextBlock> blocks;

  OcrResultModel({
    required this.text,
    required this.confidence,
    required this.blocks,
  });

  bool get isConfident => confidence >= 0.7;
}

/// Text block from OCR
class OcrTextBlock {
  final String text;
  final double confidence;
  final BoundingBox boundingBox;

  OcrTextBlock({
    required this.text,
    required this.confidence,
    required this.boundingBox,
  });
}

/// Bounding box for text location
class BoundingBox {
  final double left;
  final double top;
  final double width;
  final double height;

  BoundingBox({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });
}
