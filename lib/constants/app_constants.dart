/// 价格单位常量
class PriceUnits {
  /// 元/斤
  static const String yuanPerJin = '元/斤';

  /// 元/公斤（千克）
  static const String yuanPerKilogram = '元/公斤（千克）';

  /// 元/两
  static const String yuanPerLiang = '元/两';

  /// 所有可用的价格单位
  static const List<String> all = [
    yuanPerJin,
    yuanPerKilogram,
    yuanPerLiang,
  ];

  /// 获取单位转换系数
  ///
  /// 将内部存储的元/斤转换为目标单位
  static double getConversionFactor(String unit) {
    switch (unit) {
      case yuanPerJin:
        return 1.0;
      case yuanPerKilogram:
        return 2.0; // 1公斤 = 2斤
      case yuanPerLiang:
        return 0.1; // 1两 = 0.1斤
      default:
        return 1.0;
    }
  }

  /// 获取单位显示名称（用于价格显示）
  static String getDisplayName(String unit) {
    switch (unit) {
      case yuanPerJin:
        return '元/斤';
      case yuanPerKilogram:
        return '元/公斤';
      case yuanPerLiang:
        return '元/两';
      default:
        return unit;
    }
  }

  /// 获取单位选择显示名称（用于单位切换页面）
  static String getSelectionDisplayName(String unit) {
    switch (unit) {
      case yuanPerJin:
        return '元/斤';
      case yuanPerKilogram:
        return '元/公斤（千克）';
      case yuanPerLiang:
        return '元/两';
      default:
        return unit;
    }
  }
}

/// 城市常量
class Cities {
  /// 广州市
  static const String guangzhou = '广州市';

  /// 所有支持的城市
  static const List<String> all = [
    guangzhou,
  ];

  /// 默认城市
  static const String defaultCity = guangzhou;
}

/// Hive数据库常量
class HiveConstants {
  /// 数据库名称
  static const String databaseName = 'recipe_ledger_db';

  /// 盒子名称
  static const String dishBox = 'dish_box';
  static const String dishListBox = 'dish_list_box';
  static const String recipeBox = 'recipe_box';
  static const String userSettingsBox = 'user_settings_box';
  static const String cacheMetaBox = 'cache_meta_box';

  /// TypeId定义（从100开始递增）
  static const int dishTypeId = 100;
  static const int dishListItemTypeId = 105;
  static const int recipeTypeId = 101;
  static const int recipeIngredientTypeId = 102;
  static const int userSettingsTypeId = 103;
}

/// 应用路由常量
class AppRoutes {
  /// 主页面
  static const String home = '/';

  /// 菜品列表页面
  static const String dishList = '/dish/list';

  /// 菜品详情页面
  static const String dishDetail = '/dish/detail';

  /// 菜谱列表页面
  static const String recipeList = '/recipe/list';

  /// 菜谱详情页面
  static const String recipeDetail = '/recipe/detail';

  /// 菜谱编辑页面
  static const String recipeEdit = '/recipe/edit';

  /// 设置页面
  static const String settings = '/settings';
}

/// 菜品分类常量
class DishCategories {
  /// 根茎类
  static const String rootVegetables = '根茎类';

  /// 豆制品
  static const String beanProducts = '豆制品';

  /// 菌菇类
  static const String mushrooms = '菌菇类';

  /// 叶菜类
  static const String leafyVegetables = '叶菜类';

  /// 果菜类
  static const String fruitVegetables = '果菜类';

  /// 肉类
  static const String meat = '肉类';

  /// 海鲜类
  static const String seafood = '海鲜类';

  /// 调味品类
  static const String seasonings = '调味品类';

  /// 粮油类
  static const String grains = '粮油类';

  /// 水果类
  static const String fruits = '水果类';

  /// 蛋类
  static const String eggs = '蛋类';

  /// 乳制品
  static const String dairy = '乳制品';

  /// 所有菜品分类
  static const List<String> all = [
    rootVegetables,
    beanProducts,
    mushrooms,
    leafyVegetables,
    fruitVegetables,
    meat,
    seafood,
    seasonings,
    grains,
    fruits,
    eggs,
    dairy,
  ];

  /// 默认选中的分类（不限）
  static const String allCategories = '全部';
}

/// 应用主题常量
class AppThemes {
  /// 主色调
  static const int primaryColor = 0xFF2196F3;

  /// 次要色调
  static const int secondaryColor = 0xFF4CAF50;

  /// 错误颜色
  static const int errorColor = 0xFFF44336;

  /// 警告颜色
  static const int warningColor = 0xFFFF9800;

  /// 成功颜色
  static const int successColor = 0xFF4CAF50;
}

/// 文本常量
class AppTexts {
  /// 应用名称
  static const String appName = '菜谱账本';

  /// 默认错误消息
  static const String defaultErrorMessage = '发生错误，请重试';

  /// 无数据提示
  static const String noDataMessage = '暂无数据';

  /// 加载中提示
  static const String loadingMessage = '加载中...';
}