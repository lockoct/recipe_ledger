// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PriceRecordAdapter extends TypeAdapter<PriceRecord> {
  @override
  final int typeId = 104;

  @override
  PriceRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PriceRecord(
      id: fields[0] as String,
      dishId: fields[1] as String,
      price: fields[2] as double,
      date: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PriceRecord obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.dishId)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PriceRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
