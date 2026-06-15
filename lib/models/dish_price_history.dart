import "package:json_annotation/json_annotation.dart";

part "dish_price_history.g.dart";

@JsonSerializable()
class DishPriceHistory {
  final String dishPriceHistoryId;
  final num? price;
  final DateTime? recordDate;

  DishPriceHistory({
    required this.dishPriceHistoryId,
    this.price,
    this.recordDate,
  });

  factory DishPriceHistory.fromJson(Map<String, dynamic> json) =>
      _$DishPriceHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$DishPriceHistoryToJson(this);
}
