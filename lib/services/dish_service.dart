import "package:hive/hive.dart";
import "package:recipe_ledger/constants/app_constants.dart";
import "package:recipe_ledger/models/dish.dart";
import "package:recipe_ledger/models/dish_list_item.dart";
import "package:recipe_ledger/models/dish_price_history.dart";
import "package:recipe_ledger/models/pagination.dart";
import "package:recipe_ledger/utils/request.dart";

/// 菜品服务类
/// 负责菜品的业务逻辑，包括数据的获取、存储、搜索和排序
class DishService {
  final Request _request = Request();

  /// 获取菜品列表
  ///
  /// 优先从网络获取，失败时从本地缓存读取
  Future<ResponsePagination<DishListItem>> getList({
    int pageNum = 1,
    int pageSize = 10,
    String? name,
    String? region,
    String? categoryId,
  }) async {
    try {
      final res = await _request.get<ResponsePagination<DishListItem>>(
        "/dish/getPage",
        params: {
          "pageNum": pageNum,
          "pageSize": pageSize,
          if (name != null && name.isNotEmpty) "name": name,
          if (region != null && region.isNotEmpty) "region": region,
          if (categoryId != null && categoryId.isNotEmpty) "categoryId": categoryId,
        },
        fromJson: (data) => ResponsePagination.fromJson(data, DishListItem.fromJson),
      );
      await saveListToCache(res.list);
      return res;
    } catch (e) {
      final res = await getListFromCache(
        name: name,
        region: region,
        categoryId: categoryId,
      );
      return ResponsePagination(
        list: res,
        pageNum: pageNum,
        pageSize: pageSize,
        pages: 1,
        total: res.length,
      );
    }
  }

  /// 从本地缓存获取列表数据
  Future<List<DishListItem>> getListFromCache({
    String? name,
    String? region,
    String? categoryId,
  }) async {
    final dishBox = await Hive.openBox<DishListItem>(HiveConstants.dishListBox);
    return dishBox.values
        .where((e) => name == null || e.name.contains(name))
        .where((e) => region == null || e.region == region)
        .where((e) => categoryId == null || e.categoryId == categoryId)
        .toList();
  }

  /// 保存列表数据到本地缓存
  Future<void> saveListToCache(List<DishListItem> dishes) async {
    final dishBox = await Hive.openBox<DishListItem>(HiveConstants.dishListBox);
    await dishBox.clear();
    for (final dish in dishes) {
      await dishBox.put(dish.dishId, dish);
    }
  }

  /// 清空列表缓存
  Future<void> clearListCache() async {
    final dishBox = await Hive.openBox<DishListItem>(HiveConstants.dishListBox);
    await dishBox.clear();
  }

  /// 获取单个菜品详情
  ///
  /// 优先从网络获取，失败时从本地缓存读取
  Future<Dish?> get(String dishId) async {
    try {
      final res = await _request.get<Dish>(
        "/dish/getOne",
        params: {"id": dishId},
        fromJson: (data) => Dish.fromJson(data),
      );
      await saveToCache(res);
      return res;
    } catch (e) {
      return await getFromCache(dishId);
    }
  }

  /// 从本地缓存获取单个菜品
  Future<Dish?> getFromCache(String dishId) async {
    final dishBox = await Hive.openBox<Dish>(HiveConstants.dishBox);
    return dishBox.get(dishId);
  }

  /// 保存单个菜品到本地缓存
  Future<void> saveToCache(Dish dish) async {
    final dishBox = await Hive.openBox<Dish>(HiveConstants.dishBox);
    await dishBox.put(dish.dishId, dish);
  }

  /// 获取菜品价格历史
  Future<List<DishPriceHistory>> getPriceHistory({
    required String dishId,
    required String region,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final res = await _request.get<List<DishPriceHistory>>(
      "/dish/getPriceHistory",
      params: {
        "dishId": dishId,
        "region": region,
        if (startDate != null) "startDate": startDate.toIso8601String().split("T")[0],
        if (endDate != null) "endDate": endDate.toIso8601String().split("T")[0],
      },
      fromJson: (data) =>
          (data as List).map((e) => DishPriceHistory.fromJson(e)).toList(),
    );
    return res;
  }
}