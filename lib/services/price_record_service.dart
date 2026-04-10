import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:recipe_ledger/models/price_record.dart';
import 'package:recipe_ledger/constants/app_constants.dart';

/// 价格记录服务类
///
/// 负责价格记录的业务逻辑，包括数据的获取、存储和查询。
class PriceRecordService {
  /// 获取指定菜品的价格记录
  ///
  /// 参数：
  /// - `dishId`: 菜品ID
  /// - `startDate`: 开始日期（可选）
  /// - `endDate`: 结束日期（可选）
  ///
  /// 返回：价格记录列表（按日期升序排列）
  Future<List<PriceRecord>> getPriceRecords({
    required String dishId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final box = await Hive.openBox<PriceRecord>(HiveConstants.priceRecordBox);
      
      debugPrint('查询价格记录 - dishId: $dishId, startDate: $startDate, endDate: $endDate');
      debugPrint('数据库中共有 ${box.length} 条价格记录');
      
      List<PriceRecord> records = box.values.where((record) {
        if (record.dishId != dishId) return false;
        if (startDate != null && record.date.isBefore(startDate)) return false;
        if (endDate != null && record.date.isAfter(endDate)) return false;
        return true;
      }).toList();

      records.sort((a, b) => a.date.compareTo(b.date));
      debugPrint('找到 ${records.length} 条匹配的价格记录');
      return records;
    } catch (error) {
      debugPrint('获取价格记录失败: $error');
      throw Exception('获取价格记录失败: $error');
    }
  }

  /// 添加价格记录
  Future<void> addPriceRecord(PriceRecord record) async {
    try {
      final box = await Hive.openBox<PriceRecord>(HiveConstants.priceRecordBox);
      await box.put(record.id, record);
    } catch (error) {
      throw Exception('添加价格记录失败: $error');
    }
  }

  /// 批量添加价格记录
  Future<void> addPriceRecords(List<PriceRecord> records) async {
    try {
      final box = await Hive.openBox<PriceRecord>(HiveConstants.priceRecordBox);
      for (final record in records) {
        await box.put(record.id, record);
      }
    } catch (error) {
      throw Exception('批量添加价格记录失败: $error');
    }
  }

  /// 删除价格记录
  Future<void> deletePriceRecord(String id) async {
    try {
      final box = await Hive.openBox<PriceRecord>(HiveConstants.priceRecordBox);
      await box.delete(id);
    } catch (error) {
      throw Exception('删除价格记录失败: $error');
    }
  }

  /// 删除指定菜品的所有价格记录
  Future<void> deletePriceRecordsByDishId(String dishId) async {
    try {
      final box = await Hive.openBox<PriceRecord>(HiveConstants.priceRecordBox);
      final recordsToDelete = box.values.where((r) => r.dishId == dishId).toList();
      for (final record in recordsToDelete) {
        await box.delete(record.id);
      }
    } catch (error) {
      throw Exception('删除价格记录失败: $error');
    }
  }

  /// 清空所有价格记录
  Future<void> clearAllPriceRecords() async {
    try {
      final box = await Hive.openBox<PriceRecord>(HiveConstants.priceRecordBox);
      await box.clear();
    } catch (error) {
      throw Exception('清空价格记录失败: $error');
    }
  }

  /// 生成模拟价格记录数据
  ///
  /// 为每个菜品生成过去30天的价格记录
  Future<void> initializeMockData(List<String> dishIds) async {
    try {
      final box = await Hive.openBox<PriceRecord>(HiveConstants.priceRecordBox);
      
      debugPrint('开始初始化价格记录，菜品ID列表: $dishIds');
      
      final basePrices = <String, double>{
        '1': 4.16,  // 西红柿 元/斤
        '2': 5.59,  // 鸡蛋 元/斤
        '3': 17.38, // 猪肉 元/斤
        '4': 3.0,   // 大米 元/斤
        '5': 2.80,  // 白菜 元/斤
      };

      final now = DateTime.now();
      int recordId = 1;

      for (final dishId in dishIds) {
        final basePrice = basePrices[dishId] ?? 5.0;
        debugPrint('为菜品 $dishId 生成价格记录，基准价格: $basePrice 元/斤');
        
        for (int i = 29; i >= 0; i--) {
          final date = now.subtract(Duration(days: i));
          final randomFactor = 0.9 + (date.day % 10) * 0.02;
          final price = double.parse((basePrice * randomFactor).toStringAsFixed(2));

          final dateStr = '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';
          final record = PriceRecord(
            id: 'pr_${dishId}_$dateStr',
            dishId: dishId,
            price: price,
            date: DateTime(date.year, date.month, date.day),
          );

          await box.put(record.id, record);
          recordId++;
        }
      }
      
      debugPrint('价格记录初始化完成，共生成 ${recordId - 1} 条记录');
    } catch (error) {
      debugPrint('初始化模拟价格记录失败: $error');
      throw Exception('初始化模拟价格记录失败: $error');
    }
  }
}
