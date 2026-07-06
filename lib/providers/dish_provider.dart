import "package:flutter/material.dart";
import "package:recipe_ledger/models/dish.dart";
import "package:recipe_ledger/models/dish_list_item.dart";
import "package:recipe_ledger/models/dish_price_history.dart";
import "package:recipe_ledger/models/pagination.dart";
import "package:recipe_ledger/services/dish_service.dart";

/// 菜品状态管理提供者
///
/// 管理菜品列表的加载、搜索、筛选状态。
class DishProvider extends ChangeNotifier {
  /// 菜品服务实例
  final DishService _dishService = DishService();

  /// 所有菜品列表
  List<DishListItem> _dishes = [];

  /// 查询条件
  final DishQueryForm _queryForm = DishQueryForm();

  /// 分页信息
  final Pagination _pagination = Pagination();

  /// 是否有更多数据
  bool get hasMore => _pagination.hasMore;

  /// 查询条件（只读）
  DishQueryForm get queryForm => _queryForm;

  /// 分页信息（只读）
  Pagination get pagination => _pagination;

  /// 当前页码（只读）
  int get pageNum => _pagination.pageNum;

  /// 每页数量（只读）
  int get pageSize => _pagination.pageSize;

  /// 总页数（只读）
  int get totalPages => _pagination.pages;

  /// 总数量（只读）
  int get total => _pagination.total;

  /// 菜品列表（只读）
  List<DishListItem> get dishes => _dishes;

  /// 获取菜品列表
  Future<ResponsePagination<DishListItem>> getList({bool refresh = false}) async {
    if (refresh) {
      _pagination.reset();
      _dishes = [];
    }

    final response = await _dishService.getList(
      pageNum: _pagination.pageNum,
      pageSize: _pagination.pageSize,
      name: _queryForm.name.isNotEmpty ? _queryForm.name : null,
      region: _queryForm.region,
      categoryId: _queryForm.categoryId,
      forceRefresh: refresh,
    );

    if (refresh) {
      _dishes = response.list;
    } else {
      _dishes.addAll(response.list);
    }
    _pagination.total = response.total;
    _pagination.pages = response.pages;
    _pagination.pageNum = response.pageNum;
    notifyListeners();

    return response;
  }

  /// 加载更多数据
  Future<void> getMore() async {
    if (!hasMore) {
      return;
    }
    _pagination.pageNum++;
    await getList();
  }

  /// 搜索
  void search(String query) {
    _queryForm.name = query.trim();
    getList(refresh: true);
  }

  /// 设置搜索菜品名称
  void setName(String query) {
    _queryForm.name = query.trim();
  }

  /// 设置选中的城市
  void setRegion(String? city) {
    _queryForm.region = city;
    getList(refresh: true);
  }

  /// 设置选中的分类
  void setCategory(String? category) {
    _queryForm.categoryId = category;
    getList(refresh: true);
  }

  /// 获取单个菜品详情
  Future<Dish?> get(String dishId) async {
    return _dishService.get(dishId);
  }

  /// 获取菜品价格历史
  Future<List<DishPriceHistory>> getPriceHistory({
    required String dishId,
    required String region,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return _dishService.getPriceHistory(
      dishId: dishId,
      region: region,
      startDate: startDate,
      endDate: endDate,
    );
  }
}

/// 菜品查询条件表单
class DishQueryForm {
  /// 搜索关键词（菜品名称）
  String name = "";

  /// 区域/城市
  String? region;

  /// 分类ID
  String? categoryId;

  /// 重置所有条件
  void reset() {
    name = "";
    region = null;
    categoryId = null;
  }
}