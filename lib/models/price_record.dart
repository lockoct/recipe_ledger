import 'package:hive/hive.dart';

part 'price_record.g.dart';

/// 价格记录模型
///
/// 记录菜品价格的历史变化。
@HiveType(typeId: 104)
class PriceRecord {
  /// 记录唯一标识
  @HiveField(0)
  final String id;

  /// 关联的菜品ID
  @HiveField(1)
  final String dishId;

  /// 价格（单位：元/克）
  @HiveField(2)
  final double price;

  /// 记录日期
  @HiveField(3)
  final DateTime date;

  /// 构造函数
  const PriceRecord({
    required this.id,
    required this.dishId,
    required this.price,
    required this.date,
  });

  /// 从JSON创建价格记录实例
  factory PriceRecord.fromJson(Map<String, dynamic> json) {
    return PriceRecord(
      id: json['id'] as String,
      dishId: json['dishId'] as String,
      price: (json['price'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
    );
  }

  /// 转换为JSON格式
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dishId': dishId,
      'price': price,
      'date': date.toIso8601String(),
    };
  }

  /// 复制价格记录实例并更新指定字段
  PriceRecord copyWith({
    String? id,
    String? dishId,
    double? price,
    DateTime? date,
  }) {
    return PriceRecord(
      id: id ?? this.id,
      dishId: dishId ?? this.dishId,
      price: price ?? this.price,
      date: date ?? this.date,
    );
  }

  @override
  String toString() {
    return 'PriceRecord(id: $id, dishId: $dishId, price: $price, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PriceRecord &&
        other.id == id &&
        other.dishId == dishId &&
        other.price == price &&
        other.date == date;
  }

  @override
  int get hashCode {
    return Object.hash(id, dishId, price, date);
  }
}
