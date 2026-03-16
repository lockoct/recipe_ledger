import 'package:hive/hive.dart';
import 'recipe_ingredient.dart';

part 'recipe.g.dart';

/// 菜谱数据模型
///
/// 表示一个完整的菜谱，包含基本信息、配料列表和做法说明。
@HiveType(typeId: 101)
class Recipe {
  /// 菜谱唯一标识
  @HiveField(0)
  final String id;

  /// 菜谱名称
  @HiveField(1)
  final String name;

  /// 封面图片URL（可选）
  @HiveField(2)
  final String? coverImage;

  /// 配料列表
  @HiveField(3)
  final List<RecipeIngredient> ingredients;

  /// 做法说明（富文本内容）
  @HiveField(4)
  final String instructions;

  /// 创建时间
  @HiveField(5)
  final DateTime createTime;

  /// 更新时间
  @HiveField(6)
  final DateTime updateTime;

  /// 构造函数
  const Recipe({
    required this.id,
    required this.name,
    this.coverImage,
    required this.ingredients,
    required this.instructions,
    required this.createTime,
    required this.updateTime,
  });

  /// 从JSON创建菜谱实例
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as String,
      name: json['name'] as String,
      coverImage: json['coverImage'] as String?,
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((item) => RecipeIngredient.fromJson(item as Map<String, dynamic>))
          .toList(),
      instructions: json['instructions'] as String,
      createTime: DateTime.parse(json['createTime'] as String),
      updateTime: DateTime.parse(json['updateTime'] as String),
    );
  }

  /// 转换为JSON格式
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'coverImage': coverImage,
      'ingredients': ingredients.map((item) => item.toJson()).toList(),
      'instructions': instructions,
      'createTime': createTime.toIso8601String(),
      'updateTime': updateTime.toIso8601String(),
    };
  }

  /// 复制菜谱实例并更新指定字段
  Recipe copyWith({
    String? id,
    String? name,
    String? coverImage,
    List<RecipeIngredient>? ingredients,
    String? instructions,
    DateTime? createTime,
    DateTime? updateTime,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      coverImage: coverImage ?? this.coverImage,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      createTime: createTime ?? this.createTime,
      updateTime: updateTime ?? this.updateTime,
    );
  }

  @override
  String toString() {
    return 'Recipe(id: $id, name: $name, coverImage: $coverImage, ingredients: $ingredients, instructions: $instructions, createTime: $createTime, updateTime: $updateTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Recipe &&
        other.id == id &&
        other.name == name &&
        other.coverImage == coverImage &&
        other.ingredients == ingredients &&
        other.instructions == instructions &&
        other.createTime == createTime &&
        other.updateTime == updateTime;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      coverImage,
      ingredients,
      instructions,
      createTime,
      updateTime,
    );
  }
}