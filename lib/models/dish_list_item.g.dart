// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dish_list_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DishListItemAdapter extends TypeAdapter<DishListItem> {
  @override
  final int typeId = 105;

  @override
  DishListItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DishListItem(
      dishId: fields[0] as String,
      name: fields[1] as String,
      categoryId: fields[2] as String,
      cover: fields[3] as String?,
      price: fields[4] as double,
      region: fields[5] as String,
      dailyChange: fields[6] as double?,
      monthlyChange: fields[7] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, DishListItem obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.dishId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.categoryId)
      ..writeByte(3)
      ..write(obj.cover)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.region)
      ..writeByte(6)
      ..write(obj.dailyChange)
      ..writeByte(7)
      ..write(obj.monthlyChange);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DishListItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DishListItem _$DishListItemFromJson(Map<String, dynamic> json) => DishListItem(
      dishId: json['dishId'] as String,
      name: json['name'] as String,
      categoryId: json['categoryId'] as String,
      cover: json['cover'] as String?,
      price: (json['price'] as num).toDouble(),
      region: json['region'] as String,
      dailyChange: (json['dailyChange'] as num?)?.toDouble(),
      monthlyChange: (json['monthlyChange'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DishListItemToJson(DishListItem instance) =>
    <String, dynamic>{
      'dishId': instance.dishId,
      'name': instance.name,
      'categoryId': instance.categoryId,
      'cover': instance.cover,
      'price': instance.price,
      'region': instance.region,
      'dailyChange': instance.dailyChange,
      'monthlyChange': instance.monthlyChange,
    };
