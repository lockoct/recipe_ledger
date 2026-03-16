import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:recipe_ledger/providers/app_provider.dart';
import 'package:recipe_ledger/providers/dish_provider.dart';

/// 菜品页面专用搜索栏
///
/// 包含城市显示、搜索输入和筛选功能。
/// 设计特点：
/// - 左侧：定位图标 + 当前城市（可点击切换）
/// - 中间：圆弧搜索框（高度适中）
/// - 右侧：筛选按钮
/// - 下方：筛选条件展示区域
class DishSearchBar extends StatefulWidget {
  /// 搜索框提示文本
  final String hintText;

  /// 搜索控制器（外部传入）
  final TextEditingController searchController;

  /// 构造函数
  const DishSearchBar({
    super.key,
    this.hintText = '搜索菜品名称...',
    required this.searchController,
  });

  @override
  State<DishSearchBar> createState() => _DishSearchBarState();
}

class _DishSearchBarState extends State<DishSearchBar> {
  final bool _showFilterOptions = false;

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

        // 第二行：筛选条件展示（仅在应用筛选时显示）
        if (_showFilterOptions || dishProvider.selectedCity != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _buildFilterOptions(context, dishProvider),
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
              SizedBox(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    currentCity,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
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
                    dishProvider.setSearchQuery(value);
                  },
                ),
              ),
              // 清除按钮
              if (widget.searchController.text.isNotEmpty)
                InkWell(
                  onTap: () {
                    widget.searchController.clear();
                    dishProvider.setSearchQuery('');
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

  /// 构建筛选条件展示
  Widget _buildFilterOptions(BuildContext context, DishProvider dishProvider) {
    final List<Widget> filters = [];

    // 城市筛选
    if (dishProvider.selectedCity != null) {
      filters.add(
        _buildFilterChip(
          context,
          label: '城市: ${dishProvider.selectedCity}',
          onRemove: () {
            dishProvider.setSelectedCity(null);
          },
        ),
      );
    }

    // 排序方式（作为筛选条件展示）
    final sortText = _getSortText(dishProvider.sortType);
    filters.add(
      _buildFilterChip(
        context,
        label: '排序: $sortText',
        onRemove: () {
          dishProvider.setSortType(DishSortType.nameAsc);
        },
      ),
    );

    return Wrap(spacing: 8, runSpacing: 8, children: filters);
  }

  /// 构建筛选标签
  Widget _buildFilterChip(
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

  /// 获取排序方式文本
  String _getSortText(DishSortType sortType) {
    switch (sortType) {
      case DishSortType.nameAsc:
        return '名称 A-Z';
      case DishSortType.nameDesc:
        return '名称 Z-A';
      case DishSortType.priceAsc:
        return '价格升序';
      case DishSortType.priceDesc:
        return '价格降序';
      case DishSortType.updateTimeDesc:
        return '最新优先';
      case DishSortType.updateTimeAsc:
        return '最早优先';
    }
  }

  /// 显示城市选择对话框
  void _showCitySelectionDialog(BuildContext context) {
    // TODO: 实现城市选择对话框
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择城市'),
        content: const Text('城市选择功能开发中...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 显示筛选对话框
  void _showFilterDialog(BuildContext context, DishProvider dishProvider) {
    final currentCity = dishProvider.selectedCity;
    final availableCities = dishProvider.availableCities;

    showDialog(
      context: context,
      builder: (context) {
        String? selectedCity = currentCity;

        return AlertDialog(
          title: const Text('筛选菜品'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 城市筛选
                const Text(
                  '按城市筛选:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    // 不限选项
                    ChoiceChip(
                      label: const Text('不限'),
                      selected: selectedCity == null,
                      onSelected: (selected) {
                        if (selected) {
                          selectedCity = null;
                        }
                      },
                    ),
                    // 城市选项
                    ...availableCities.map((city) {
                      return ChoiceChip(
                        label: Text(city),
                        selected: selectedCity == city,
                        onSelected: (selected) {
                          if (selected) {
                            selectedCity = city;
                          }
                        },
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 16),

                // 排序选项
                const Text(
                  '排序方式:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<DishSortType>(
                  initialValue: dishProvider.sortType,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items: DishSortType.values.map((sortType) {
                    return DropdownMenuItem<DishSortType>(
                      value: sortType,
                      child: Text(_getSortText(sortType)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      dishProvider.setSortType(value);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                dishProvider.setSelectedCity(selectedCity);
                Navigator.pop(context);
              },
              child: const Text('应用筛选'),
            ),
          ],
        );
      },
    );
  }
}
