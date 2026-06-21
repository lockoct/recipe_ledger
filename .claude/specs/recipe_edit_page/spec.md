# 菜谱编辑页 (RecipeEditPage) - 产品需求文档

## Overview
- Summary: 菜谱编辑页是 RecipeLedger 应用的菜谱创建和编辑页面，用于新增或编辑菜谱信息，包括封面、名称、原材料、做法步骤和注意事项。
- Purpose: 为用户提供创建新菜谱和编辑现有菜谱的入口，支持添加原材料、富文本编辑做法步骤和注意事项。
- Target Users: 需要创建和管理菜谱的应用用户。

## Goals
- [x] 支持新增菜谱
- [x] 支持编辑现有菜谱
- [x] 支持上传菜谱封面图片
- [x] 支持添加、编辑、删除原材料
- [x] 支持富文本编辑做法步骤
- [x] 支持富文本编辑注意事项
- [x] 支持菜谱提交保存

## Non-Goals (Out of Scope)
- [ ] 菜谱分享功能
- [ ] 菜谱复制功能
- [ ] 菜谱模板功能
- [ ] 自动配料推荐

## Background & Context
- 菜谱编辑页是从菜谱网格页跳转进入的页面
- 页面采用 Flutter + Provider 架构，使用 Hive 做本地存储
- 页面使用 flutter_quill 实现富文本编辑
- 页面使用 image_picker 实现图片选择
- 原材料使用 AddIngredientDialog 对话框添加

## Functional Requirements
- FR-1: 页面接收可选的 recipeId 参数，为空时表示新增，不为空时表示编辑
- FR-2: 页面顶部 AppBar 显示返回按钮和页面标题（新增菜谱/编辑菜谱）
- FR-3: 支持点击封面区域选择本地图片作为封面
- FR-4: 支持输入菜谱名称，必填项
- FR-5: 支持添加多个原材料
- FR-6: 原材料支持菜品类型（关联菜品库）和自定义类型
- FR-7: 原材料支持编辑和删除
- FR-8: 支持富文本编辑做法步骤
- FR-9: 支持富文本编辑注意事项（可选）
- FR-10: 富文本编辑器支持项目符号和数字列表
- FR-11: 富文本编辑器支持图片插入
- FR-12: 编辑器聚焦时显示工具栏
- FR-13: 支持提交保存菜谱
- FR-14: 提交时进行表单验证
- FR-15: 提交成功返回上一页并提示
- FR-16: 提交失败显示错误提示
- FR-17: 至少需要添加一个原材料

## Non-Functional Requirements
- NFR-1: 页面加载时间 < 2秒
- NFR-2: 富文本编辑流畅无卡顿
- NFR-3: 适配不同屏幕尺寸

## Constraints
- Technical: Flutter 3.x、Dart 3.x、Provider、flutter_quill、image_picker
- Business: 菜谱名称必填，至少需要一个原材料
- Dependencies: RecipeProvider、DishProvider、AddIngredientDialog

## Assumptions
- [x] 菜谱数据存储在本地 Hive 中
- [x] 菜品数据通过 DishProvider 获取
- [x] 用户有访问本地相册的权限

## Acceptance Criteria

### AC-1: 页面初始化
- Given: 用户从菜谱网格页点击添加或编辑
- When: 跳转到菜谱编辑页
- Then: 页面正常加载，显示编辑表单
- Verification: human-judgment

### AC-2: 新增和编辑模式
- Given: 用户进入菜谱编辑页
- When: 页面显示
- Then: 根据 recipeId 参数显示对应标题（新增菜谱或编辑菜谱）
- Verification: human-judgment

### AC-3: 编辑模式数据加载
- Given: recipeId 不为空
- When: 页面初始化
- Then: 加载并显示已有菜谱数据
- Verification: human-judgment

### AC-4: 返回按钮
- Given: 用户在菜谱编辑页
- When: 用户点击返回按钮
- Then: 返回上一页
- Verification: human-judgment

