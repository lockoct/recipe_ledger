import 'package:hive/hive.dart';

part 'recipe_ingredient.g.dart';

/// 菜谱配料数据模型
///
/// 表示菜谱中的一个配料项，包含菜品ID、用量和单位。
@HiveType(typeId: 102)
class RecipeIngredient {
  /// 配料唯一标识
  @HiveField(0)
  final String id;

  /// 菜品ID
  @HiveField(1)
  final String dishId;

  /// 用量
  @HiveField(2)
  final double amount;

  /// 单位（如：克、斤、公斤等）
  @HiveField(3)
  final String unit;

  /// 备注（可选）
  @HiveField(4)
  final String? notes;

  /// 构造函数
  const RecipeIngredient({
    required this.id,
    required this.dishId,
    required this.amount,
    required this.unit,
    this.notes,
  });

  /// 从JSON创建配料实例
  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeIngredient(
      id: json['id'] as String,
      dishId: json['dishId'] as String,
      amount: (json['amount'] as num).toDouble(),
      unit: json['unit'] as String,
      notes: json['notes'] as String?,
    );
  }

  /// 转换为JSON格式
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dishId': dishId,
      'amount': amount,
      'unit': unit,
      'notes': notes,
    };
  }

  /// 复制配料实例并更新指定字段
  RecipeIngredient copyWith({
    String? id,
    String? dishId,
    double? amount,
    String? unit,
    String? notes,
  }) {
    return RecipeIngredient(
      id: id ?? this.id,
      dishId: dishId ?? this.dishId,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      notes: notes ?? this.notes,
    );
  }

  @override
  String toString() {
    return 'RecipeIngredient(id: $id, dishId: $dishId, amount: $amount, unit: $unit, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RecipeIngredient &&
        other.id == id &&
        other.dishId == dishId &&
        other.amount == amount &&
        other.unit == unit &&
        other.notes == notes;
  }

  @override
  int get hashCode {
    return Object.hash(id, dishId, amount, unit, notes);
  }
}