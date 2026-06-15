import 'package:hive/hive.dart';

import 'package:recipe_ledger/constants/app_constants.dart';
import 'package:recipe_ledger/models/recipe.dart';
import 'package:recipe_ledger/services/recipe_service.dart';

/// 数据初始化服务
///
/// 负责清空和重新初始化所有模拟数据，用于开发和测试。
class DataInitializationService {
  final RecipeService _recipeService = RecipeService();

  /// 清空所有菜谱数据
  Future<void> clearAllData() async {
    try {
      final recipeBox = await Hive.openBox<Recipe>(HiveConstants.recipeBox);
      await recipeBox.clear();
    } catch (error) {
      throw Exception('清空数据失败: $error');
    }
  }

  /// 初始化所有模拟数据（菜谱）
  Future<void> initializeAllMockData() async {
    try {
      // 先清空现有数据
      await clearAllData();

      // 初始化菜谱模拟数据
      await _recipeService.initializeMockData();
    } catch (error) {
      throw Exception('初始化模拟数据失败: $error');
    }
  }

  /// 检查是否有数据（菜谱）
  Future<bool> hasData() async {
    try {
      if (Hive.isBoxOpen(HiveConstants.recipeBox)) {
        final recipeBox = Hive.box<Recipe>(HiveConstants.recipeBox);
        return recipeBox.isNotEmpty;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

}