import "package:hive/hive.dart";
import "package:recipe_ledger/constants/app_constants.dart";

/// 缓存元数据工具类
///
/// 提供统一的缓存同步日期、全量加载标记管理，支持多个模块共享使用。
class CacheMetaUtils {
  /// 获取缓存元数据
  static Future<String?> get(String key) async {
    final box = await Hive.openBox<String>(HiveConstants.cacheMetaBox);
    return box.get(key);
  }

  /// 设置缓存元数据
  static Future<void> set(String key, String value) async {
    final box = await Hive.openBox<String>(HiveConstants.cacheMetaBox);
    await box.put(key, value);
  }

  /// 删除缓存元数据
  static Future<void> delete(String key) async {
    final box = await Hive.openBox<String>(HiveConstants.cacheMetaBox);
    await box.delete(key);
  }

  /// 判断缓存是否新鲜（同步日期 == 今天）
  static Future<bool> isFresh(String syncDateKey) async {
    final syncDate = await get(syncDateKey);
    if (syncDate == null) {
      return false;
    }
    final today = DateTime.now().toIso8601String().split("T")[0];
    return syncDate == today;
  }

  /// 判断是否已全量加载
  static Future<bool> isFullyLoaded(String fullyLoadedKey) async {
    final val = await get(fullyLoadedKey);
    return val == "true";
  }

  /// 获取今天日期字符串（yyyy-MM-dd）
  static String get today => DateTime.now().toIso8601String().split("T")[0];
}