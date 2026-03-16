import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:recipe_ledger/models/recipe.dart';
import 'package:recipe_ledger/providers/recipe_provider.dart';

/// 菜谱网格页面
///
/// 显示菜谱的网格布局，类似菜品页但针对菜谱特性优化。
/// 包含顶部搜索栏、菜谱网格和添加按钮。
class RecipeGridPage extends StatefulWidget {
  const RecipeGridPage({super.key});

  @override
  State<RecipeGridPage> createState() => _RecipeGridPageState();
}

class _RecipeGridPageState extends State<RecipeGridPage> {
  final TextEditingController _searchController = TextEditingController();
  late RecipeProvider _recipeProvider;

  @override
  void initState() {
    super.initState();
    _recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFFF6F6F6),
          elevation: 0,
          toolbarHeight: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: primaryColor,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
          ),
        ),
        body: Column(
          children: [
            // 搜索栏
            _buildSearchBar(context),
            // 菜谱网格
            Expanded(
              child: _buildRecipeGrid(context),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addNewRecipe,
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  /// 构建搜索栏
  Widget _buildSearchBar(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor, // 主题色背景
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Stack(
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
          Row(
              children: [
                const SizedBox(width: 16), // 左边距
                const Icon(Icons.search, size: 20, color: Colors.grey),
                const SizedBox(width: 8), // 图标与输入框间距
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 6), // 垂直填充调整高度
                      hintText: '搜索菜谱名称...',
                      border: InputBorder.none,
                      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                    onChanged: _onSearchChanged,
                  ),
                ),
                // 清除按钮
                if (_searchController.text.isNotEmpty)
                  InkWell(
                    onTap: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      child: const Icon(Icons.clear, size: 20, color: Colors.grey),
                    ),
                  ),
                const SizedBox(width: 8), // 右边距
              ],
            ),
        ],
      ),
    );
  }

  /// 构建菜谱网格
  Widget _buildRecipeGrid(BuildContext context) {
    return Consumer<RecipeProvider>(
      builder: (context, recipeProvider, child) {
        final filteredRecipes = recipeProvider.filteredRecipes;
        final isLoading = recipeProvider.isLoading;
        final errorMessage = recipeProvider.errorMessage;

        // 显示加载状态
        if (isLoading && filteredRecipes.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('加载中...'),
              ],
            ),
          );
        }

        // 显示错误信息
        if (errorMessage != null && filteredRecipes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('加载失败: $errorMessage'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => recipeProvider.loadRecipes(),
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        }

        // 显示空状态
        if (filteredRecipes.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.menu_book, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('暂无菜谱数据'),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2列网格
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8, // 高度稍大于宽度
          ),
          itemCount: filteredRecipes.length,
          itemBuilder: (context, index) {
            final recipe = filteredRecipes[index];
            return _buildRecipeCard(context, recipe);
          },
        );
      },
    );
  }

  /// 构建菜谱卡片
  Widget _buildRecipeCard(BuildContext context, Recipe recipe) {
    return GestureDetector(
      onTap: () => _viewRecipeDetail(recipe),
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 封面图片区域
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: recipe.coverImage != null
                  ? Image.network(
                      recipe.coverImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    )
                  : const Icon(
                      Icons.menu_book,
                      size: 48,
                      color: Colors.blue,
                    ),
            ),
            // 菜谱信息
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '配料: ${recipe.ingredients.length} 种',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '更新: ${_formatDate(recipe.updateTime)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 格式化日期
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return '今天';
    } else if (difference.inDays == 1) {
      return '昨天';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${date.month}/${date.day}';
    }
  }

  /// 搜索输入变化处理
  void _onSearchChanged(String value) {
    _recipeProvider.setSearchQuery(value);
  }

  /// 查看菜谱详情
  void _viewRecipeDetail(Recipe recipe) {
    // TODO: 实现菜谱详情页面
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('查看菜谱: ${recipe.name} (开发中)'),
      ),
    );
  }

  /// 添加新菜谱
  void _addNewRecipe() {
    // TODO: 实现添加菜谱页面
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('添加菜谱功能开发中...'),
      ),
    );
  }
}