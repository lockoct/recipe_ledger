# 菜品列表页 - 产品需求文档

## Overview
- **Summary**: 菜品列表页是 RecipeLedger 应用的核心页面，负责展示菜品列表、支持搜索和分类筛选、显示价格及价格变化趋势，并支持分页加载。
- **Purpose**: 提供用户浏览和筛选菜品的入口，展示菜品价格信息和价格变化趋势，引导用户进入菜品详情页。
- **Target Users**: 普通用户、厨师、采购人员等需要了解菜品价格信息的人群。

## Goals
- [x] 展示菜品列表，支持分页加载
- [x] 支持按菜品名称搜索
- [x] 支持按分类筛选
- [x] 显示菜品价格及价格变化（较昨日、较上月）
- [x] 支持下拉刷新和加载更多
- [x] 点击菜品卡片进入详情页
- [x] 网络失败时显示缓存数据

## Non-Goals (Out of Scope)
- [ ] 菜品详情编辑功能
- [ ] 价格历史图表展示（详情页功能）
- [ ] 批量操作功能
- [ ] 导出功能

## Background & Context
- 菜品列表页是应用的首页，用户进入应用首先看到的页面
- 页面采用 Flutter + Provider 架构，使用 Hive 做本地缓存
- 后端接口使用 MyBatis-Plus 实现分页查询
- 页面包含多个子组件：搜索栏、分类筛选栏、分类筛选覆盖层、菜品卡片

## Functional Requirements
- **FR-1**: 页面初始化时自动加载第一页菜品列表数据
- **FR-2**: 支持按菜品名称实时搜索（输入时触发）
- **FR-3**: 支持按分类筛选菜品（横向滑动列表 + 展开网格）
- **FR-4**: 每个菜品卡片显示：菜品图标、名称、价格、较昨日变化、较上月变化
- **FR-5**: 支持分页加载更多数据（滚动到底部自动触发）
- **FR-6**: 支持下拉刷新重新加载数据
- **FR-7**: 点击菜品卡片跳转至菜品详情页
- **FR-8**: 网络请求失败时自动从本地缓存读取数据

## Non-Functional Requirements
- **NFR-1**: 页面加载时间 < 2秒（首次加载）
- **NFR-2**: 搜索响应时间 < 500ms
- **NFR-3**: 支持离线浏览（使用本地缓存）
- **NFR-4**: 列表滚动流畅（FPS > 55）
- **NFR-5**: 适配不同屏幕尺寸和分辨率

## Constraints
- **Technical**: Flutter 3.x、Dart 3.x、Provider 状态管理、Hive 本地缓存、Dio 网络请求
- **Business**: 后端分页接口限制，每页最多10条数据
- **Dependencies**: 依赖后端 `/dish/getPage` 接口

## Assumptions
- [x] 用户已选择城市/区域（由 AppProvider 管理）
- [x] 分类数据已在前端常量中定义（DishCategories）
- [x] 网络请求异常时自动降级到本地缓存

## Acceptance Criteria

### AC-1: 页面初始化加载
- **Given**: 用户打开应用进入菜品列表页
- **When**: 页面初始化完成
- **Then**: 显示加载动画，加载完成后展示菜品列表
- **Verification**: `human-judgment`

### AC-2: 搜索功能
- **Given**: 页面已加载完成
- **When**: 用户在搜索框输入菜品名称关键词
- **Then**: 列表实时更新为匹配的菜品，搜索框显示清除按钮
- **Verification**: `human-judgment`

### AC-3: 分类筛选（横向列表）
- **Given**: 页面已加载完成
- **When**: 用户点击分类标签
- **Then**: 列表更新为对应分类的菜品，选中标签高亮显示
- **Verification**: `human-judgment`

### AC-4: 分类筛选（展开网格）
- **Given**: 页面已加载完成
- **When**: 用户点击展开按钮
- **Then**: 显示分类网格覆盖层（一行3个），点击分类后收起并更新列表
- **Verification**: `human-judgment`

### AC-5: 菜品卡片显示
- **Given**: 页面已加载完成
- **When**: 列表展示菜品数据
- **Then**: 每个卡片显示图标、名称、价格、较昨日变化、较上月变化
- **Verification**: `human-judgment`

### AC-6: 价格变化显示
- **Given**: 菜品有价格变化数据
- **When**: 卡片展示价格变化
- **Then**: 价格上涨显示红色向上箭头，价格下跌显示绿色向下箭头
- **Verification**: `human-judgment`

### AC-7: 分页加载
- **Given**: 页面已加载完成且有更多数据
- **When**: 用户滚动到列表底部
- **Then**: 自动加载下一页数据并追加到列表
- **Verification**: `human-judgment`

### AC-8: 点击跳转详情
- **Given**: 用户点击某个菜品卡片
- **When**: 点击事件触发
- **Then**: 跳转到菜品详情页，传递菜品ID
- **Verification**: `human-judgment`

### AC-9: 网络失败降级
- **Given**: 网络连接不可用
- **When**: 页面尝试加载数据
- **Then**: 显示加载失败提示和重新加载按钮，同时显示缓存数据
- **Verification**: `human-judgment`

### AC-10: 空状态显示
- **Given**: 没有匹配的菜品数据
- **When**: 搜索或筛选结果为空
- **Then**: 显示"暂无菜品数据"提示
- **Verification**: `human-judgment`

## Open Questions
- [ ] 是否需要支持按价格排序？
- [ ] 是否需要支持收藏菜品功能？
- [ ] 是否需要支持分享菜品功能？
