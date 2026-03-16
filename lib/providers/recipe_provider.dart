import 'package:flutter/material.dart';
import 'package:recipe_ledger/models/recipe.dart';
import 'package:recipe_ledger/services/recipe_service.dart';

/// 菜谱状态管理提供者
///
/// 管理菜谱列表的加载、搜索和状态。
class RecipeProvider extends ChangeNotifier {
  /// 菜谱服务实例
  final RecipeService _recipeService = RecipeService();

  /// 所有菜谱列表
  List<Recipe> _recipes = [];

  /// 当前显示的菜谱列表（经过搜索筛选）
  List<Recipe> _filteredRecipes = [];

  /// 搜索关键词
  String _searchQuery = '';

  /// 是否正在加载
  bool _isLoading = false;

  /// 错误消息
  String? _errorMessage;

  /// 构造函数
  RecipeProvider() {
    // 初始化时加载菜谱
    loadRecipes();
  }

  /// 所有菜谱列表（只读）
  List<Recipe> get recipes => _recipes;

  /// 当前显示的菜谱列表（只读）
  List<Recipe> get filteredRecipes => _filteredRecipes;

  /// 搜索关键词（只读）
  String get searchQuery => _searchQuery;

  /// 是否正在加载（只读）
  bool get isLoading => _isLoading;

  /// 错误消息（只读）
  String? get errorMessage => _errorMessage;

  /// 加载菜谱列表
  Future<void> loadRecipes() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _recipes = await _recipeService.getAllRecipes();
      _applySearchFilter();

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      _errorMessage = '加载菜谱失败: $error';
      notifyListeners();
    }
  }

  /// 设置搜索关键词
  void setSearchQuery(String query) {
    _searchQuery = query.trim();
    _applySearchFilter();
  }

  /// 添加菜谱
  Future<void> addRecipe(Recipe recipe) async {
    try {
      await _recipeService.createRecipe(recipe);
      await loadRecipes(); // 重新加载列表
    } catch (error) {
      _errorMessage = '添加菜谱失败: $error';
      notifyListeners();
      rethrow;
    }
  }

  /// 更新菜谱
  Future<void> updateRecipe(Recipe recipe) async {
    try {
      await _recipeService.updateRecipe(recipe);
      await loadRecipes(); // 重新加载列表
    } catch (error) {
      _errorMessage = '更新菜谱失败: $error';
      notifyListeners();
      rethrow;
    }
  }

  /// 删除菜谱
  Future<void> deleteRecipe(String id) async {
    try {
      await _recipeService.deleteRecipe(id);
      await loadRecipes(); // 重新加载列表
    } catch (error) {
      _errorMessage = '删除菜谱失败: $error';
      notifyListeners();
      rethrow;
    }
  }

  /// 清空搜索条件
  void clearSearch() {
    _searchQuery = '';
    _applySearchFilter();
  }

  /// 应用搜索筛选
  void _applySearchFilter() {
    if (_searchQuery.isEmpty) {
      _filteredRecipes = List.from(_recipes);
    } else {
      final normalizedQuery = _searchQuery.toLowerCase();
      _filteredRecipes = _recipes
          .where((recipe) =>
              recipe.name.toLowerCase().contains(normalizedQuery))
          .toList();
    }

    // 按更新时间降序排序（最新优先）
    _filteredRecipes.sort((a, b) => b.updateTime.compareTo(a.updateTime));

    notifyListeners();
  }

  /// 获取菜谱统计
  Map<String, dynamic> getRecipeStats() {
    return {
      'totalRecipes': _recipes.length,
      'filteredRecipes': _filteredRecipes.length,
    };
  }

  /// 根据ID获取菜谱
  Recipe? getRecipeById(String id) {
    try {
      return _recipes.firstWhere((recipe) => recipe.id == id);
    } catch (error) {
      return null;
    }
  }
}