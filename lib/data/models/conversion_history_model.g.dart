// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversion_history_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConversionHistoryModelAdapter
    extends TypeAdapter<ConversionHistoryModel> {
  @override
  final int typeId = 2;

  @override
  ConversionHistoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConversionHistoryModel(
      id: fields[0] as String,
      sourceCurrency: fields[1] as String,
      targetCurrency: fields[2] as String,
      sourceAmount: fields[3] as double,
      targetAmount: fields[4] as double,
      exchangeRate: fields[5] as double,
      timestamp: fields[6] as DateTime,
      ocrText: fields[7] as String?,
      ocrConfidence: fields[8] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, ConversionHistoryModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sourceCurrency)
      ..writeByte(2)
      ..write(obj.targetCurrency)
      ..writeByte(3)
      ..write(obj.sourceAmount)
      ..writeByte(4)
      ..write(obj.targetAmount)
      ..writeByte(5)
      ..write(obj.exchangeRate)
      ..writeByte(6)
      ..write(obj.timestamp)
      ..writeByte(7)
      ..write(obj.ocrText)
      ..writeByte(8)
      ..write(obj.ocrConfidence);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConversionHistoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
