import 'package:hive/hive.dart';

part 'user_settings.g.dart';

/// 用户设置数据模型
///
/// 存储用户的个性化设置，包括价格单位、当前城市和自动同步设置。
@HiveType(typeId: 103)
class UserSettings {
  /// 价格显示单位
  ///
  /// 可选值：元/g, 元/斤, 元/kg, 元/公斤
  @HiveField(0)
  final String priceUnit;

  /// 当前选择的城市
  @HiveField(1)
  final String currentCity;

  /// 是否自动同步数据
  @HiveField(2)
  final bool autoSync;

  /// 构造函数
  const UserSettings({
    required this.priceUnit,
    required this.currentCity,
    required this.autoSync,
  });

  /// 默认用户设置
  factory UserSettings.defaultSettings() {
    return const UserSettings(
      priceUnit: '元/g',
      currentCity: '广州市',
      autoSync: true,
    );
  }

  /// 从JSON创建用户设置实例
  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      priceUnit: json['priceUnit'] as String,
      currentCity: json['currentCity'] as String,
      autoSync: json['autoSync'] as bool,
    );
  }

  /// 转换为JSON格式
  Map<String, dynamic> toJson() {
    return {
      'priceUnit': priceUnit,
      'currentCity': currentCity,
      'autoSync': autoSync,
    };
  }

  /// 复制用户设置实例并更新指定字段
  UserSettings copyWith({
    String? priceUnit,
    String? currentCity,
    bool? autoSync,
  }) {
    return UserSettings(
      priceUnit: priceUnit ?? this.priceUnit,
      currentCity: currentCity ?? this.currentCity,
      autoSync: autoSync ?? this.autoSync,
    );
  }

  @override
  String toString() {
    return 'UserSettings(priceUnit: $priceUnit, currentCity: $currentCity, autoSync: $autoSync)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserSettings &&
        other.priceUnit == priceUnit &&
        other.currentCity == currentCity &&
        other.autoSync == autoSync;
  }

  @override
  int get hashCode {
    return Object.hash(priceUnit, currentCity, autoSync);
  }
}