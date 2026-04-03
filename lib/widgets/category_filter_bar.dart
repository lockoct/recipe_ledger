import 'package:flutter/material.dart';

import 'package:recipe_ledger/constants/app_constants.dart';

/// 菜品分类筛选栏
///
/// 特性：
/// 1. 默认显示横向滑动的分类列表
/// 2. 右侧有展开按钮，点击后显示全部分类网格
/// 3. 展开时显示遮罩，分类网格浮在内容上方
/// 4. 网格布局：一行3个分类
/// 5. 底部有收起按钮
class CategoryFilterBar extends StatefulWidget {
  /// 当前选中的分类
  final String? selectedCategory;

  /// 分类选择回调
  final Function(String?)? onCategorySelected;

  /// 展开/收起状态切换回调
  final VoidCallback? onExpandToggle;

  /// 构造函数
  const CategoryFilterBar({
    super.key,
    this.selectedCategory,
    this.onCategorySelected,
    this.onExpandToggle,
  });

  @override
  State<CategoryFilterBar> createState() => _CategoryFilterBarState();
}

class _CategoryFilterBarState extends State<CategoryFilterBar> {
  @override
  void initState() {
    super.initState();
  }

  String? get _effectiveSelectedCategory => widget.selectedCategory;

  @override
  Widget build(BuildContext context) {
    return _buildHorizontalCategoryList();
  }

  /// 构建横向滑动分类列表
  Widget _buildHorizontalCategoryList() {
    return Container(
      color: Colors.white,
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 横向滑动分类列表
          Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 5, 0, 5),
                itemCount: DishCategories.all.length + 1, // +1 为"全部"
                itemBuilder: (context, index) {
                  final category = index == 0
                      ? DishCategories.allCategories
                      : DishCategories.all[index - 1];
                  final isSelected = _effectiveSelectedCategory == category ||
                      (_effectiveSelectedCategory == null && category == DishCategories.allCategories);

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildCategoryChip(
                      context,
                      category: category,
                      isSelected: isSelected,
                      onTap: () => _handleCategoryTap(category),
                    ),
                  );
                },
              ),
            ),
          // 展开按钮
          _buildExpandButton(context),
        ],
      ),
    );
  }

  /// 构建分类标签
  Widget _buildCategoryChip(
    BuildContext context, {
    required String category,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withAlpha(20) // 选中状态：轻微主题色背景
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: primaryColor, width: 1)
              : null,
        ),
        child: Center(
          child: Text(
            category,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isSelected ? primaryColor : Colors.grey.shade700,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 13,
            ),
            softWrap: false,
            overflow: TextOverflow.clip,
          ),
        ),
      ),
    );
  }

  /// 构建展开按钮
  Widget _buildExpandButton(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return GestureDetector(
      onTap: _toggleExpanded,
      child: Container(
        width: 40,
        color: Colors.white,
        child: Center(
          child: Icon(
            Icons.keyboard_arrow_right,
            color: primaryColor,
            size: 20,
          ),
        ),
      ),
    );
  }


  /// 切换展开/收起状态
  void _toggleExpanded() {
    widget.onExpandToggle?.call();
  }

  /// 处理分类点击
  void _handleCategoryTap(String category) {
    final newSelectedCategory = category == DishCategories.allCategories ? null : category;

    if (widget.selectedCategory == newSelectedCategory) {
      return;
    }

    widget.onCategorySelected?.call(newSelectedCategory);
  }
}