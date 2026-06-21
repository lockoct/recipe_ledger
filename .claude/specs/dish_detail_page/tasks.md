# 菜品详情页 (DishDetailPage) - 实现计划

## [x] Task 1: 菜品详情页面框架搭建
- **Priority**: P0
- **Depends On**: None
- **Description**: 
  - 创建 `dish_detail_page.dart` 页面组件
  - 配置 StatefulWidget，接收 dishId 参数
  - 搭建整体布局结构（图片轮播 + 名称价格 + 信息 + 价格趋势）
  - 集成 Provider 状态管理
- **Acceptance Criteria Addressed**: [AC-1, AC-8]
- **Test Requirements**:
  - `human-judgement` TR-1.1: 页面能正常启动，根据 dishId 加载数据
  - `human-judgement` TR-1.2: 页面布局结构清晰，支持返回

## [x] Task 2: 图片轮播组件实现
- **Priority**: P0
- **Depends On**: Task 1
- **Description**: 
  - 使用 carousel_slider 实现图片轮播
  - 配置自动播放（3秒间隔）
  - 实现轮播图指示器
  - 高度自适应（280 + statusBarHeight）
- **Acceptance Criteria Addressed**: [AC-2]
- **Test Requirements**:
  - `human-judgement` TR-2.1: 图片轮播自动播放正常
  - `human-judgement` TR-2.2: 指示器显示当前图片位置

## [x] Task 3: 菜品名称和价格显示
- **Priority**: P0
- **Depends On**: Task 1
- **Description**: 
  - 显示菜品名称（titleLarge 大字体）
  - 显示价格（红色，按用户设置单位转换）
  - 价格单位由 AppProvider 控制
- **Acceptance Criteria Addressed**: [AC-3, AC-9]
- **Test Requirements**:
  - `human-judgement` TR-3.1: 菜品名称显示正确
  - `human-judgement` TR-3.2: 价格按设置单位正确显示

## [x] Task 4: 菜品基本信息标签
- **Priority**: P0
- **Depends On**: Task 1
- **Description**: 
  - 显示城市、分类信息标签
  - 使用灰色背景的标签样式
- **Acceptance Criteria Addressed**: [AC-4]
- **Test Requirements**:
  - `human-judgement` TR-4.1: 城市和分类标签显示正确

## [x] Task 5: 价格趋势图表集成
- **Priority**: P0
- **Depends On**: Task 1
- **Description**: 
  - 集成 PriceTrendChart 组件
  - 默认展示最近7天数据
  - 传递 dishId、region、startDate、endDate 参数
- **Acceptance Criteria Addressed**: [AC-5, AC-12]
- **Test Requirements**:
  - `human-judgement` TR-5.1: 价格趋势图表正常渲染
  - `human-judgement` TR-5.2: 无数据时显示"暂无价格数据"

## [x] Task 6: 日期范围选择器集成
- **Priority**: P0
- **Depends On**: Task 5
- **Description**: 
  - 集成 showDateRangePickerBottomSheet
  - 实现日期范围选择回调
  - 选择后刷新价格趋势图表
- **Acceptance Criteria Addressed**: [AC-6, AC-7]
- **Test Requirements**:
  - `human-judgement` TR-6.1: 点击日期范围选择器弹出选择对话框
  - `human-judgement` TR-6.2: 选择日期范围后图表正确刷新

## [x] Task 7: 页面状态处理
- **Priority**: P1
- **Depends On**: Task 1
- **Description**: 
  - 实现加载中状态（带 AppBar）
  - 实现加载失败状态
  - 实现菜品不存在状态
  - 实现加载完成状态
- **Acceptance Criteria Addressed**: [AC-10]
- **Test Requirements**:
  - `human-judgement` TR-7.1: 加载中显示进度指示器
  - `human-judgement` TR-7.2: 加载失败显示错误信息
  - `human-judgement` TR-7.3: 菜品不存在显示对应提示

## [x] Task 8: 返回按钮实现
- **Priority**: P0
- **Depends On**: Task 1
- **Description**: 
  - 实现左上角浮动返回按钮
  - 使用半透明白色圆形背景
  - 点击返回上一级页面
- **Acceptance Criteria Addressed**: [AC-8]
- **Test Requirements**:
  - `human-judgement` TR-8.1: 返回按钮位置和样式正确
  - `human-judgement` TR-8.2: 点击返回能正确返回上一级

## [x] Task 9: Dish 模型定义
- **Priority**: P0
- **Depends On**: None
- **Description**: 
  - 定义 Dish 模型类
  - 包含字段：dishId、categoryId、name、price、region、cover
  - 配置 Hive 存储和 JSON 序列化
- **Acceptance Criteria Addressed**: [AC-3, AC-4]
- **Test Requirements**:
  - `human-judgement` TR-9.1: Dish 模型字段完整
  - `human-judgement` TR-9.2: 序列化和反序列化正常
