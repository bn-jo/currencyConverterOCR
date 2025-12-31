import 'package:hive/hive.dart';

part 'conversion_history_model.g.dart';

@HiveType(typeId: 2)
class ConversionHistoryModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String sourceCurrency;

  @HiveField(2)
  final String targetCurrency;

  @HiveField(3)
  final double sourceAmount;

  @HiveField(4)
  final double targetAmount;

  @HiveField(5)
  final double exchangeRate;

  @HiveField(6)
  final DateTime timestamp;

  @HiveField(7)
  final String? ocrText;

  @HiveField(8)
  final double? ocrConfidence;

  ConversionHistoryModel({
    required this.id,
    required this.sourceCurrency,
    required this.targetCurrency,
    required this.sourceAmount,
    required this.targetAmount,
    required this.exchangeRate,
    required this.timestamp,
    this.ocrText,
    this.ocrConfidence,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sourceCurrency': sourceCurrency,
      'targetCurrency': targetCurrency,
      'sourceAmount': sourceAmount,
      'targetAmount': targetAmount,
      'exchangeRate': exchangeRate,
      'timestamp': timestamp.toIso8601String(),
      'ocrText': ocrText,
      'ocrConfidence': ocrConfidence,
    };
  }

  factory ConversionHistoryModel.fromJson(Map<String, dynamic> json) {
    return ConversionHistoryModel(
      id: json['id'] as String,
      sourceCurrency: json['sourceCurrency'] as String,
      targetCurrency: json['targetCurrency'] as String,
      sourceAmount: (json['sourceAmount'] as num).toDouble(),
      targetAmount: (json['targetAmount'] as num).toDouble(),
      exchangeRate: (json['exchangeRate'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      ocrText: json['ocrText'] as String?,
      ocrConfidence: json['ocrConfidence'] != null
          ? (json['ocrConfidence'] as num).toDouble()
          : null,
    );
  }
}
