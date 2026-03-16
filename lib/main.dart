import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:recipe_ledger/utils/hive_init.dart';
import 'package:recipe_ledger/providers/app_provider.dart';
import 'package:recipe_ledger/providers/dish_provider.dart';
import 'package:recipe_ledger/providers/navigation_provider.dart';
import 'package:recipe_ledger/providers/recipe_provider.dart';
import 'package:recipe_ledger/pages/main_navigation.dart';
import 'package:recipe_ledger/services/dish_service.dart';
import 'package:recipe_ledger/services/recipe_service.dart';

void main() async {
  // 确保Flutter框架已初始化
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 初始化Hive数据库
    await HiveInit.init();
    debugPrint('Hive数据库初始化成功');

    // 检查菜品数据是否为空，为空则自动插入模拟数据（临时开发逻辑）
    try {
      final dishService = DishService();
      final dishes = await dishService.getAllDishes();
      if (dishes.isEmpty) {
        debugPrint('菜品数据库为空，自动插入模拟数据...');
        await dishService.initializeMockData();
        debugPrint('菜品模拟数据插入完成');
      } else {
        debugPrint('菜品数据库已有 ${dishes.length} 条数据');
      }
    } catch (error) {
      // 模拟数据加载失败不影响应用启动
      debugPrint('自动加载菜品模拟数据失败: $error');
    }

    // 检查菜谱数据是否为空（临时开发逻辑）
    try {
      final recipeService = RecipeService();
      final recipes = await recipeService.getAllRecipes();
      if (recipes.isEmpty) {
        debugPrint('菜谱数据库为空，自动插入模拟数据...');
        await recipeService.initializeMockData();
        debugPrint('菜谱模拟数据插入完成');
      } else {
        debugPrint('菜谱数据库已有 ${recipes.length} 条数据');
      }
    } catch (error) {
      // 模拟数据加载失败不影响应用启动
      debugPrint('自动加载菜谱模拟数据失败: $error');
    }
  } catch (error) {
    debugPrint('Hive数据库初始化失败: $error');
    // 继续运行应用，使用内存存储
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppProvider()),
        ChangeNotifierProvider(create: (context) => DishProvider()),
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
        ChangeNotifierProvider(create: (context) => RecipeProvider()),
      ],
      child: const RecipeLedgerApp(),
    ),
  );
}

/// 菜谱账本应用
class RecipeLedgerApp extends StatelessWidget {
  const RecipeLedgerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '菜谱账本',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        fontFamily: '', // 使用系统默认字体，避免从Google Fonts加载
      ),
      home: const MainNavigation(),
    );
  }
}