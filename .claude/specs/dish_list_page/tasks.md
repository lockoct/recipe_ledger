# 菜品列表页 - 实现计划（分解和优先级任务列表）

## [x] Task 1: 菜品列表页面框架搭建
- **Priority**: P0
- **Depends On**: None
- **Description**: 
  - 创建 `dish_list_page.dart` 页面组件
  - 配置页面状态管理（StatefulWidget）
  - 搭建整体布局结构（搜索栏 + 分类筛选栏 + 列表内容）
  - 集成 Provider 状态管理
- **Acceptance Criteria Addressed**: [AC-1]
- **Test Requirements**:
  - `human-judgement` TR-1.1: 页面能正常启动，显示基本布局结构
  - `human-judgement` TR-1.2: 页面状态管理配置正确，Provider 能正常注入
- **Notes**: 需要确保页面在 initState 时自动触发数据加载

## [x] Task 2: 菜品搜索栏组件实现
- **Priority**: P0
- **Depends On**: Task 1
- **Description**: 
  - 创建 `dish_search_bar.dart` 组件
  - 实现搜索框 UI（圆弧设计，白色背景）
  - 实现实时搜索功能（输入时触发）
  - 实现搜索清除按钮
  - 集成城市选择功能
- **Acceptance Criteria Addressed**: [AC-2]
- **Test Requirements**:
  - `human-judgement` TR-2.1: 搜索框 UI 符合设计要求
  - `human-judgement` TR-2.2: 输入关键词时列表实时更新
  - `human-judgement` TR-2.3: 清除按钮能清空搜索并重置列表
- **Notes**: 搜索回调需要调用 Provider 的 search 方法

## [x] Task 3: 分类筛选栏组件实现
- **Priority**: P0
- **Depends On**: Task 1
- **Description**: 
  - 创建 `category_filter_bar.dart` 组件
  - 实现横向滑动分类列表
  - 实现分类标签选中状态高亮
  - 实现展开按钮
- **Acceptance Criteria Addressed**: [AC-3]
- **Test Requirements**:
  - `human-judgement` TR-3.1: 分类列表横向滑动正常
  - `human-judgement` TR-3.2: 点击分类标签能切换选中状态
  - `human-judgement` TR-3.3: 选中标签样式正确（高亮、边框）
- **Notes**: 分类数据从 DishCategories 常量获取

## [x] Task 4: 分类筛选覆盖层组件实现
- **Priority**: P1
- **Depends On**: Task 3
- **Description**: 
  - 创建 `category_filter_overlay.dart` 组件
  - 实现遮罩层（半透明，点击可收起）
  - 实现分类网格（一行3个）
  - 实现收起按钮
- **Acceptance Criteria Addressed**: [AC-4]
- **Test Requirements**:
  - `human-judgement` TR-4.1: 点击展开按钮显示覆盖层
  - `human-judgement` TR-4.2: 分类网格布局正确（一行3个）
  - `human-judgement` TR-4.3: 点击遮罩或收起按钮能关闭覆盖层
- **Notes**: 覆盖层使用 Stack 布局，从搜索栏下方开始

## [x] Task 5: 菜品卡片组件实现
- **Priority**: P0
- **Depends On**: Task 1
- **Description**: 
  - 实现菜品卡片 UI（图标、名称、价格、变化）
  - 实现价格变化显示（箭头 + 颜色）
  - 实现点击跳转详情页
- **Acceptance Criteria Addressed**: [AC-5, AC-6, AC-8]
- **Test Requirements**:
  - `human-judgement` TR-5.1: 卡片布局正确（左图标、中信息、右变化）
  - `human-judgement` TR-5.2: 价格变化显示正确（红色上涨、绿色下跌）
  - `human-judgement` TR-5.3: 点击卡片能跳转到详情页
- **Notes**: 使用 PriceDisplay 组件显示价格

## [x] Task 6: 分页加载功能实现
- **Priority**: P0
- **Depends On**: Task 1
- **Description**: 
  - 实现分页逻辑（Pagination 类）
  - 实现滚动加载更多（ListView.builder）
  - 实现加载更多动画
- **Acceptance Criteria Addressed**: [AC-7]
- **Test Requirements**:
  - `human-judgement` TR-6.1: 滚动到列表底部自动加载下一页
  - `human-judgement` TR-6.2: 加载完成后数据追加到列表
  - `human-judgement` TR-6.3: 没有更多数据时不再触发加载
- **Notes**: 使用 FutureBuilder 处理异步数据加载

## [x] Task 7: 网络请求与缓存实现
- **Priority**: P0
- **Depends On**: None
- **Description**: 
  - 在 `dish_service.dart` 中实现 `getList` 方法
  - 实现网络请求（调用 `/dish/getPage` 接口）
  - 实现本地缓存（Hive）
  - 实现网络失败降级逻辑
- **Acceptance Criteria Addressed**: [AC-9]
- **Test Requirements**:
  - `human-judgement` TR-7.1: 网络正常时能获取并展示数据
  - `human-judgement` TR-7.2: 网络失败时能显示缓存数据
  - `human-judgement` TR-7.3: 显示加载失败提示和重新加载按钮
- **Notes**: 缓存数据使用 DishListItem 模型存储

## [x] Task 8: Provider 状态管理实现
- **Priority**: P0
- **Depends On**: Task 7
- **Description**: 
  - 在 `dish_provider.dart` 中实现状态管理
  - 实现查询条件管理（DishQueryForm）
  - 实现分页状态管理
  - 实现搜索、分类筛选、区域筛选方法
- **Acceptance Criteria Addressed**: [AC-2, AC-3, AC-7]
- **Test Requirements**:
  - `human-judgement` TR-8.1: 查询条件能正确传递到服务层
  - `human-judgement` TR-8.2: 分页状态正确更新
  - `human-judgement` TR-8.3: 状态变化能触发 UI 更新（notifyListeners）
- **Notes**: Provider 使用 ChangeNotifier

## [x] Task 9: 空状态和错误状态处理
- **Priority**: P1
- **Depends On**: Task 6
- **Description**: 
  - 实现空状态显示（暂无菜品数据）
  - 实现加载错误状态显示（加载失败提示 + 重新加载按钮）
  - 实现加载中状态显示（CircularProgressIndicator）
- **Acceptance Criteria Addressed**: [AC-1, AC-9, AC-10]
- **Test Requirements**:
  - `human-judgement` TR-9.1: 数据为空时显示"暂无菜品数据"
  - `human-judgement` TR-9.2: 加载失败时显示错误信息和重新加载按钮
  - `human-judgement` TR-9.3: 加载中显示进度指示器
- **Notes**: 使用 FutureBuilder 的 connectionState 和 hasError 判断

## [x] Task 10: 模型定义与序列化
- **Priority**: P0
- **Depends On**: None
- **Description**: 
  - 创建 `dish_list_item.dart` 模型类
  - 配置 JSON 序列化（json_annotation）
  - 配置 Hive 存储（HiveObject）
  - 生成 `.g.dart` 文件
- **Acceptance Criteria Addressed**: [AC-1, AC-5]
- **Test Requirements**:
  - `human-judgement` TR-10.1: 模型字段完整（dishId, name, categoryId, cover, price, region, dailyChange, monthlyChange）
  - `human-judgement` TR-10.2: JSON 序列化/反序列化正常
  - `human-judgement` TR-10.3: Hive 存储正常
- **Notes**: 运行 `flutter pub run build_runner build` 生成代码
