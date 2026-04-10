import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:recipe_ledger/models/dish.dart';
import 'package:recipe_ledger/models/recipe.dart';
import 'package:recipe_ledger/models/recipe_ingredient.dart';
import 'package:recipe_ledger/models/user_settings.dart';
import 'package:recipe_ledger/models/price_record.dart';

/// Hive数据库初始化工具
class HiveInit {
  /// 初始化Hive数据库
  ///
  /// 该方法必须在Flutter应用启动时调用，用于：
  /// 1. 初始化Hive Flutter适配器
  /// 2. 注册所有数据模型的Hive适配器
  /// 3. 打开所有需要的Hive盒子
  static Future<void> init() async {
    try {
      // 初始化Hive Flutter适配器
      await Hive.initFlutter();

      // 注册所有数据模型的Hive适配器
      _registerAdapters();

      // 打开所有需要的Hive盒子（延迟打开，使用时再打开）
      debugPrint('Hive数据库初始化完成');
    } catch (error) {
      debugPrint('Hive数据库初始化失败: $error');
      rethrow;
    }
  }

  /// 注册所有Hive适配器
  static void _registerAdapters() {
    // 注册菜品适配器 (typeId: 100)
    if (!Hive.isAdapterRegistered(DishAdapter().typeId)) {
      Hive.registerAdapter(DishAdapter());
    }

    // 注册菜谱适配器 (typeId: 101)
    if (!Hive.isAdapterRegistered(RecipeAdapter().typeId)) {
      Hive.registerAdapter(RecipeAdapter());
    }

    // 注册菜谱配料适配器 (typeId: 102)
    if (!Hive.isAdapterRegistered(RecipeIngredientAdapter().typeId)) {
      Hive.registerAdapter(RecipeIngredientAdapter());
    }

    // 注册用户设置适配器 (typeId: 103)
    if (!Hive.isAdapterRegistered(UserSettingsAdapter().typeId)) {
      Hive.registerAdapter(UserSettingsAdapter());
    }

    // 注册价格记录适配器 (typeId: 104)
    if (!Hive.isAdapterRegistered(PriceRecordAdapter().typeId)) {
      Hive.registerAdapter(PriceRecordAdapter());
    }
  }

  /// 打开特定名称的Hive盒子
  static Future<Box<T>> openBox<T>(String boxName) async {
    try {
      return await Hive.openBox<T>(boxName);
    } catch (error) {
      debugPrint('打开Hive盒子[$boxName]失败: $error');
      rethrow;
    }
  }

  /// 获取应用文档目录路径
  static Future<String> getAppDocumentsPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  /// 清理Hive数据库（开发/调试使用）
  static Future<void> clearAllData() async {
    try {
      await Hive.deleteFromDisk();
      debugPrint('Hive数据库已清空');
    } catch (error) {
      debugPrint('清空Hive数据库失败: $error');
      rethrow;
    }
  }
}