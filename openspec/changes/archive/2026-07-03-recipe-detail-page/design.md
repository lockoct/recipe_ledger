## Context

菜谱详情页是菜谱网格页的下一级页面，用户点击菜谱卡片后跳转进入。页面需要展示菜谱的完整信息，并提供编辑和删除操作入口。数据存储在本地 Hive 中，通过 `RecipeProvider` 和 `DishProvider` 进行数据访问。

技术栈：Flutter 3.x + Dart 3.x + Provider 状态管理 + Hive 本地存储 + flutter_quill 富文本。

## Goals / Non-Goals

**Goals:**
- 实现菜谱完整信息的展示（封面、名称、时间、原材料、做法、注意事项）
- 实现原材料成本计算（菜品价格 × 用量换算为斤）
- 实现编辑跳转与返回自动刷新
- 实现删除确认与执行
- 适配不同屏幕尺寸

**Non-Goals:**
- 菜谱分享、收藏、评论、打印功能
- 后端 API 交互（纯本地数据操作）
- 离线同步

## Decisions

### 1. 页面架构：StatefulWidget + Provider

页面使用 `StatefulWidget`，在 `initState` 中通过 `RecipeProvider` 加载菜谱数据。`DishProvider` 用于查询菜品信息以计算原材料成本。

**理由**：Provider 是项目已有的状态管理方案，保持一致；StatefulWidget 便于管理页面级生命周期（如编辑返回后的刷新）。

### 2. 封面图片展示策略

- 网络图片：使用 `Image.network` 加载
- 本地文件：使用 `Image.file` 加载
- 无封面：显示默认图标（Icons.menu_book）
- 封面区域覆盖状态栏，使用 `SafeArea` + 负 margin 或 `SliverAppBar` 实现

### 3. 富文本展示：flutter_quill 只读模式

做法步骤和注意事项使用 `QuillEditor` 的只读模式（`readOnly: true`），不显示工具栏。内容以 JSON 格式存储在 Hive 中。

**理由**：flutter_quill 是项目已使用的富文本方案，编辑页使用相同格式，无需转换。

### 4. 成本计算逻辑

- 菜品类型原材料：`成本 = 菜品单价 × (用量 / 菜品单位换算系数)`，将用量统一转换为"斤"计算
- 自定义类型原材料：不显示成本
- 合计成本：所有菜品类型原材料成本之和，红色字体显示

### 5. 编辑返回刷新机制

编辑页通过 `Navigator.push` 跳转，在 `await` 返回后调用数据刷新方法。使用 `then` 或 `async/await` 模式。

### 6. 删除流程

点击删除 → 弹出 `AlertDialog` 确认 → 调用 `RecipeProvider.deleteRecipe(recipeId)` → 成功则 `Navigator.pop` 并显示 SnackBar 提示 → 失败则显示错误 SnackBar。

### 7. 浮动操作按钮布局

使用 `Stack` + `Positioned` 布局三个圆形浮动按钮（返回、编辑、删除），位于页面右下角纵向排列。

## Risks / Trade-offs

- [风险] 菜谱数据量较大时，富文本渲染可能影响性能 → 使用 flutter_quill 只读模式，禁用交互和工具栏以减少开销
- [风险] 编辑页返回后数据不一致 → 编辑页返回时通过 `pop(true)` 传递刷新信号，详情页检测后重新加载数据
- [取舍] 成本计算在客户端进行，依赖 DishProvider 的菜品数据准确性 → 保持菜品数据与原材料数据同步更新