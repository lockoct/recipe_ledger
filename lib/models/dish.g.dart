// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dish.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DishAdapter extends TypeAdapter<Dish> {
  @override
  final int typeId = 100;

  @override
  Dish read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    // 处理旧数据可能缺少category字段的情况
    String category;
    if (fields.containsKey(5) && fields[5] != null) {
      category = fields[5] as String;
    } else {
      // 为旧数据提供默认分类
      category = '未分类';
    }

    return Dish(
      id: fields[0] as String,
      name: fields[1] as String,
      price: fields[2] as double,
      city: fields[3] as String,
      updateTime: fields[4] as DateTime,
      category: category,
    );
  }

  @override
  void write(BinaryWriter writer, Dish obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.city)
      ..writeByte(4)
      ..write(obj.updateTime)
      ..writeByte(5)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DishAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
