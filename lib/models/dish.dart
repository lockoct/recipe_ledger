import 'package:hive/hive.dart';

part 'dish.g.dart';

/// 菜品数据模型
///
/// 表示一个菜品的基本信息，包括名称、价格、城市和更新时间。
/// 价格内部存储单位为元/克。
@HiveType(typeId: 100)
class Dish {
  /// 菜品唯一标识
  @HiveField(0)
  final String id;

  /// 菜品名称
  @HiveField(1)
  final String name;

  /// 菜品价格（单位：元/克）
  @HiveField(2)
  final double price;

  /// 所属城市
  @HiveField(3)
  final String city;

  /// 数据更新时间
  @HiveField(4)
  final DateTime updateTime;

  /// 构造函数
  const Dish({
    required this.id,
    required this.name,
    required this.price,
    required this.city,
    required this.updateTime,
  });

  /// 从JSON创建菜品实例
  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      city: json['city'] as String,
      updateTime: DateTime.parse(json['updateTime'] as String),
    );
  }

  /// 转换为JSON格式
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'city': city,
      'updateTime': updateTime.toIso8601String(),
    };
  }

  /// 复制菜品实例并更新指定字段
  Dish copyWith({
    String? id,
    String? name,
    double? price,
    String? city,
    DateTime? updateTime,
  }) {
    return Dish(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      city: city ?? this.city,
      updateTime: updateTime ?? this.updateTime,
    );
  }

  @override
  String toString() {
    return 'Dish(id: $id, name: $name, price: $price, city: $city, updateTime: $updateTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Dish &&
        other.id == id &&
        other.name == name &&
        other.price == price &&
        other.city == city &&
        other.updateTime == updateTime;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, price, city, updateTime);
  }
}