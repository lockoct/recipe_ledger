import 'package:flutter/material.dart';
import 'package:recipe_ledger/models/dish.dart';
import 'package:recipe_ledger/services/dish_service.dart';

/// 菜品状态管理提供者
///
/// 管理菜品列表的加载、搜索、筛选和排序状态。
class DishProvider extends ChangeNotifier {
  /// 菜品服务实例
  final DishService _dishService = DishService();

  /// 所有菜品列表
  List<Dish> _dishes = [];

  /// 当前显示的菜品列表（经过搜索和筛选）
  List<Dish> _filteredDishes = [];

  /// 搜索关键词
  String _searchQuery = '';

  /// 选中的城市
  String? _selectedCity;

  /// 是否正在加载
  bool _isLoading = false;

  /// 错误消息
  String? _errorMessage;

  /// 排序方式
  DishSortType _sortType = DishSortType.nameAsc;

  /// 构造函数
  DishProvider() {
    // 初始化时加载菜品
    loadDishes();
  }

  /// 所有菜品列表（只读）
  List<Dish> get dishes => _dishes;

  /// 当前显示的菜品列表（只读）
  List<Dish> get filteredDishes => _filteredDishes;

  /// 搜索关键词（只读）
  String get searchQuery => _searchQuery;

  /// 选中的城市（只读）
  String? get selectedCity => _selectedCity;

  /// 是否正在加载（只读）
  bool get isLoading => _isLoading;

  /// 错误消息（只读）
  String? get errorMessage => _errorMessage;

  /// 排序方式（只读）
  DishSortType get sortType => _sortType;

  /// 加载菜品列表
  Future<void> loadDishes() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _dishes = await _dishService.getAllDishes(city: _selectedCity);
      _applyFiltersAndSort();

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      _errorMessage = '加载菜品失败: $error';
      notifyListeners();
    }
  }

  /// 设置搜索关键词
  void setSearchQuery(String query) {
    _searchQuery = query.trim();
    _applyFiltersAndSort();
  }

  /// 设置选中的城市
  void setSelectedCity(String? city) {
    _selectedCity = city;
    loadDishes(); // 重新加载菜品
  }

  /// 设置排序方式
  void setSortType(DishSortType sortType) {
    _sortType = sortType;
    _applyFiltersAndSort();
  }

  /// 添加菜品
  Future<void> addDish(Dish dish) async {
    try {
      await _dishService.addDish(dish);
      await loadDishes(); // 重新加载列表
    } catch (error) {
      _errorMessage = '添加菜品失败: $error';
      notifyListeners();
      rethrow;
    }
  }

  /// 更新菜品
  Future<void> updateDish(Dish dish) async {
    try {
      await _dishService.updateDish(dish);
      await loadDishes(); // 重新加载列表
    } catch (error) {
      _errorMessage = '更新菜品失败: $error';
      notifyListeners();
      rethrow;
    }
  }

  /// 删除菜品
  Future<void> deleteDish(String id) async {
    try {
      await _dishService.deleteDish(id);
      await loadDishes(); // 重新加载列表
    } catch (error) {
      _errorMessage = '删除菜品失败: $error';
      notifyListeners();
      rethrow;
    }
  }

  /// 清空搜索条件
  void clearFilters() {
    _searchQuery = '';
    _selectedCity = null;
    _sortType = DishSortType.nameAsc;
    loadDishes();
  }

  /// 应用筛选和排序
  void _applyFiltersAndSort() {
    // 应用搜索筛选
    _filteredDishes = _dishes.where((dish) {
      final matchesSearch = _searchQuery.isEmpty ||
          dish.name.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCity = _selectedCity == null || dish.city == _selectedCity;

      return matchesSearch && matchesCity;
    }).toList();

    // 应用排序
    _filteredDishes.sort((a, b) {
      switch (_sortType) {
        case DishSortType.nameAsc:
          return a.name.compareTo(b.name);
        case DishSortType.nameDesc:
          return b.name.compareTo(a.name);
        case DishSortType.priceAsc:
          return a.price.compareTo(b.price);
        case DishSortType.priceDesc:
          return b.price.compareTo(a.price);
        case DishSortType.updateTimeDesc:
          return b.updateTime.compareTo(a.updateTime);
        case DishSortType.updateTimeAsc:
          return a.updateTime.compareTo(b.updateTime);
      }
    });

    notifyListeners();
  }

  /// 获取城市列表（去重）
  List<String> get availableCities {
    final cities = _dishes.map((dish) => dish.city).toSet().toList();
    cities.sort();
    return cities;
  }

  /// 获取菜品的价格统计
  Map<String, dynamic> getPriceStats() {
    if (_filteredDishes.isEmpty) {
      return {
        'count': 0,
        'averagePrice': 0.0,
        'minPrice': 0.0,
        'maxPrice': 0.0,
      };
    }

    final prices = _filteredDishes.map((dish) => dish.price).toList();
    final averagePrice = prices.reduce((a, b) => a + b) / prices.length;
    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);

    return {
      'count': prices.length,
      'averagePrice': averagePrice,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
    };
  }
}

/// 菜品排序类型
enum DishSortType {
  nameAsc,      // 名称升序
  nameDesc,     // 名称降序
  priceAsc,     // 价格升序
  priceDesc,    // 价格降序
  updateTimeDesc, // 更新时间降序（最新优先）
  updateTimeAsc,  // 更新时间升序
}