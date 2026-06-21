# 菜品详情页 (DishDetailPage) - 产品需求文档

## Overview
- **Summary**: 菜品详情页是 RecipeLedger 应用的菜品信息展示页，负责展示菜品的图片、名称、价格、城市/分类等基本信息，以及提供指定时间段内的价格趋势图表。
- **Purpose**: 为用户提供菜品的完整信息和价格走势分析，帮助用户了解菜品价格波动情况。
- **Target Users**: 普通用户、厨师、采购人员等需要了解菜品详细信息和价格趋势的人群。

## Goals
- [x] 展示菜品图片（轮播形式）
- [x] 展示菜品名称、价格
- [x] 展示菜品基本信息（城市、分类）
- [x] 展示价格趋势图表
- [x] 支持自定义日期范围筛选价格数据
- [x] 支持价格单位切换（由全局设置控制）
- [x] 支持返回上一级页面

## Non-Goals (Out of Scope)
- [ ] 菜品编辑功能
- [ ] 菜品删除功能
- [ ] 菜品添加菜谱功能
- [ ] 分享菜品功能
- [ ] 收藏菜品功能
- [ ] 评论菜品功能

## Background & Context
- 菜品详情页是用户从菜品列表页点击菜品卡片后进入的页面
- 页面采用 Flutter + Provider 架构，图片使用本地资源
- 详情页集成 PriceTrendChart 组件展示价格趋势
- 详情页使用 DateRangePicker 组件让用户选择价格查询的时间段
- 页面整体设计风格与列表页保持一致

## Functional Requirements
- **FR-1**: 页面接收菜品ID参数，根据ID加载菜品详情数据
- **FR-2**: 顶部展示菜品图片轮播，支持自动播放，3秒切换一次
- **FR-3**: 轮播图下方展示指示器，标识当前展示的图片
- **FR-4**: 展示菜品名称（大字体）
- **FR-5**: 展示菜品当前价格（红色，遵循全局价格单位设置）
- **FR-6**: 展示菜品基本信息标签：城市、分类
- **FR-7**: 展示价格趋势图表（默认展示最近7天数据）
- **FR-8**: 支持点击日期范围选择器自定义价格查询时间段
- **FR-9**: 支持快捷选择"近7天"、"近30天"
- **FR-10**: 价格趋势图表支持下拉显示数据点对应的日期和价格
- **FR-11**: 页面顶部有返回按钮，支持返回上一级
- **FR-12**: 页面支持加载中、加载失败、菜品不存在、加载完成四种状态

## Non-Functional Requirements
- **NFR-1**: 页面加载时间 < 2秒（首次加载）
- **NFR-2**: 轮播图切换流畅，无卡顿
- **NFR-3**: 价格趋势图表渲染时间 < 1秒
- **NFR-4**: 适配不同屏幕尺寸和分辨率
- **NFR-5**: 支持离线浏览已缓存的菜品数据

## Constraints
- **Technical**: Flutter 3.x、Dart 3.x、Provider 状态管理、carousel_slider 图片轮播、fl_chart 图表库、syncfusion_flutter_datepicker 日期选择
- **Business**: 价格趋势查询的最大时间范围由后端接口限制
- **Dependencies**: 依赖 DishProvider、DishService、PriceTrendChart、DateRangePicker 组件

## Assumptions
- [x] 用户已选择城市/区域（由 AppProvider 管理）
- [x] 用户已设置价格单位偏好（由 AppProvider 管理）
- [x] 菜品列表中每个菜品都有唯一的 dishId
- [x] 菜品图片资源为本地资源（assets/demo.jpeg），后续可扩展为网络图片

## Acceptance Criteria

### AC-1: 页面初始化加载
- **Given**: 用户从菜品列表页点击某个菜品
- **When**: 跳转到菜品详情页
- **Then**: 显示加载动画，加载完成后展示菜品详情
- **Verification**: `human-judgment`

### AC-2: 图片轮播
- **Given**: 页面已加载完成
- **When**: 用户查看菜品图片
- **Then**: 图片自动轮播，每3秒切换一次，下方显示指示器
- **Verification**: `human-judgment`

### AC-3: 菜品名称和价格显示
- **Given**: 页面已加载完成
- **When**: 页面展示菜品基本信息
- **Then**: 菜品名称以大字体显示，价格以红色显示并附带单位
- **Verification**: `human-judgment`

### AC-4: 城市和分类标签
- **Given**: 页面已加载完成
- **When**: 页面展示菜品基本信息
- **Then**: 城市和分类以灰色标签形式显示
- **Verification**: `human-judgment`

### AC-5: 价格趋势图表
- **Given**: 页面已加载完成
- **When**: 页面展示价格趋势
- **Then**: 默认展示最近7天的价格趋势折线图
- **Verification**: `human-judgment`

### AC-6: 自定义日期范围
- **Given**: 页面已加载完成
- **When**: 用户点击日期范围选择器
- **Then**: 弹出日期范围选择对话框，用户可以选择起止日期
- **Verification**: `human-judgment`

### AC-7: 快捷日期选择
- **Given**: 日期范围选择对话框已打开
- **When**: 用户点击"近7天"或"近30天"按钮
- **Then**: 自动选择对应时间范围，点击确定后图表刷新
- **Verification**: `human-judgment`

### AC-8: 返回按钮
- **Given**: 用户在菜品详情页
- **When**: 用户点击左上角返回按钮
- **Then**: 返回到上一级页面（菜品列表页）
- **Verification**: `human-judgment`

### AC-9: 价格单位切换
- **Given**: 用户在全局设置中更改了价格单位
- **When**: 菜品详情页展示价格
- **Then**: 价格自动按照新的单位显示
- **Verification**: `human-judgment`

### AC-10: 加载失败状态
- **Given**: 网络连接不可用或菜品不存在
- **When**: 页面尝试加载菜品数据
- **Then**: 显示对应的错误提示信息
- **Verification**: `human-judgment`

### AC-11: 价格趋势数据点
- **Given**: 价格趋势图表已加载
- **When**: 用户点击图表上的数据点
- **Then**: 显示该数据点对应的日期和价格
- **Verification**: `human-judgment`

### AC-12: 空数据状态
- **Given**: 指定日期范围内没有价格数据
- **When**: 页面展示价格趋势
- **Then**: 显示"暂无价格数据"提示
- **Verification**: `human-judgment`

## Open Questions
- [ ] 是否需要支持菜品图片全屏预览？
- [ ] 是否需要支持菜品的多个价格来源对比？
- [ ] 是否需要支持价格预警功能？
