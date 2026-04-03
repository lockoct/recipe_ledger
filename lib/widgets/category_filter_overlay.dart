import 'package:flutter/material.dart';
import 'package:recipe_ledger/constants/app_constants.dart';

/// 分类筛选展开覆盖层
///
/// 当分类筛选栏展开时显示，包含：
/// 1. 遮罩层（点击可收起）
/// 2. 分类网格（一行3个）
/// 3. 收起按钮
class CategoryFilterOverlay extends StatelessWidget {
  /// 当前选中的分类
  final String? selectedCategory;

  /// 分类选择回调
  final Function(String?)? onCategorySelected;

  /// 收起回调
  final VoidCallback onExpandToggle;

  const CategoryFilterOverlay({
    super.key,
    this.selectedCategory,
    this.onCategorySelected,
    required this.onExpandToggle,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final maxGridHeight = screenHeight * 0.6;

    return Stack(
      children: [
        // 遮罩层 - 只覆盖菜品列表区域（从搜索栏下方开始）
        Positioned(
          top: 64,
          left: 0,
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: onExpandToggle,
            child: Container(
              color: const Color.fromRGBO(0, 0, 0, 0.4),
            ),
          ),
        ),
        // 分类网格内容 - 从搜索栏下方展开
        Positioned(
          top: 64,
          left: 0,
          right: 0,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: maxGridHeight,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 4.0,
                    ),
                    itemCount: DishCategories.all.length + 1,
                    itemBuilder: (context, index) {
                      final category = index == 0
                          ? DishCategories.allCategories
                          : DishCategories.all[index - 1];
                      final isSelected = selectedCategory == category ||
                          (selectedCategory == null && category == DishCategories.allCategories);

                      return _buildGridCategoryItem(
                        context,
                        category: category,
                        isSelected: isSelected,
                        onTap: () {
                          final selected = category == DishCategories.allCategories ? null : category;
                          onCategorySelected?.call(selected);
                          onExpandToggle();
                        },
                      );
                    },
                  ),
                  // 分隔线
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFEEEEEE),
                  ),
                  // 收起按钮
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: GestureDetector(
                      onTap: onExpandToggle,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.keyboard_arrow_up,
                            color: Theme.of(context).primaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '点击收起',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGridCategoryItem(
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
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withAlpha(20)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: primaryColor, width: 1)
              : Border.all(color: Colors.grey.shade300, width: 0.5),
        ),
        child: Center(
          child: Text(
            category,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isSelected ? primaryColor : Colors.grey.shade700,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
