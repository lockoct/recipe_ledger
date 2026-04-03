import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_ledger/providers/app_provider.dart';
import 'package:recipe_ledger/utils/unit_converter.dart';
import 'package:recipe_ledger/constants/app_constants.dart';

/// 价格显示组件
///
/// 类似Vue管道的概念，将内部存储的元/克价格转换为用户选择的单位显示。
/// 自动监听用户设置变化，当单位更改时自动更新显示。
class PriceDisplay extends StatelessWidget {
  /// 内部存储的价格（元/克）
  final double pricePerGram;

  /// 自定义样式（可选）
  final TextStyle? style;

  /// 小数位数（默认2位）
  final int decimalPlaces;

  /// 是否显示单位（默认true）
  final bool showUnit;

  /// 是否使用紧凑格式（如：12.5 元/斤）
  final bool compact;

  /// 构造函数
  const PriceDisplay({
    super.key,
    required this.pricePerGram,
    this.style,
    this.decimalPlaces = 2,
    this.showUnit = true,
    this.compact = true,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final userSettings = appProvider.userSettings;
        final targetUnit = userSettings.priceUnit;

        // 转换价格
        final convertedPrice = UnitConverter.convertPrice(
          pricePerGram,
          targetUnit,
        );

        if (!showUnit) {
          return Text(
            convertedPrice.toStringAsFixed(decimalPlaces),
            style: style ?? Theme.of(context).textTheme.bodyMedium,
          );
        }

        final priceText = convertedPrice.toStringAsFixed(decimalPlaces);
        final unitText = compact
            ? UnitConverter.formatPrice(1.0, targetUnit, decimalPlaces: 0)
                .replaceFirst('1 ', '')
                .trim()
            : UnitConverter.formatPrice(convertedPrice, targetUnit, decimalPlaces: decimalPlaces)
                .replaceFirst('$priceText ', '')
                .trim();

        // 使用RichText分别设置价格和单位样式
        return RichText(
          text: TextSpan(
            children: [
              // 价格数字 - 使用原样式
              TextSpan(
                text: priceText,
                style: style ?? Theme.of(context).textTheme.bodyMedium,
              ),
              // 单位文字 - 缩小一点
              TextSpan(
                text: unitText,
                style: (style ?? Theme.of(context).textTheme.bodyMedium)?.copyWith(
                  fontSize: (style?.fontSize ?? Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14) * 0.7,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}

/// 价格显示带单位切换器
///
/// 显示价格并提供单位切换按钮
class PriceDisplayWithSelector extends StatefulWidget {
  /// 内部存储的价格（元/克）
  final double pricePerGram;

  /// 允许的单位列表（可选，默认使用所有可用单位）
  final List<String>? availableUnits;

  /// 构造函数
  const PriceDisplayWithSelector({
    Key? key,
    required this.pricePerGram,
    this.availableUnits,
  }) : super(key: key);

  @override
  State<PriceDisplayWithSelector> createState() =>
      _PriceDisplayWithSelectorState();
}

class _PriceDisplayWithSelectorState extends State<PriceDisplayWithSelector> {
  String _selectedUnit = PriceUnits.yuanPerGram;

  @override
  Widget build(BuildContext context) {
    final availableUnits = widget.availableUnits ?? PriceUnits.all;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 价格显示
        PriceDisplay(
          pricePerGram: widget.pricePerGram,
          showUnit: false,
        ),
        const SizedBox(width: 4),
        // 单位选择下拉框
        DropdownButton<String>(
          value: _selectedUnit,
          underline: const SizedBox(),
          iconSize: 16,
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedUnit = newValue;
              });
            }
          },
          items: availableUnits.map((String unit) {
            return DropdownMenuItem<String>(
              value: unit,
              child: Text(
                PriceUnits.getDisplayName(unit),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// 价格范围显示
///
/// 显示价格范围（最低价-最高价）
class PriceRangeDisplay extends StatelessWidget {
  /// 最低价格（元/克）
  final double minPricePerGram;

  /// 最高价格（元/克）
  final double maxPricePerGram;

  /// 分隔符（默认：' - '）
  final String separator;

  /// 构造函数
  const PriceRangeDisplay({
    Key? key,
    required this.minPricePerGram,
    required this.maxPricePerGram,
    this.separator = ' - ',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final userSettings = appProvider.userSettings;
        final targetUnit = userSettings.priceUnit;

        // 转换价格
        final minPrice = UnitConverter.convertPrice(minPricePerGram, targetUnit);
        final maxPrice = UnitConverter.convertPrice(maxPricePerGram, targetUnit);

        // 格式化显示
        final displayUnit = PriceUnits.getDisplayName(targetUnit);
        final formattedMin = minPrice.toStringAsFixed(2);
        final formattedMax = maxPrice.toStringAsFixed(2);

        return Text(
          '$formattedMin$separator$formattedMax $displayUnit',
          style: Theme.of(context).textTheme.bodyMedium,
        );
      },
    );
  }
}

/// 价格变化指示器
///
/// 显示价格变化（上涨/下跌）和百分比
class PriceChangeIndicator extends StatelessWidget {
  /// 当前价格（元/克）
  final double currentPricePerGram;

  /// 之前价格（元/克）
  final double previousPricePerGram;

  /// 是否显示百分比（默认true）
  final bool showPercentage;

  /// 构造函数
  const PriceChangeIndicator({
    Key? key,
    required this.currentPricePerGram,
    required this.previousPricePerGram,
    this.showPercentage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final change = currentPricePerGram - previousPricePerGram;
    final percentage = (change / previousPricePerGram) * 100;

    Color color;
    IconData icon;
    String changeText;

    if (change > 0) {
      color = Colors.red;
      icon = Icons.arrow_upward;
      changeText = '+${change.toStringAsFixed(2)}';
    } else if (change < 0) {
      color = Colors.green;
      icon = Icons.arrow_downward;
      changeText = change.toStringAsFixed(2);
    } else {
      color = Colors.grey;
      icon = Icons.remove;
      changeText = '0.00';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text(
          showPercentage
              ? '$changeText (${percentage.toStringAsFixed(1)}%)'
              : changeText,
          style: TextStyle(color: color),
        ),
      ],
    );
  }
}