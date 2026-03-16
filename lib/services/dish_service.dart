import 'package:hive/hive.dart';
import 'package:recipe_ledger/models/dish.dart';
import 'package:recipe_ledger/constants/app_constants.dart';

/// 菜品服务类
///
/// 负责菜品的业务逻辑，包括数据的获取、存储、搜索和排序。
class DishService {
  /// 获取所有菜品
  ///
  /// 参数：
  /// - `city`: 城市筛选（可选）
  /// - `forceRefresh`: 是否强制刷新（从网络获取）
  ///
  /// 返回：菜品列表
  Future<List<Dish>> getAllDishes({
    String? city,
    bool forceRefresh = false,
  }) async {
    try {
      final dishBox = await Hive.openBox<Dish>(HiveConstants.dishBox);

      // 从本地存储获取数据
      List<Dish> dishes = dishBox.values.toList();

      // 按城市筛选
      if (city != null) {
        dishes = dishes.where((dish) => dish.city == city).toList();
      }

      // TODO: 实现网络同步逻辑
      // if (forceRefresh) {
      //   final remoteDishes = await _fetchDishesFromServer();
      //   await _updateLocalStorage(remoteDishes);
      //   dishes = remoteDishes;
      // }

      return dishes;
    } catch (error) {
      throw Exception('获取菜品列表失败: $error');
    }
  }

  /// 根据ID获取菜品
  Future<Dish?> getDishById(String id) async {
    try {
      final dishBox = await Hive.openBox<Dish>(HiveConstants.dishBox);
      return dishBox.values.firstWhere((dish) => dish.id == id);
    } catch (error) {
      throw Exception('获取菜品详情失败: $error');
    }
  }

  /// 搜索菜品
  ///
  /// 参数：
  /// - `query`: 搜索关键词
  /// - `city`: 城市筛选（可选）
  ///
  /// 返回：匹配的菜品列表
  Future<List<Dish>> searchDishes(String query, {String? city}) async {
    try {
      final dishBox = await Hive.openBox<Dish>(HiveConstants.dishBox);
      List<Dish> dishes = dishBox.values.toList();

      // 按城市筛选
      if (city != null) {
        dishes = dishes.where((dish) => dish.city == city).toList();
      }

      // 按名称搜索（不区分大小写）
      final normalizedQuery = query.toLowerCase();
      dishes = dishes
          .where((dish) => dish.name.toLowerCase().contains(normalizedQuery))
          .toList();

      return dishes;
    } catch (error) {
      throw Exception('搜索菜品失败: $error');
    }
  }

  /// 添加菜品
  Future<void> addDish(Dish dish) async {
    try {
      final dishBox = await Hive.openBox<Dish>(HiveConstants.dishBox);
      await dishBox.put(dish.id, dish);
    } catch (error) {
      throw Exception('添加菜品失败: $error');
    }
  }

  /// 更新菜品
  Future<void> updateDish(Dish dish) async {
    try {
      final dishBox = await Hive.openBox<Dish>(HiveConstants.dishBox);
      await dishBox.put(dish.id, dish);
    } catch (error) {
      throw Exception('更新菜品失败: $error');
    }
  }

  /// 删除菜品
  Future<void> deleteDish(String id) async {
    try {
      final dishBox = await Hive.openBox<Dish>(HiveConstants.dishBox);
      await dishBox.delete(id);
    } catch (error) {
      throw Exception('删除菜品失败: $error');
    }
  }

  /// 批量添加菜品
  Future<void> addDishes(List<Dish> dishes) async {
    try {
      final dishBox = await Hive.openBox<Dish>(HiveConstants.dishBox);

      for (final dish in dishes) {
        await dishBox.put(dish.id, dish);
      }
    } catch (error) {
      throw Exception('批量添加菜品失败: $error');
    }
  }

  /// 清空所有菜品数据
  Future<void> clearAllDishes() async {
    try {
      final dishBox = await Hive.openBox<Dish>(HiveConstants.dishBox);
      await dishBox.clear();
    } catch (error) {
      throw Exception('清空菜品数据失败: $error');
    }
  }

  /// 获取菜品价格统计
  Future<Map<String, dynamic>> getPriceStatistics({String? city}) async {
    try {
      final dishes = await getAllDishes(city: city);

      if (dishes.isEmpty) {
        return {
          'count': 0,
          'averagePrice': 0.0,
          'minPrice': 0.0,
          'maxPrice': 0.0,
        };
      }

      final prices = dishes.map((dish) => dish.price).toList();
      final averagePrice = prices.reduce((a, b) => a + b) / prices.length;
      final minPrice = prices.reduce((a, b) => a < b ? a : b);
      final maxPrice = prices.reduce((a, b) => a > b ? a : b);

      return {
        'count': dishes.length,
        'averagePrice': averagePrice,
        'minPrice': minPrice,
        'maxPrice': maxPrice,
      };
    } catch (error) {
      throw Exception('获取价格统计失败: $error');
    }
  }

  /// 初始化模拟数据（开发用）
  Future<void> initializeMockData() async {
    try {
      final mockDishes = [
        Dish(
          id: '1',
          name: '西红柿',
          price: 0.02, // 元/克
          city: '广州市',
          updateTime: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Dish(
          id: '2',
          name: '鸡蛋',
          price: 0.015,
          city: '广州市',
          updateTime: DateTime.now().subtract(const Duration(days: 2)),
        ),
        Dish(
          id: '3',
          name: '猪肉',
          price: 0.035,
          city: '广州市',
          updateTime: DateTime.now().subtract(const Duration(days: 3)),
        ),
        Dish(
          id: '4',
          name: '大米',
          price: 0.008,
          city: '广州市',
          updateTime: DateTime.now().subtract(const Duration(days: 4)),
        ),
        Dish(
          id: '5',
          name: '白菜',
          price: 0.006,
          city: '广州市',
          updateTime: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ];

      await addDishes(mockDishes);
    } catch (error) {
      throw Exception('初始化模拟数据失败: $error');
    }
  }
}