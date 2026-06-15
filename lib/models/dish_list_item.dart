import "package:hive/hive.dart";
import "package:json_annotation/json_annotation.dart";

part "dish_list_item.g.dart";

/// 菜品列表项模型
@HiveType(typeId: 105)
@JsonSerializable()
class DishListItem extends HiveObject {
  /// 菜品ID
  @HiveField(0)
  final String dishId;

  /// 菜品名称
  @HiveField(1)
  final String name;

  /// 分类ID
  @HiveField(2)
  final String categoryId;

  /// 封面路径
  @HiveField(3)
  final String? cover;

  /// 价格（单位：元/斤）
  @HiveField(4)
  final double price;

  /// 区域
  @HiveField(5)
  final String region;

  /// 较昨日价格变化
  @HiveField(6)
  final double? dailyChange;

  /// 较上月价格变化
  @HiveField(7)
  final double? monthlyChange;

  /// 构造函数
  DishListItem({
    required this.dishId,
    required this.name,
    required this.categoryId,
    this.cover,
    required this.price,
    required this.region,
    this.dailyChange,
    this.monthlyChange,
  });

  /// 反序列化
  factory DishListItem.fromJson(Map<String, dynamic> json) =>
      _$DishListItemFromJson(json);

  /// 序列化
  Map<String, dynamic> toJson() => _$DishListItemToJson(this);
}
