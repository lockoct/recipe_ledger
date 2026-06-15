import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:recipe_ledger/providers/app_provider.dart";
import "package:recipe_ledger/providers/dish_provider.dart";

/// 菜品页面专用搜索栏
class DishSearchBar extends StatefulWidget {
  /// 搜索框提示文本
  final String hintText;

  /// 搜索控制器（外部传入）
  final TextEditingController searchController;

  /// 搜索回调
  final VoidCallback? onSearch;

  /// 构造函数
  const DishSearchBar({
    super.key,
    this.hintText = "搜索菜品名称...",
    required this.searchController,
    this.onSearch,
  });

  @override
  State<DishSearchBar> createState() => _DishSearchBarState();
}

class _DishSearchBarState extends State<DishSearchBar> {
  final bool _showCategoryFilter = false;

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final dishProvider = Provider.of<DishProvider>(context);
    final currentCity = appProvider.currentCity;

    return Column(
      children: [
        // 第一行：城市 + 搜索框（移除筛选按钮）
        Container(
          color: Theme.of(context).primaryColor, // 主题色背景
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // 左侧：当前城市显示
              _buildCitySection(context, currentCity),
              const SizedBox(width: 16),
              // 中间：搜索框（圆弧设计）
              Expanded(child: _buildSearchBox(context, dishProvider)),
            ],
          ),
        ),
        // 第二行：分类筛选展示（仅在应用筛选时显示）
        if (_showCategoryFilter || dishProvider.queryForm.region != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _buildCategoryFilter(context, dishProvider),
          ),
        ],
      ],
    );
  }

  /// 构建城市显示区域
  Widget _buildCitySection(BuildContext context, String currentCity) {
    return GestureDetector(
      onTap: () {
        // TODO: 实现城市切换功能
        _showCitySelectionDialog(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_on, size: 18, color: Colors.white),
              const SizedBox(width: 2),
              Text(
                currentCity,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建搜索框（圆弧设计）
  Widget _buildSearchBox(BuildContext context, DishProvider dishProvider) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        // 背景容器（固定高度，提供圆角白色背景）
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white, // 搜索框白色背景
            borderRadius: BorderRadius.circular(20), // 圆弧设计
          ),
        ),
        // 输入框和按钮内容（不受固定高度限制，保持自动居中）
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Icon(Icons.search, size: 20, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: widget.searchController,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: widget.hintText,
                    border: InputBorder.none,
                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                  onChanged: (value) {
                    dishProvider.setName(value);
                    widget.onSearch?.call();
                  },
                ),
              ),
              // 清除按钮
              if (widget.searchController.text.isNotEmpty)
                InkWell(
                  onTap: () {
                    widget.searchController.clear();
                    dishProvider.setName("");
                    widget.onSearch?.call();
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    child: const Icon(Icons.clear, size: 20, color: Colors.grey),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// 构建分类筛选展示
  Widget _buildCategoryFilter(BuildContext context, DishProvider dishProvider) {
    final List<Widget> filters = [];

    if (dishProvider.queryForm.region != null) {
      filters.add(
        _buildCategoryTag(
          context,
          label: "区域: ${dishProvider.queryForm.region}",
          onRemove: () {
            dishProvider.setRegion(null);
          },
        ),
      );
    }

    return Wrap(spacing: 8, runSpacing: 8, children: filters);
  }

  /// 构建分类标签
  Widget _buildCategoryTag(
    BuildContext context, {
    required String label,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 16),
          ),
        ],
      ),
    );
  }

  void _showCitySelectionDialog(BuildContext context) {
    // TODO: 实现城市选择对话框
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("选择城市"),
        content: const Text("城市选择功能开发中..."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("确定"),
          ),
        ],
      ),
    );
  }
}