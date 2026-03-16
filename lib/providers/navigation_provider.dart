import 'package:flutter/material.dart';

/// 导航状态管理提供者
///
/// 管理底部导航标签页的状态，包括当前选中标签、历史记录等。
class NavigationProvider extends ChangeNotifier {
  /// 当前选中的标签索引
  /// 0: 菜品页，1: 菜谱页，2: 我的页面
  int _currentTabIndex = 0;

  /// 各标签页的页面堆栈历史记录
  final List<List<PageRecord>> _tabHistories = [
    [], // 菜品页历史
    [], // 菜谱页历史
    [], // 我的页面历史
  ];

  /// 构造函数
  NavigationProvider();

  /// 当前选中的标签索引
  int get currentTabIndex => _currentTabIndex;

  /// 当前标签的历史记录
  List<PageRecord> get currentTabHistory => _tabHistories[_currentTabIndex];

  /// 设置当前选中的标签索引
  void setCurrentTabIndex(int index) {
    if (index >= 0 && index < 3 && index != _currentTabIndex) {
      _currentTabIndex = index;
      notifyListeners();
    }
  }

  /// 向当前标签页历史添加页面记录
  void pushPage(String pageName, {Map<String, dynamic>? arguments}) {
    _tabHistories[_currentTabIndex].add(PageRecord(
      pageName: pageName,
      arguments: arguments,
    ));
  }

  /// 从当前标签页历史弹出页面
  bool popPage() {
    if (_tabHistories[_currentTabIndex].isNotEmpty) {
      _tabHistories[_currentTabIndex].removeLast();
      return true;
    }
    return false;
  }

  /// 清空当前标签页历史
  void clearCurrentTabHistory() {
    _tabHistories[_currentTabIndex].clear();
    notifyListeners();
  }

  /// 获取当前页面记录（最后一个）
  PageRecord? get currentPage {
    final history = _tabHistories[_currentTabIndex];
    return history.isNotEmpty ? history.last : null;
  }

  /// 处理Android返回按钮
  bool handleBackButton() {
    // 如果当前标签有页面历史，弹出历史
    if (popPage()) {
      notifyListeners();
      return true; // 已处理返回按钮
    }

    // 如果当前是菜品页（索引0）且没有历史，则退出应用
    if (_currentTabIndex == 0) {
      return false; // 不处理，让系统处理
    } else {
      // 切换到菜品页
      setCurrentTabIndex(0);
      return true; // 已处理返回按钮
    }
  }

  /// 是否可以在当前标签页返回
  bool get canGoBack {
    return _tabHistories[_currentTabIndex].isNotEmpty;
  }

  /// 重置导航状态
  void reset() {
    _currentTabIndex = 0;
    for (final history in _tabHistories) {
      history.clear();
    }
    notifyListeners();
  }
}

/// 页面记录类
class PageRecord {
  final String pageName;
  final Map<String, dynamic>? arguments;

  PageRecord({
    required this.pageName,
    this.arguments,
  });

  @override
  String toString() => 'PageRecord(pageName: $pageName, arguments: $arguments)';
}