### AC-5: 上传封面
- Given: 用户在菜谱编辑页
- When: 用户点击封面区域
- Then: 打开图片选择器，选择后显示封面
- Verification: human-judgment

### AC-6: 显示封面
- Given: 已选择封面图片
- When: 页面显示
- Then: 封面区域显示选择的图片
- Verification: human-judgment

### AC-7: 输入菜谱名称
- Given: 用户在菜谱编辑页
- When: 用户在菜谱名称输入框中输入
- Then: 菜谱名称正确显示
- Verification: human-judgment

### AC-8: 名称验证
- Given: 用户提交菜谱
- When: 菜谱名称为空
- Then: 显示请输入菜谱名称的验证错误
- Verification: human-judgment

### AC-9: 添加原材料
- Given: 用户在菜谱编辑页
- When: 用户点击添加按钮
- Then: 弹出添加原材料对话框
- Verification: human-judgment

### AC-10: 原材料类型切换
- Given: 原材料对话框已打开
- When: 用户切换菜品/其他类型
- Then: 界面切换为对应类型的内容
- Verification: human-judgment

### AC-11: 选择菜品原材料
- Given: 原材料对话框选择菜品模式
- When: 用户搜索并选择菜品
- Then: 菜品被选中，可以输入用量
- Verification: human-judgment

### AC-12: 自定义原材料
- Given: 原材料对话框选择其他模式
- When: 用户输入原材料名称和用量
- Then: 可以提交自定义原材料
- Verification: human-judgment

### AC-13: 编辑原材料
- Given: 已添加原材料
- When: 用户点击原材料的编辑按钮
- Then: 弹出对话框并预填原材料信息
- Verification: human-judgment

### AC-14: 删除原材料
- Given: 已添加原材料
- When: 用户点击原材料的删除按钮
- Then: 该原材料从列表中移除
- Verification: human-judgment

### AC-15: 空原材料提示
- Given: 未添加任何原材料
- When: 页面显示
- Then: 显示暂无原材料，点击添加提示
- Verification: human-judgment

### AC-16: 富文本编辑做法步骤
- Given: 用户在做法步骤区域
- When: 用户点击并输入内容
- Then: 可以输入富文本内容
- Verification: human-judgment

### AC-17: 富文本工具栏
- Given: 富文本编辑器获得焦点
- When: 键盘弹出
- Then: 显示富文本工具栏（项目符号、数字列表、图片等）
- Verification: human-judgment

### AC-18: 插入图片到做法
- Given: 富文本编辑器聚焦
- When: 用户点击工具栏的图片按钮
- Then: 可以从相册选择图片插入
- Verification: human-judgment

### AC-19: 注意事项编辑
- Given: 用户在注意事项区域
- When: 用户点击并输入内容
- Then: 可以输入富文本内容（可选）
- Verification: human-judgment

### AC-20: 提交验证
- Given: 用户点击提交按钮
- When: 验证失败（名称为空或无原材料）
- Then: 显示对应的错误提示
- Verification: human-judgment

### AC-21: 提交保存
- Given: 表单验证通过
- When: 用户点击提交按钮
- Then: 显示加载状态，保存成功后返回上一页
- Verification: human-judgment

### AC-22: 保存成功提示
- Given: 菜谱保存成功
- When: 返回上一页
- Then: 显示菜谱创建成功或更新成功提示
- Verification: human-judgment

### AC-23: 保存失败提示
- Given: 菜谱保存失败
- When: 提交过程
- Then: 显示保存失败的错误提示
- Verification: human-judgment

### AC-24: 加载失败提示
- Given: 编辑模式加载菜谱
- When: 菜谱不存在
- Then: 显示加载失败提示
- Verification: human-judgment

## Open Questions
- [ ] 是否需要支持配料用量单位切换（克/千克）？
- [ ] 是否需要支持做法步骤插入视频？
- [ ] 是否需要支持菜谱导入导出？
