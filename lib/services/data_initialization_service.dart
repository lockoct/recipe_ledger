import 'package:hive/hive.dart';

import 'package:recipe_ledger/constants/app_constants.dart';
import 'package:recipe_ledger/models/dish.dart';
import 'package:recipe_ledger/models/recipe.dart';
import 'package:recipe_ledger/models/price_record.dart';
import 'package:recipe_ledger/services/dish_service.dart';
import 'package:recipe_ledger/services/recipe_service.dart';
import 'package:recipe_ledger/services/price_record_service.dart';

/// 数据初始化服务
///
/// 负责清空和重新初始化所有模拟数据，用于开发和测试。
class DataInitializationService {
  final DishService _dishService = DishService();
  final RecipeService _recipeService = RecipeService();
  final PriceRecordService _priceRecordService = PriceRecordService();

  /// 清空所有菜品和菜谱数据
  Future<void> clearAllData() async {
    try {
      // 使用正确的类型打开box（如果已经打开，Hive会返回已打开的box）
      final dishBox = await Hive.openBox<Dish>(HiveConstants.dishBox);
      final recipeBox = await Hive.openBox<Recipe>(HiveConstants.recipeBox);
      final priceRecordBox = await Hive.openBox<PriceRecord>(HiveConstants.priceRecordBox);

      // 清空数据
      await dishBox.clear();
      await recipeBox.clear();
      await priceRecordBox.clear();
    } catch (error) {
      throw Exception('清空数据失败: $error');
    }
  }

  /// 初始化所有模拟数据（菜品 + 菜谱 + 价格记录）
  Future<void> initializeAllMockData() async {
    try {
      // 先清空现有数据
      await clearAllData();

      // 初始化菜品模拟数据
      await _dishService.initializeMockData();

      // 初始化菜谱模拟数据
      await _recipeService.initializeMockData();

      // 初始化价格记录模拟数据
      final dishes = await _dishService.getAllDishes();
      if (dishes.isNotEmpty) {
        await _priceRecordService.initializeMockData(dishes.map((d) => d.id).toList());
      }
    } catch (error) {
      throw Exception('初始化模拟数据失败: $error');
    }
  }

  /// 检查是否有数据（菜品或菜谱）
  Future<bool> hasData() async {
    try {
      bool hasDishes = false;
      bool hasRecipes = false;

      // 检查菜品数据
      if (Hive.isBoxOpen(HiveConstants.dishBox)) {
        final dishBox = Hive.box<Dish>(HiveConstants.dishBox);
        hasDishes = dishBox.isNotEmpty;
      }

      // 检查菜谱数据
      if (Hive.isBoxOpen(HiveConstants.recipeBox)) {
        final recipeBox = Hive.box<Recipe>(HiveConstants.recipeBox);
        hasRecipes = recipeBox.isNotEmpty;
      }

      return hasDishes || hasRecipes;
    } catch (error) {
      return false;
    }
  }

}