import 'package:hive/hive.dart';
import 'package:recipe_ledger/models/recipe.dart';
import 'package:recipe_ledger/constants/app_constants.dart';

/// 菜谱服务类
///
/// 负责菜谱的业务逻辑，包括菜谱的创建、编辑、删除和查询。
class RecipeService {
  /// 获取所有菜谱
  Future<List<Recipe>> getAllRecipes() async {
    try {
      final recipeBox = await Hive.openBox<Recipe>(HiveConstants.recipeBox);
      return recipeBox.values.toList();
    } catch (error) {
      throw Exception('获取菜谱列表失败: $error');
    }
  }

  /// 根据ID获取菜谱
  Future<Recipe?> getRecipeById(String id) async {
    try {
      final recipeBox = await Hive.openBox<Recipe>(HiveConstants.recipeBox);
      return recipeBox.values.firstWhere((recipe) => recipe.id == id);
    } catch (error) {
      return null;
    }
  }

  /// 搜索菜谱
  Future<List<Recipe>> searchRecipes(String query) async {
    try {
      final recipeBox = await Hive.openBox<Recipe>(HiveConstants.recipeBox);
      final recipes = recipeBox.values.toList();
      final normalizedQuery = query.toLowerCase();
      return recipes
          .where((recipe) => recipe.name.toLowerCase().contains(normalizedQuery))
          .toList();
    } catch (error) {
      throw Exception('搜索菜谱失败: $error');
    }
  }

  /// 创建菜谱
  Future<void> createRecipe(Recipe recipe) async {
    try {
      final recipeBox = await Hive.openBox<Recipe>(HiveConstants.recipeBox);
      await recipeBox.put(recipe.id, recipe);
    } catch (error) {
      throw Exception('创建菜谱失败: $error');
    }
  }

  /// 更新菜谱
  Future<void> updateRecipe(Recipe recipe) async {
    try {
      final recipeBox = await Hive.openBox<Recipe>(HiveConstants.recipeBox);
      await recipeBox.put(recipe.id, recipe);
    } catch (error) {
      throw Exception('更新菜谱失败: $error');
    }
  }

  /// 删除菜谱
  Future<void> deleteRecipe(String id) async {
    try {
      final recipeBox = await Hive.openBox<Recipe>(HiveConstants.recipeBox);
      await recipeBox.delete(id);
    } catch (error) {
      throw Exception('删除菜谱失败: $error');
    }
  }

  /// 获取收藏的菜谱
  Future<List<Recipe>> getFavoriteRecipes() async {
    // TODO: 实现获取收藏菜谱功能
    await Future.delayed(const Duration(milliseconds: 500));
    return [];
  }

  /// 切换菜谱收藏状态
  Future<void> toggleFavorite(String recipeId) async {
    // TODO: 实现切换收藏状态功能
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// 计算菜谱总成本
  Future<double> calculateRecipeCost(String recipeId) async {
    try {
      final recipe = await getRecipeById(recipeId);
      if (recipe == null) return 0.0;

      // TODO: 实现根据配料计算总成本（需要菜品价格数据）
      return 0.0;
    } catch (error) {
      throw Exception('计算菜谱成本失败: $error');
    }
  }

  /// 批量添加菜谱
  Future<void> addRecipes(List<Recipe> recipes) async {
    try {
      final recipeBox = await Hive.openBox<Recipe>(HiveConstants.recipeBox);
      for (final recipe in recipes) {
        await recipeBox.put(recipe.id, recipe);
      }
    } catch (error) {
      throw Exception('批量添加菜谱失败: $error');
    }
  }

  /// 清空所有菜谱数据
  Future<void> clearAllRecipes() async {
    try {
      final recipeBox = await Hive.openBox<Recipe>(HiveConstants.recipeBox);
      await recipeBox.clear();
    } catch (error) {
      throw Exception('清空菜谱数据失败: $error');
    }
  }

  /// 初始化模拟数据（开发用）
  Future<void> initializeMockData() async {
    try {
      final mockRecipes = [
        Recipe(
          id: '1',
          name: '西红柿炒鸡蛋',
          coverImage: null,
          ingredients: [],
          instructions: '1. 准备食材：西红柿2个，鸡蛋3个\n2. 西红柿切块，鸡蛋打散\n3. 锅中加油，先炒鸡蛋盛出\n4. 再加油炒西红柿，加入适量盐和糖\n5. 加入炒好的鸡蛋，翻炒均匀即可',
          createTime: DateTime.now().subtract(const Duration(days: 5)),
          updateTime: DateTime.now().subtract(const Duration(days: 2)),
        ),
        Recipe(
          id: '2',
          name: '红烧肉',
          coverImage: null,
          ingredients: [],
          instructions: '1. 五花肉切块，焯水备用\n2. 锅中加油和冰糖，炒糖色\n3. 加入五花肉翻炒上色\n4. 加入生抽、老抽、料酒、姜片、八角\n5. 加水没过肉，小火炖煮1小时\n6. 大火收汁即可',
          createTime: DateTime.now().subtract(const Duration(days: 7)),
          updateTime: DateTime.now().subtract(const Duration(days: 3)),
        ),
        Recipe(
          id: '3',
          name: '麻婆豆腐',
          coverImage: null,
          ingredients: [],
          instructions: '1. 豆腐切块，焯水备用\n2. 锅中加油，炒香豆瓣酱和蒜末\n3. 加入肉末翻炒\n4. 加入豆腐，小心翻动\n5. 加入生抽、料酒、花椒粉\n6. 勾芡，撒上葱花即可',
          createTime: DateTime.now().subtract(const Duration(days: 10)),
          updateTime: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Recipe(
          id: '4',
          name: '宫保鸡丁',
          coverImage: null,
          ingredients: [],
          instructions: '1. 鸡胸肉切丁，用料酒、淀粉腌制\n2. 准备花生米、干辣椒、花椒\n3. 锅中加油，先炒鸡丁至变色盛出\n4. 炒香干辣椒和花椒\n5. 加入鸡丁、花生米\n6. 加入宫保酱汁翻炒均匀',
          createTime: DateTime.now().subtract(const Duration(days: 15)),
          updateTime: DateTime.now().subtract(const Duration(days: 4)),
        ),
        Recipe(
          id: '5',
          name: '鱼香肉丝',
          coverImage: null,
          ingredients: [],
          instructions: '1. 猪里脊切丝，用料酒、淀粉腌制\n2. 木耳、胡萝卜、青椒切丝\n3. 准备鱼香汁（生抽、醋、糖、淀粉）\n4. 锅中加油，炒香泡椒和蒜末\n5. 加入肉丝翻炒至变色\n6. 加入蔬菜丝和鱼香汁，翻炒均匀',
          createTime: DateTime.now().subtract(const Duration(days: 20)),
          updateTime: DateTime.now().subtract(const Duration(days: 6)),
        ),
      ];

      await addRecipes(mockRecipes);
    } catch (error) {
      throw Exception('初始化菜谱模拟数据失败: $error');
    }
  }
}