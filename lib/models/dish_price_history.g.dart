// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dish_price_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DishPriceHistory _$DishPriceHistoryFromJson(Map<String, dynamic> json) =>
    DishPriceHistory(
      dishPriceHistoryId: json['dishPriceHistoryId'] as String,
      price: json['price'] as num?,
      recordDate: json['recordDate'] == null
          ? null
          : DateTime.parse(json['recordDate'] as String),
    );

Map<String, dynamic> _$DishPriceHistoryToJson(DishPriceHistory instance) =>
    <String, dynamic>{
      'dishPriceHistoryId': instance.dishPriceHistoryId,
      'price': instance.price,
      'recordDate': instance.recordDate?.toIso8601String(),
    };
