import "package:flutter/foundation.dart";
import "package:hive/hive.dart";
import "package:recipe_ledger/constants/app_constants.dart";
import "package:recipe_ledger/models/dish.dart";
import "package:recipe_ledger/models/dish_list_item.dart";
import "package:recipe_ledger/models/dish_price_history.dart";
import "package:recipe_ledger/models/pagination.dart";
import "package:recipe_ledger/utils/cache_meta.dart";
import "package:recipe_ledger/utils/request.dart";

/// 菜品服务类
/// 负责菜品的业务逻辑，包括数据的获取、存储、搜索和排序
class DishService {
  final Request _request = Request();

  static const _syncDateKey = "dish_list_sync_date";
  static const _fullyLoadedKey = "dish_list_fully_loaded";

  /// 获取菜品列表
  ///
  /// 本地优先策略：无筛选且缓存新鲜时直接返回本地数据；
  /// 缓存过期/无缓存时清空缓存重新请求网络；
  /// 有筛选条件时直接请求网络，不走缓存。
  Future<ResponsePagination<DishListItem>> getList({
    int pageNum = 1,
    int pageSize = 10,
    String? name,
    String? region,
    String? categoryId,
    bool forceRefresh = false,
  }) async {
    final hasFilter = (name != null && name.isNotEmpty) ||
        (region != null && region.isNotEmpty) ||
        (categoryId != null && categoryId.isNotEmpty);

    try {
      // 筛选/搜索 → 请求网络，不缓存结果
      if (hasFilter) {
        debugPrint("[DishService.getList] 筛选/搜索，请求网络");
        return await _getListFromNetwork(pageNum, pageSize, name, region, categoryId, false, cacheResults: false);
      }

      // 加载更多 → 请求网络，追加缓存
      if (pageNum > 1) {
        debugPrint("[DishService.getList] 加载更多，请求网络");
        return await _getListFromNetwork(pageNum, pageSize, name, region, categoryId, false);
      }

      // 强制刷新 → 请求网络，清空缓存
      if (forceRefresh) {
        debugPrint("[DishService.getList] 强制刷新，请求网络");
        return await _getListFromNetwork(pageNum, pageSize, name, region, categoryId, true);
      }

      // 缓存新鲜 → 返回缓存
      if (await CacheMetaUtils.isFresh(_syncDateKey)) {
        debugPrint("[DishService.getList] 缓存新鲜，返回本地缓存");
        return await _getListFromCache(pageSize);
      }

      // 缓存过期/无缓存 → 请求网络，清空缓存
      debugPrint("[DishService.getList] 缓存过期或无缓存，请求网络");
      return await _getListFromNetwork(pageNum, pageSize, name, region, categoryId, true);
    } catch (_) {
      debugPrint("[DishService.getList] 网络请求失败，返回本地缓存");
      return await _getListFromCache(pageSize);
    }
  }

  /// 保存列表数据到本地缓存
  ///
  /// [clear] 为 true 时先清空再写入（第一页），false 时追加写入（加载更多）
  Future<void> saveListToCache(List<DishListItem> dishes, {bool clear = false}) async {
    final dishBox = await Hive.openBox<DishListItem>(HiveConstants.dishListBox);
    if (clear) {
      await dishBox.clear();
    }
    for (final dish in dishes) {
      await dishBox.put(dish.dishId, dish);
    }
  }

  /// 从网络请求数据
  Future<ResponsePagination<DishListItem>> _getListFromNetwork(
    int pageNum,
    int pageSize,
    String? name,
    String? region,
    String? categoryId,
    bool clearCache,
    {bool cacheResults = true}
  ) async {
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

    if (cacheResults) {
      await saveListToCache(res.list, clear: clearCache);
      await CacheMetaUtils.set(_syncDateKey, CacheMetaUtils.today);
      await CacheMetaUtils.set(_fullyLoadedKey, pageNum == res.pages ? "true" : "false");
    }
    return res;
  }

  /// 从本地缓存返回数据（不走分页，全部返回）
  Future<ResponsePagination<DishListItem>> _getListFromCache(int pageSize) async {
    final dishBox = await Hive.openBox<DishListItem>(HiveConstants.dishListBox);
    final list = dishBox.values.toList();
    final cachePageNum = (list.length / pageSize).ceil();
    final fullyLoaded = await CacheMetaUtils.isFullyLoaded(_fullyLoadedKey);
    return ResponsePagination(
      list: list,
      pageNum: cachePageNum,
      pageSize: list.length,
      pages: fullyLoaded ? cachePageNum : cachePageNum + 1,
      total: list.length,
    );
  }

  /// 生成菜品详情缓存同步日期 key
  String _getSyncDateKey(String dishId) => "dish_detail_${dishId}_sync_date";

  /// 获取单个菜品详情
  ///
  /// 本地优先策略：缓存新鲜时直接返回本地数据；
  /// 缓存过期/无缓存时请求网络；
  /// 网络失败时返回旧缓存兜底。
  Future<Dish?> get(String dishId) async {
    final syncDateKey = _getSyncDateKey(dishId);

    try {
      // 缓存新鲜 → 返回本地缓存
      if (await CacheMetaUtils.isFresh(syncDateKey)) {
        debugPrint("[DishService.get] 缓存新鲜，返回本地缓存");
        return await getFromCache(dishId);
      }

      // 缓存过期/无缓存 → 请求网络
      debugPrint("[DishService.get] 缓存过期或无缓存，请求网络");
      final res = await _request.get<Dish>(
        "/dish/getOne",
        params: {"id": dishId},
        fromJson: (data) => Dish.fromJson(data),
      );
      await saveToCache(res);
      await CacheMetaUtils.set(syncDateKey, CacheMetaUtils.today);
      return res;
    } catch (_) {
      debugPrint("[DishService.get] 网络请求失败，返回本地缓存");
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