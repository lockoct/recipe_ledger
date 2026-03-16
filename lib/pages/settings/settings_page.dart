import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:recipe_ledger/providers/app_provider.dart';
import 'package:recipe_ledger/constants/app_constants.dart';

/// 单位设置页面
///
/// 用于切换价格显示单位的页面，提供简单的单选列表。
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final currentUnit = appProvider.userSettings.priceUnit;

    return Scaffold(
      appBar: AppBar(
        title: const Text('单位切换'),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).primaryColor,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
      ),
      backgroundColor: const Color(0xFFF6F6F6),
      body: Column(
        children: [
          for (int i = 0; i < PriceUnits.all.length; i++)
            _buildUnitOption(
              context,
              unit: PriceUnits.all[i],
              isSelected: PriceUnits.all[i] == currentUnit,
              isLast: i == PriceUnits.all.length - 1,
              onTap: () => _updateUnit(context, PriceUnits.all[i], appProvider),
            ),
        ],
      ),
    );
  }

  /// 构建单位选项
  Widget _buildUnitOption(
    BuildContext context, {
    required String unit,
    required bool isSelected,
    required bool isLast,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          tileColor: Colors.white,
          title: Text(
            PriceUnits.getDisplayName(unit),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          trailing: Icon(
            isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
          ),
          onTap: onTap,
        ),
        if (!isLast)
          Divider(
            height: 0,
            color: Colors.grey.shade300, // 更淡的分割线颜色
            thickness: 0.5,
            indent: 16, // 左边距
            endIndent: 16, // 右边距
          ),
      ],
    );
  }

  /// 更新价格单位
  Future<void> _updateUnit(BuildContext context, String newUnit, AppProvider appProvider) async {
    if (newUnit == appProvider.userSettings.priceUnit) {
      return; // 已选中当前单位，不执行操作
    }

    // 在异步操作前获取需要的对象
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final errorColor = Theme.of(context).colorScheme.error;

    try {
      // 更新单位
      await appProvider.updatePriceUnit(newUnit);

      // 显示成功消息
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('价格单位已切换为 ${PriceUnits.getDisplayName(newUnit)}'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error) {
      // 显示错误消息
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('切换单位失败: $error'),
          backgroundColor: errorColor,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}