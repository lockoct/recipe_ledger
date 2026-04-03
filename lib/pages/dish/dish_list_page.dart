import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:recipe_ledger/providers/dish_provider.dart';
import 'package:recipe_ledger/models/dish.dart';
import 'package:recipe_ledger/widgets/price_display.dart';
import 'package:recipe_ledger/widgets/dish_search_bar.dart';
import 'package:recipe_ledger/widgets/category_filter_bar.dart';
import 'package:recipe_ledger/widgets/category_filter_overlay.dart';
import 'package:recipe_ledger/pages/dish/dish_detail_page.dart';

/// 菜品列表页面
class DishListPage extends StatefulWidget {
  const DishListPage({super.key});

  @override
  State<DishListPage> createState() => _DishListPageState();
}

class _DishListPageState extends State<DishListPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isCategoryExpanded = false;

  @override
  void initState() {
    super.initState();
    // 监听搜索输入变化
    _searchController.addListener(_onSearchChanged);
  }

  /// 切换分类筛选栏的展开状态
  void _toggleCategoryExpanded() {
    setState(() {
      _isCategoryExpanded = !_isCategoryExpanded;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final provider = Provider.of<DishProvider>(context, listen: false);
    provider.setSearchQuery(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: primaryColor, // 状态栏颜色匹配搜索栏背景
        statusBarIconBrightness: Brightness.light, // 状态栏图标亮度（浅色背景用深色图标）
        statusBarBrightness: Brightness.light, // 状态栏亮度
        systemNavigationBarColor: Colors.white, // 导航栏颜色保持白色
        systemNavigationBarIconBrightness: Brightness.dark, // 导航栏图标亮度
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F6F6),
        appBar: AppBar(
          automaticallyImplyLeading: false, // 不显示返回按钮
          backgroundColor: const Color(0xFFF6F6F6),
          toolbarHeight: 0, // 将AppBar高度设为0，完全隐藏
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: primaryColor,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
          ),
        ),
        body: Consumer<DishProvider>(
          builder: (context, provider, child) {
            return Stack(
              children: [
                // 主内容区域
                Column(
                  children: [
                    // 搜索栏组件（始终显示）
                    DishSearchBar(
                      hintText: '搜索菜品名称...',
                      searchController: _searchController,
                    ),
                    // 分类筛选栏（始终显示，展开时被覆盖层遮住）
                    CategoryFilterBar(
                      selectedCategory: provider.selectedCategory,
                      onCategorySelected: (category) {
                        provider.setSelectedCategory(category);
                      },
                      onExpandToggle: _toggleCategoryExpanded,
                    ),
                    // 内容区域
                    Expanded(
                      child: _buildContent(provider),
                    ),
                  ],
                ),
                // 分类筛选栏的展开状态会作为覆盖层显示在菜品列表上方
                if (_isCategoryExpanded)
                  CategoryFilterOverlay(
                    selectedCategory: provider.selectedCategory,
                    onCategorySelected: (category) {
                      provider.setSelectedCategory(category);
                    },
                    onExpandToggle: _toggleCategoryExpanded,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// 构建菜品卡片
  Widget _buildDishCard(BuildContext context, Dish dish) {
    final nameStyle = Theme.of(context).textTheme.bodyLarge ?? const TextStyle();
    final priceStyle = nameStyle.copyWith(color: Colors.red);
    final changeStyle = Theme.of(context).textTheme.bodySmall ?? const TextStyle();

    // 模拟同环比数据
    const dailyChange = 0.03; // 较昨日变化
    const monthlyChange = -1.00; // 较上月变化

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DishDetailPage(dishId: dish.id),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        elevation: 0,
        margin: const EdgeInsets.only(top: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch, // 拉伸子组件填满高度
              children: [
                // 左侧：菜品图标（圆角正方形，高度贴合列表项）
                Container(
                  width: 70,
                  height: 70,
                  margin: const EdgeInsets.only(right: 12), // 占位图与文本间距
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(8), // 圆角正方形
                  ),
                  child: const Icon(
                    Icons.restaurant,
                    color: Colors.blue,
                    size: 24,
                  ),
                ),
                // 中间：菜品名称和价格（上下排列）
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // 左对齐
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, // 名称顶部，价格底部
                    children: [
                      // 菜品名称（顶部）
                      Text(
                        dish.name,
                        style: nameStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // 价格（底部，左对齐图标）
                      PriceDisplay(
                        pricePerGram: dish.price,
                        compact: true,
                        style: priceStyle,
                      ),
                    ],
                  ),
                ),
                // 右侧：同环比显示
                Container(
                  width: 1.5,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  color: Colors.grey.shade200,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: SizedBox(
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // 较昨日
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('较昨日', style: changeStyle),
                            const SizedBox(width: 2),
                            dailyChange >= 0
                                ? const Icon(Icons.trending_up, color: Colors.red, size: 14)
                                : const Icon(Icons.trending_down, color: Colors.green, size: 14),
                            const SizedBox(width: 2),
                            Text(
                              '${dailyChange.abs().toStringAsFixed(2)}元',
                              style: changeStyle.copyWith(
                                color: dailyChange >= 0 ? Colors.red : Colors.green,
                              ),
                            ),
                          ],
                        ),
                        // 较上月
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('较上月', style: changeStyle),
                            const SizedBox(width: 2),
                            monthlyChange >= 0
                                ? const Icon(Icons.trending_up, color: Colors.red, size: 14)
                                : const Icon(Icons.trending_down, color: Colors.green, size: 14),
                            const SizedBox(width: 2),
                            Text(
                              '${monthlyChange.abs().toStringAsFixed(2)}元',
                              style: changeStyle.copyWith(
                                color: monthlyChange >= 0 ? Colors.red : Colors.green,
                              ),
                            ),
                          ],
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
    );
  }

  /// 构建内容区域
  Widget _buildContent(DishProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              provider.errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refreshData,
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    if (provider.filteredDishes.isEmpty) {
      return const Center(child: Text('暂无菜品数据'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemCount: provider.filteredDishes.length,
      itemBuilder: (context, index) {
        final dish = provider.filteredDishes[index];
        return _buildDishCard(context, dish);
      },
    );
  }

  /// 刷新数据
  void _refreshData() {
    final provider = Provider.of<DishProvider>(context, listen: false);
    provider.loadDishes();
  }
}
