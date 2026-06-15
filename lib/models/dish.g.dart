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
    return Dish(
      dishId: fields[0] as String?,
      categoryId: fields[1] as String?,
      name: fields[2] as String?,
      price: fields[3] as num?,
      region: fields[4] as String?,
      cover: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Dish obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.dishId)
      ..writeByte(1)
      ..write(obj.categoryId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.region)
      ..writeByte(5)
      ..write(obj.cover);
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

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dish _$DishFromJson(Map<String, dynamic> json) => Dish(
      dishId: json['dishId'] as String?,
      categoryId: json['categoryId'] as String?,
      name: json['name'] as String?,
      price: json['price'] as num?,
      region: json['region'] as String?,
      cover: json['cover'] as String?,
    );

Map<String, dynamic> _$DishToJson(Dish instance) => <String, dynamic>{
      'dishId': instance.dishId,
      'categoryId': instance.categoryId,
      'name': instance.name,
      'price': instance.price,
      'region': instance.region,
      'cover': instance.cover,
    };
