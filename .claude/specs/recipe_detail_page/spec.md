# 菜谱详情页 (RecipeDetailPage) - 产品需求文档

## Overview
- Summary: 菜谱详情页是 RecipeLedger 应用的菜谱详情展示页面，用于展示菜谱的完整信息，包括封面、名称、原材料、做法步骤和注意事项。
- Purpose: 为用户提供菜谱的完整查看体验，支持编辑和删除操作。
- Target Users: 需要查看菜谱详情的应用用户。

## Goals
- [x] 展示菜谱封面图片
- [x] 展示菜谱名称和更新时间
- [x] 展示原材料列表和成本计算
- [x] 展示做法步骤（富文本）
- [x] 展示注意事项（富文本，可选）
- [x] 支持编辑菜谱
- [x] 支持删除菜谱

## Non-Goals (Out of Scope)
- [ ] 菜谱分享功能
- [ ] 菜谱收藏功能
- [ ] 菜谱评论功能
- [ ] 菜谱打印功能

## Background & Context
- 菜谱详情页是从菜谱网格页点击菜谱卡片跳转进入的页面
- 页面采用 Flutter + Provider 架构，使用 Hive 做本地存储
- 页面使用 flutter_quill 实现富文本展示（只读模式）
- 页面顶部展示封面图片，覆盖状态栏
- 页面包含浮动操作按钮：返回、编辑、删除

## Functional Requirements
- FR-1: 页面接收 recipeId 参数，加载并展示对应菜谱
- FR-2: 顶部展示封面图片（网络图片或本地文件）
- FR-3: 无封面时显示默认图标
- FR-4: 浮动操作按钮包含返回、编辑、删除三个按钮
- FR-5: 展示菜谱名称和更新时间
- FR-6: 展示原材料列表，包含名称、用量和成本
- FR-7: 菜品类型原材料显示成本，自定义类型不显示
- FR-8: 展示原材料合计成本
- FR-9: 展示做法步骤（只读富文本）
- FR-10: 展示注意事项（只读富文本，可选）
- FR-11: 点击编辑按钮跳转到菜谱编辑页
- FR-12: 编辑页返回后自动刷新详情
- FR-13: 点击删除按钮弹出确认对话框
- FR-14: 确认删除后删除菜谱并返回列表
- FR-15: 删除成功显示提示
- FR-16: 删除失败显示错误提示
- FR-17: 菜谱不存在时显示提示

## Non-Functional Requirements
- NFR-1: 页面加载时间 < 2秒
- NFR-2: 富文本展示流畅无卡顿
- NFR-3: 适配不同屏幕尺寸

## Constraints
- Technical: Flutter 3.x、Dart 3.x、Provider、flutter_quill
- Business: 删除菜谱需要二次确认
- Dependencies: RecipeProvider、DishProvider、RecipeEditPage

## Assumptions
- [x] 菜谱数据存储在本地 Hive 中
- [x] 菜品数据通过 DishProvider 获取
- [x] 成本计算基于菜品价格和用量

## Acceptance Criteria

### AC-1: 页面初始化
- Given: 用户从菜谱网格页点击菜谱卡片
- When: 跳转到菜谱详情页
- Then: 页面正常加载并显示菜谱信息
- Verification: human-judgment

### AC-2: 菜谱不存在
- Given: recipeId 对应的菜谱不存在
- When: 页面加载
- Then: 显示菜谱不存在提示
- Verification: human-judgment

### AC-3: 封面图片展示
- Given: 菜谱有封面图片
- When: 页面显示
- Then: 顶部展示封面图片，覆盖状态栏
- Verification: human-judgment

### AC-4: 默认封面
- Given: 菜谱无封面图片
- When: 页面显示
- Then: 显示默认菜单书图标
- Verification: human-judgment

### AC-5: 返回按钮
- Given: 用户在菜谱详情页
- When: 用户点击返回按钮
- Then: 返回上一页
- Verification: human-judgment

### AC-6: 编辑按钮
- Given: 用户在菜谱详情页
- When: 用户点击编辑按钮
- Then: 跳转到菜谱编辑页
- Verification: human-judgment

### AC-7: 编辑返回刷新
- Given: 用户在编辑页修改并保存菜谱
- When: 用户返回详情页
- Then: 详情页自动刷新显示最新数据
- Verification: human-judgment

### AC-8: 删除确认
- Given: 用户在菜谱详情页
- When: 用户点击删除按钮
- Then: 弹出确认删除对话框
- Verification: human-judgment

### AC-9: 删除操作
- Given: 用户确认删除
- When: 点击删除按钮
- Then: 删除菜谱并返回上一页
- Verification: human-judgment

### AC-10: 删除成功提示
- Given: 菜谱删除成功
- When: 返回上一页
- Then: 显示菜谱已删除提示
- Verification: human-judgment

### AC-11: 删除失败提示
- Given: 菜谱删除失败
- When: 删除过程
- Then: 显示删除失败提示
- Verification: human-judgment

### AC-12: 菜谱名称展示
- Given: 菜谱有名称
- When: 页面显示
- Then: 菜谱名称正确显示，不超过2行
- Verification: human-judgment

### AC-13: 更新时间展示
- Given: 菜谱有更新时间
- When: 页面显示
- Then: 显示更新于 + 日期格式
- Verification: human-judgment

### AC-14: 原材料列表
- Given: 菜谱有原材料
- When: 页面显示
- Then: 原材料列表正确展示
- Verification: human-judgment

### AC-15: 原材料名称
- Given: 原材料为菜品类型
- When: 页面显示
- Then: 显示菜品名称（关联菜品库）
- Verification: human-judgment

### AC-16: 自定义原材料名称
- Given: 原材料为自定义类型
- When: 页面显示
- Then: 显示自定义名称
- Verification: human-judgment

### AC-17: 原材料用量
- Given: 原材料有用量
- When: 页面显示
- Then: 显示用量和单位
- Verification: human-judgment

### AC-18: 原材料成本
- Given: 原材料为菜品类型且菜品存在
- When: 页面显示
- Then: 显示该原材料的成本
- Verification: human-judgment

### AC-19: 成本计算
- Given: 原材料为菜品类型
- When: 页面计算成本
- Then: 根据菜品价格和用量（转换为斤）计算成本
- Verification: human-judgment

### AC-20: 合计成本
- Given: 有多个菜品类型原材料
- When: 页面显示
- Then: 显示原材料合计成本（红色字体）
- Verification: human-judgment

### AC-21: 空原材料提示
- Given: 菜谱无原材料
- When: 页面显示
- Then: 显示暂无原材料提示
- Verification: human-judgment

### AC-22: 做法步骤展示
- Given: 菜谱有做法步骤
- When: 页面显示
- Then: 以只读富文本形式展示做法步骤
- Verification: human-judgment

### AC-23: 注意事项展示
- Given: 菜谱有注意事项
- When: 页面显示
- Then: 以只读富文本形式展示注意事项
- Verification: human-judgment

### AC-24: 注意事项隐藏
- Given: 菜谱无注意事项
- When: 页面显示
- Then: 不显示注意事项区域
- Verification: human-judgment

### AC-25: 状态栏样式
- Given: 用户进入菜谱详情页
- When: 页面显示
- Then: 状态栏为透明，图标为深色
- Verification: human-judgment

## Open Questions
- [ ] 是否需要支持菜谱收藏功能？
- [ ] 是否需要支持菜谱分享功能？
- [ ] 是否需要支持成本单位切换（斤/公斤）？
