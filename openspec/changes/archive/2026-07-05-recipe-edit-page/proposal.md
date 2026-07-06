## Why

用户需要一个完整的菜谱编辑页面来创建和修改菜谱。当前应用缺少统一的新增/编辑入口，用户无法方便地录入菜谱名称、封面、原材料、做法步骤和注意事项。作为菜谱管理应用的核心功能，菜谱编辑是连接菜品库和菜谱展示的关键环节。

## What Changes

- 新增菜谱编辑页面，支持新增和编辑两种模式
- 支持选择/更换菜谱封面图片（从本地相册选取）
- 支持输入菜谱名称并进行必填验证
- 支持原材料管理：添加、编辑、删除，支持关联菜品库和自定义输入两种类型
- 集成 flutter_quill 富文本编辑器，用于做法步骤和注意事项的编辑
- 富文本编辑器支持项目符号、数字列表和图片插入
- 表单提交时进行完整性验证（名称必填、至少一个原材料）
- 提交成功后返回上一页并显示提示

## Capabilities

### New Capabilities
- `recipe-edit-form`: 菜谱编辑表单，包含封面选择、名称输入、新增/编辑模式切换、表单验证和提交
- `ingredient-management`: 原材料管理，支持从菜品库选择或自定义输入，支持编辑和删除
- `rich-text-editing`: 基于 flutter_quill 的富文本编辑，用于做法步骤和注意事项，支持列表和图片插入

### Modified Capabilities
<!-- 无现有能力需要修改 -->

## Impact

- 新增 `recipe_edit_page.dart` 页面组件
- 新增 `AddIngredientDialog` 对话框组件
- 新增 `RecipeIngredient` 数据模型
- 依赖 `RecipeProvider`、`DishProvider` 状态管理
- 依赖 `flutter_quill`、`image_picker` 第三方包
- 路由注册：从菜谱详情页跳转进入