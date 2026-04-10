import 'package:flutter/material.dart';
import 'package:recipe_ledger/models/price_record.dart';
import 'package:recipe_ledger/services/price_record_service.dart';

/// 价格记录状态管理提供者
///
/// 管理价格记录的加载和查询状态。
class PriceRecordProvider extends ChangeNotifier {
  /// 价格记录服务实例
  final PriceRecordService _priceRecordService = PriceRecordService();

  /// 价格记录缓存（按菜品ID分组）
  final Map<String, List<PriceRecord>> _recordsCache = {};

  /// 是否正在加载
  bool _isLoading = false;

  /// 错误消息
  String? _errorMessage;

  /// 是否正在加载（只读）
  bool get isLoading => _isLoading;

  /// 错误消息（只读）
  String? get errorMessage => _errorMessage;

  /// 获取指定菜品的价格记录
  ///
  /// 参数：
  /// - `dishId`: 菜品ID
  /// - `startDate`: 开始日期（可选）
  /// - `endDate`: 结束日期（可选）
  /// - `forceRefresh`: 是否强制刷新
  Future<List<PriceRecord>> getPriceRecords({
    required String dishId,
    DateTime? startDate,
    DateTime? endDate,
    bool forceRefresh = false,
  }) async {
    final cacheKey = _buildCacheKey(dishId, startDate, endDate);

    if (!forceRefresh && _recordsCache.containsKey(cacheKey)) {
      return _recordsCache[cacheKey]!;
    }

    try {
      _isLoading = true;
      _errorMessage = null;

      final records = await _priceRecordService.getPriceRecords(
        dishId: dishId,
        startDate: startDate,
        endDate: endDate,
      );

      _recordsCache[cacheKey] = records;

      _isLoading = false;

      return records;
    } catch (error) {
      _isLoading = false;
      _errorMessage = '获取价格记录失败: $error';
      rethrow;
    }
  }

  /// 构建缓存键
  String _buildCacheKey(String dishId, DateTime? startDate, DateTime? endDate) {
    final startStr = startDate?.toIso8601String() ?? 'null';
    final endStr = endDate?.toIso8601String() ?? 'null';
    return '$dishId|$startStr|$endStr';
  }

  /// 添加价格记录
  Future<void> addPriceRecord(PriceRecord record) async {
    try {
      await _priceRecordService.addPriceRecord(record);
      _recordsCache.clear();
      notifyListeners();
    } catch (error) {
      _errorMessage = '添加价格记录失败: $error';
      notifyListeners();
      rethrow;
    }
  }

  /// 批量添加价格记录
  Future<void> addPriceRecords(List<PriceRecord> records) async {
    try {
      await _priceRecordService.addPriceRecords(records);
      _recordsCache.clear();
      notifyListeners();
    } catch (error) {
      _errorMessage = '批量添加价格记录失败: $error';
      notifyListeners();
      rethrow;
    }
  }

  /// 删除价格记录
  Future<void> deletePriceRecord(String id) async {
    try {
      await _priceRecordService.deletePriceRecord(id);
      _recordsCache.clear();
      notifyListeners();
    } catch (error) {
      _errorMessage = '删除价格记录失败: $error';
      notifyListeners();
      rethrow;
    }
  }

  /// 清空缓存
  void clearCache() {
    _recordsCache.clear();
    notifyListeners();
  }

  /// 初始化模拟数据
  Future<void> initializeMockData(List<String> dishIds) async {
    try {
      await _priceRecordService.initializeMockData(dishIds);
      _recordsCache.clear();
      notifyListeners();
    } catch (error) {
      _errorMessage = '初始化模拟数据失败: $error';
      notifyListeners();
      rethrow;
    }
  }
}
