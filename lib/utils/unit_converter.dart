import 'package:recipe_ledger/constants/app_constants.dart';

/// 单位转换工具类
///
/// 提供菜品价格单位之间的转换功能。
/// 内部存储统一使用元/斤，显示时根据用户设置进行转换。
class UnitConverter {
  /// 将内部价格（元/斤）转换为目标单位的价格
  ///
  /// 参数：
  /// - `pricePerJin`: 内部存储的价格（元/斤）
  /// - `targetUnit`: 目标单位，如'元/斤', '元/公斤（千克）', '元/两'
  ///
  /// 返回：转换后的价格
  static double convertPrice(double pricePerJin, String targetUnit) {
    final factor = PriceUnits.getConversionFactor(targetUnit);
    return pricePerJin * factor;
  }

  /// 将目标单位的价格转换为内部存储价格（元/斤）
  ///
  /// 参数：
  /// - `price`: 目标单位的价格
  /// - `sourceUnit`: 源单位，如'元/斤', '元/公斤（千克）', '元/两'
  ///
  /// 返回：转换后的内部价格（元/斤）
  static double toInternalPrice(double price, String sourceUnit) {
    final factor = PriceUnits.getConversionFactor(sourceUnit);
    return price / factor;
  }

  /// 格式化价格显示
  ///
  /// 参数：
  /// - `price`: 价格
  /// - `unit`: 单位
  /// - `decimalPlaces`: 小数位数（默认2位）
  ///
  /// 返回：格式化后的价格字符串，如'12.50 元/斤'
  static String formatPrice(double price, String unit, {int decimalPlaces = 2}) {
    final formattedPrice = price.toStringAsFixed(decimalPlaces);
    final displayUnit = PriceUnits.getDisplayName(unit);
    return '$formattedPrice $displayUnit';
  }

  /// 格式化重量显示
  ///
  /// 参数：
  /// - `amount`: 重量值
  /// - `unit`: 单位
  /// - `decimalPlaces`: 小数位数（默认1位）
  ///
  /// 返回：格式化后的重量字符串，如'500.0 克'
  static String formatAmount(double amount, String unit, {int decimalPlaces = 1}) {
    final formattedAmount = amount.toStringAsFixed(decimalPlaces);
    return '$formattedAmount $unit';
  }

  /// 计算菜谱总成本
  ///
  /// 参数：
  /// - `ingredients`: 配料列表，每个配料包含菜品ID和用量
  /// - `dishPriceMap`: 菜品ID到价格的映射（价格应为元/斤）
  /// - `targetUnit`: 目标显示单位
  ///
  /// 返回：转换后的总成本
  static double calculateRecipeCost(
    List<Map<String, dynamic>> ingredients,
    Map<String, double> dishPriceMap,
    String targetUnit,
  ) {
    double totalCostInJin = 0.0;

    for (final ingredient in ingredients) {
      final dishId = ingredient['dishId'] as String;
      final amount = (ingredient['amount'] as num).toDouble();
      final unit = ingredient['unit'] as String;

      // 获取菜品价格（元/斤）
      final dishPrice = dishPriceMap[dishId] ?? 0.0;

      // 将用量转换为斤
      final amountInJin = _convertToJin(amount, unit);

      // 累加成本
      totalCostInJin += dishPrice * amountInJin;
    }

    // 转换为目标单位
    return convertPrice(totalCostInJin, targetUnit);
  }

  /// 将重量转换为斤
  static double _convertToJin(double amount, String unit) {
    switch (unit) {
      case 'g':
      case '克':
        return amount / 500.0;
      case '斤':
        return amount;
      case 'kg':
      case '公斤':
        return amount * 2.0;
      default:
        // 尝试解析单位
        if (unit.contains('克')) {
          return amount / 500.0;
        } else if (unit.contains('斤')) {
          return amount;
        } else if (unit.contains('公斤') || unit.contains('kg')) {
          return amount * 2.0;
        }
        return amount / 500.0; // 默认为克，转换为斤
    }
  }

  /// 获取单位之间的转换系数
  static double getUnitConversionFactor(String fromUnit, String toUnit) {
    final fromFactor = PriceUnits.getConversionFactor(fromUnit);
    final toFactor = PriceUnits.getConversionFactor(toUnit);
    return fromFactor / toFactor;
  }
}