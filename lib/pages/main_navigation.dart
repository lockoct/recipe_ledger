import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:recipe_ledger/providers/navigation_provider.dart';
import 'package:recipe_ledger/pages/dish/dish_list_page.dart';
import 'package:recipe_ledger/pages/recipe/recipe_grid_page.dart';
import 'package:recipe_ledger/pages/profile/profile_page.dart';

/// 主导航容器 - 底部导航管理三个标签页
///
/// 使用BottomNavigationBar + IndexedStack实现标签切换，
/// 支持保持页面状态（使用AutomaticKeepAliveClientMixin）。
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final List<Widget> _pages = [
    const DishListPage(), // 菜品页 - 暂时使用现有列表页，后续替换为网格页
    const RecipeGridPage(), // 菜谱页 - 网格布局
    const ProfilePage(), // 我的页面
  ];

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);

    return Scaffold(
      body: IndexedStack(
        index: navigationProvider.currentTabIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationProvider.currentTabIndex,
        onTap: (index) {
          navigationProvider.setCurrentTabIndex(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: '菜品',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: '菜谱',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '我的',
          ),
        ],
        type: BottomNavigationBarType.fixed, // 固定样式，避免标签动画
      ),
    );
  }
}