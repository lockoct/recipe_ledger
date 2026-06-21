# 菜谱网格页 (RecipeGridPage) - 产品需求文档

## Overview
- **Summary**: 菜谱网格页是 RecipeLedger 应用的菜谱管理页面，以两列网格形式展示菜谱，支持搜索、查看详情和添加新菜谱。
- **Purpose**: 为用户提供菜谱浏览、搜索、查看详情和创建菜谱的入口。
- **Target Users**: 所有应用用户，特别是需要创建和管理菜谱的用户。

## Goals
- [x] 以两列网格形式展示菜谱列表
- [x] 支持按菜谱名称搜索
- [x] 支持点击菜谱卡片进入详情页
- [x] 支持添加新菜谱
- [x] 支持空状态、加载状态、错误状态显示
- [x] 支持菜谱按更新时间排序

## Non-Goals (Out of Scope)
- [ ] 菜谱编辑功能（独立页面处理）
- [ ] 菜谱删除功能（详情页处理）
- [ ] 菜谱分享功能
- [ ] 菜谱收藏功能
- [ ] 菜谱分类筛选

## Background & Context
- 菜谱网格页是应用底部导航栏的三个标签页之一（菜品、菜谱、我的）
- 页面采用 Flutter + Provider 架构，使用 Hive 做本地存储
- 页面包含搜索栏、菜谱网格和浮动添加按钮
- 菜谱数据通过 RecipeProvider 管理

## Functional Requirements
- FR-1: 页面顶部展示搜索栏，背景为主题色
- FR-2: 搜索框采用圆角设计，白色背景
- FR-3: 支持输入关键词实时搜索菜谱
- FR-4: 搜索框右侧显示清除按钮（输入内容后）
- FR-5: 以两列网格形式展示菜谱
- FR-6: 每个菜谱卡片显示封面图片和菜谱名称
- FR-7: 封面图片支持网络图片和本地文件
- FR-8: 无封面时显示默认图标
- FR-9: 点击菜谱卡片跳转到菜谱详情页
- FR-10: 详情页修改后返回自动刷新列表
- FR-11: 右下角浮动添加按钮，点击进入菜谱编辑页
- FR-12: 编辑页添加成功后返回自动刷新列表
- FR-13: 菜谱按更新时间降序排序
- FR-14: 显示加载中状态
- FR-15: 显示加载失败状态和重试按钮
- FR-16: 显示空状态（暂无菜谱数据）
- FR-17: 状态栏颜色与主题色一致

## Non-Functional Requirements
- NFR-1: 页面加载时间 < 2秒
- NFR-2: 搜索响应时间 < 500ms
- NFR-3: 网格滚动流畅（FPS > 55）
- NFR-4: 适配不同屏幕尺寸

## Constraints
- Technical: Flutter 3.x、Dart 3.x、Provider、Hive
- Dependencies: RecipeProvider、RecipeService

## Assumptions
- [x] 菜谱数据存储在本地 Hive 中
- [x] 用户已进入主界面
- [x] 应用主题色已配置

## Acceptance Criteria

### AC-1: 页面初始化加载
- Given: 用户进入菜谱页
- When: 页面加载完成
- Then: 显示菜谱网格列表
- Verification: human-judgment

### AC-2: 搜索功能
- Given: 页面已加载完成
- When: 用户在搜索框输入菜谱名称
- Then: 网格实时更新为匹配的菜谱
- Verification: human-judgment

### AC-3: 搜索清除
- Given: 搜索框有内容
- When: 用户点击清除按钮
- Then: 搜索框清空，列表恢复显示所有菜谱
- Verification: human-judgment

### AC-4: 菜谱网格展示
- Given: 有菜谱数据
- When: 页面展示菜谱
- Then: 菜谱以两列网格形式展示
- Verification: human-judgment

### AC-5: 菜谱卡片显示
- Given: 菜谱有数据
- When: 网格展示菜谱
- Then: 每个卡片显示封面图片和菜谱名称
- Verification: human-judgment

### AC-6: 封面图片显示
- Given: 菜谱有封面图片
- When: 卡片展示封面
- Then: 网络图片使用Image.network，本地文件使用Image.file
- Verification: human-judgment

### AC-7: 默认图标
- Given: 菜谱无封面图片
- When: 卡片展示封面
- Then: 显示默认的菜单书图标
- Verification: human-judgment

### AC-8: 点击进入详情
- Given: 菜谱卡片已显示
- When: 用户点击菜谱卡片
- Then: 跳转到菜谱详情页
- Verification: human-judgment

### AC-9: 详情页返回刷新
- Given: 用户在菜谱详情页修改了菜谱
- When: 用户返回菜谱列表
- Then: 菜谱列表自动刷新显示最新数据
- Verification: human-judgment

### AC-10: 添加新菜谱
- Given: 用户在菜谱页
- When: 用户点击右下角浮动添加按钮
- Then: 跳转到菜谱编辑页
- Verification: human-judgment

### AC-11: 编辑页返回刷新
- Given: 用户在菜谱编辑页成功添加菜谱
- When: 用户返回菜谱列表
- Then: 菜谱列表自动刷新显示新菜谱
- Verification: human-judgment

### AC-12: 加载状态
- Given: 页面正在加载数据
- When: 加载过程
- Then: 显示加载动画和加载中文字
- Verification: human-judgment

### AC-13: 错误状态
- Given: 数据加载失败
- When: 页面展示错误
- Then: 显示错误图标、错误信息和重试按钮
- Verification: human-judgment

### AC-14: 空状态
- Given: 没有菜谱数据
- When: 页面展示列表
- Then: 显示菜单书图标和暂无菜谱数据文字
- Verification: human-judgment

### AC-15: 菜谱排序
- Given: 有多个菜谱
- When: 页面展示菜谱
- Then: 菜谱按更新时间降序排序
- Verification: human-judgment

### AC-16: 状态栏样式
- Given: 用户进入菜谱页
- When: 页面显示
- Then: 状态栏颜色与主题色一致
- Verification: human-judgment

## Open Questions
- [ ] 是否需要支持菜谱分类筛选？
- [ ] 是否需要支持菜谱置顶功能？
- [ ] 是否需要支持菜谱复制功能？
