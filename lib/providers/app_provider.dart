import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:recipe_ledger/models/user_settings.dart';
import 'package:recipe_ledger/constants/app_constants.dart';

/// 应用状态管理提供者
///
/// 管理全局应用状态，包括用户设置、主题模式等。
class AppProvider extends ChangeNotifier {
  /// 用户设置
  UserSettings _userSettings;

  /// 当前主题模式
  ThemeMode _themeMode = ThemeMode.light;

  /// 当前选中的城市
  String _currentCity = Cities.defaultCity;

  /// 是否正在加载
  bool _isLoading = false;

  /// 构造函数
  AppProvider() : _userSettings = UserSettings.defaultSettings() {
    _loadSettings();
  }

  /// 用户设置（只读）
  UserSettings get userSettings => _userSettings;

  /// 当前主题模式
  ThemeMode get themeMode => _themeMode;

  /// 当前选中的城市
  String get currentCity => _currentCity;

  /// 是否正在加载
  bool get isLoading => _isLoading;

  /// 加载用户设置
  Future<void> _loadSettings() async {
    try {
      _isLoading = true;
      notifyListeners();

      final settingsBox = await Hive.openBox<UserSettings>(HiveConstants.userSettingsBox);
      final savedSettings = settingsBox.get('user_settings');

      if (savedSettings != null) {
        _userSettings = savedSettings;
        _currentCity = savedSettings.currentCity;
      }

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      // 使用默认设置继续运行
      debugPrint('加载用户设置失败: $error');
    }
  }

  /// 更新用户设置
  Future<void> updateUserSettings(UserSettings newSettings) async {
    try {
      _isLoading = true;
      notifyListeners();

      _userSettings = newSettings;
      _currentCity = newSettings.currentCity;

      final settingsBox = await Hive.openBox<UserSettings>(HiveConstants.userSettingsBox);
      await settingsBox.put('user_settings', newSettings);

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      debugPrint('保存用户设置失败: $error');
      rethrow;
    }
  }

  /// 更新价格单位
  Future<void> updatePriceUnit(String newUnit) async {
    final newSettings = _userSettings.copyWith(priceUnit: newUnit);
    await updateUserSettings(newSettings);
  }

  /// 更新当前城市
  Future<void> updateCurrentCity(String newCity) async {
    final newSettings = _userSettings.copyWith(currentCity: newCity);
    await updateUserSettings(newSettings);
  }

  /// 切换自动同步设置
  Future<void> toggleAutoSync() async {
    final newSettings = _userSettings.copyWith(autoSync: !_userSettings.autoSync);
    await updateUserSettings(newSettings);
  }

  /// 切换主题模式
  void toggleThemeMode() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  /// 设置主题模式
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  /// 设置加载状态
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// 重置为默认设置
  Future<void> resetToDefaults() async {
    final defaultSettings = UserSettings.defaultSettings();
    await updateUserSettings(defaultSettings);
    _themeMode = ThemeMode.light;
    notifyListeners();
  }
}