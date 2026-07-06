import "package:hive/hive.dart";
import "package:json_annotation/json_annotation.dart";

part "dish.g.dart";

/// 菜品数据模型
@HiveType(typeId: 100)
@JsonSerializable()
class Dish {
  /// 主键
  @HiveField(0)
  final String? dishId;

  /// 分类ID
  @HiveField(1)
  final String? categoryId;

  /// 菜品名称
  @HiveField(2)
  final String? name;

  /// 价格（单位：元/斤）
  @HiveField(3)
  final num? price;

  /// 区域
  @HiveField(4)
  final String? region;

  /// 封面列表
  @HiveField(5)
  final List<String>? covers;

  /// 构造函数
  Dish({
    this.dishId,
    this.categoryId,
    this.name,
    this.price,
    this.region,
    this.covers,
  });

  /// 反序列化
  factory Dish.fromJson(Map<String, dynamic> json) => _$DishFromJson(json);

  /// 序列化
  Map<String, dynamic> toJson() => _$DishToJson(this);
}