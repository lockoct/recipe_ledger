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
class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  static const _pages = [
    DishListPage(),
    RecipeGridPage(),
    ProfilePage(),
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
        onTap: navigationProvider.setCurrentTabIndex,
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
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}