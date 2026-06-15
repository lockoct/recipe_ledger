import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:provider/provider.dart";
import "package:recipe_ledger/providers/dish_provider.dart";
import "package:recipe_ledger/models/dish_list_item.dart";
import "package:recipe_ledger/models/pagination.dart";
import "package:recipe_ledger/widgets/price_display.dart";
import "package:recipe_ledger/widgets/dish_search_bar.dart";
import "package:recipe_ledger/widgets/category_filter_bar.dart";
import "package:recipe_ledger/widgets/category_filter_overlay.dart";
import "package:recipe_ledger/pages/dish/dish_detail_page.dart";

/// 菜品列表页面
class DishListPage extends StatefulWidget {
  const DishListPage({super.key});

  @override
  State<DishListPage> createState() => _DishListPageState();
}

class _DishListPageState extends State<DishListPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isCategoryExpanded = false;
  Future<ResponsePagination<DishListItem>>? _dishListFuture;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// 加载数据
  void _getList() {
    setState(() {
      _dishListFuture = Provider.of<DishProvider>(context, listen: false).getList(refresh: true);
    });
  }

  /// 切换分类筛选栏的展开状态
  void _toggleCategoryExpanded() {
    setState(() {
      _isCategoryExpanded = !_isCategoryExpanded;
    });
  }

  @override
  void initState() {
    super.initState();
    _dishListFuture = Provider.of<DishProvider>(context, listen: false).getList(refresh: true);
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
                      hintText: "搜索菜品名称...",
                      searchController: _searchController,
                      onSearch: _getList,
                    ),
                    // 分类筛选栏（始终显示，展开时被覆盖层遮住）
                    CategoryFilterBar(
                      selectedCategory: provider.queryForm.categoryId,
                      onCategorySelected: (category) {
                        provider.setCategory(category);
                        _getList();
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
                    selectedCategory: provider.queryForm.categoryId,
                    onCategorySelected: (category) {
                      provider.setCategory(category);
                      _getList();
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

  /// 构建内容区域
  Widget _buildContent(DishProvider provider) {
    return FutureBuilder<ResponsePagination<DishListItem>>(
      future: _dishListFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("加载失败: ${snapshot.error}"),
                ElevatedButton(
                  onPressed: _getList,
                  child: const Text("重新加载"),
                ),
              ],
            ),
          );
        }

        if (provider.dishes.isEmpty) {
          return const Center(child: Text("暂无菜品数据"));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: provider.dishes.length + (provider.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            // 如果有更多数据，最后一项用于显示加载更多动画
            if (index == provider.dishes.length) {
              provider.getMore();
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  // 加载更多的动画
                  child: CircularProgressIndicator(),
                ),
              );
            }
            final dish = provider.dishes[index];
            return _buildDishCard(context, dish);
          },
        );
      },
    );
  }

  /// 构建菜品卡片
  Widget _buildDishCard(BuildContext context, DishListItem dish) {
    final nameStyle = Theme.of(context).textTheme.bodyLarge ?? const TextStyle();
    final priceStyle = nameStyle.copyWith(color: Colors.red);
    final changeStyle = Theme.of(context).textTheme.bodySmall ?? const TextStyle();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DishDetailPage(dishId: dish.dishId),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // 名称顶部，价格底部
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
                        pricePerJin: dish.price,
                        compact: true,
                        style: priceStyle,
                      ),
                    ],
                  ),
                ),

                // 右侧：价格变化
                // 竖线
                Container(
                  width: 1.5,
                  margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                  color: Colors.grey.shade200,
                ),
                // 价格变化
                Container(
                  margin: const EdgeInsets.only(right: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildPriceChange("较昨日", dish.dailyChange ?? 0.0, changeStyle),
                      _buildPriceChange("较上月", dish.monthlyChange ?? 0.0, changeStyle),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建价格变化
  Widget _buildPriceChange(String label, double change, TextStyle style) {
    final isPositive = change >= 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: style),
        const SizedBox(width: 2),
        Icon(
          isPositive ? Icons.trending_up : Icons.trending_down,
          color: isPositive ? Colors.red : Colors.green,
          size: 14,
        ),
        const SizedBox(width: 2),
        Text(
          "${change.abs().toStringAsFixed(2)}元",
          style: style.copyWith(
            color: isPositive ? Colors.red : Colors.green,
          ),
        ),
      ],
    );
  }
}