## Context

菜谱网格页是 RecipeLedger 应用底部导航栏的菜谱标签页，需要提供菜谱浏览、搜索和创建入口。页面采用 Flutter + Provider 架构，菜谱数据通过 Hive 本地持久化。页面需要与菜谱详情页（RecipeDetailPage）和菜谱编辑页（RecipeEditPage）协调导航。

## Goals / Non-Goals

**Goals:**
- 实现两列网格布局的菜谱浏览页面
- 实现实时搜索功能，按菜谱名称筛选
- 实现菜谱卡片组件，支持封面图和默认图标
- 实现与详情页、编辑页的导航和返回刷新
- 实现加载中、加载失败、空状态三种状态展示
- 通过 RecipeProvider 统一管理菜谱数据状态

**Non-Goals:**
- 不涉及菜谱编辑功能（由 RecipeEditPage 处理）
- 不涉及菜谱删除功能（由详情页处理）
- 不涉及菜谱分类筛选
- 不涉及菜谱分享/收藏

## Decisions

### 1. 状态管理：Provider + ChangeNotifier
**决策**: 使用 RecipeProvider 继承 ChangeNotifier，通过 Provider 包注入到 Widget 树。

**理由**: 与项目已有的 Provider 架构保持一致，ChangeNotifier 模式简单直接，适合此页面的状态管理复杂度。页面通过 Consumer widget 监听 filteredRecipes 变化自动刷新。

**备选方案**: 考虑过 Riverpod，但会增加依赖复杂度，且当前场景无需 Riverpod 的额外特性（如自动 dispose、family 等）。

### 2. 网格布局：GridView.builder + SliverGridDelegateWithFixedCrossAxisCount
**决策**: 使用 GridView.builder 配合 SliverGridDelegateWithFixedCrossAxisCount 实现两列固定网格。

**理由**: GridView.builder 按需构建子项，适合菜谱列表数量不确定的场景。SliverGridDelegateWithFixedCrossAxisCount 提供固定列数布局，crossAxisCount 设为 2 实现两列。

**子项宽高比**: childAspectRatio 设为 1.05，使卡片高度略大于宽度，为封面图（120px）和名称区域留出空间。

### 3. 封面图加载：条件判断选择 Image.network / Image.file
**决策**: 在 Widget build 中根据 coverImage 字段是否以 "http" 开头，动态选择 Image.network 或 Image.file。

**理由**: 菜谱封面可能来自网络图片或本地文件，需要在同一个 Image 位置动态切换。使用条件表达式在 build 中判断，无需额外组件封装。

**备选方案**: 考虑过使用 CachedNetworkImage 缓存网络图片，但当前阶段不引入额外依赖，后续可优化。

### 4. 搜索实现：本地内存筛选
**决策**: 搜索在 RecipeProvider 中通过内存筛选实现，基于已加载的全部菜谱列表进行名称匹配。

**理由**: 菜谱数据量小（本地 Hive 存储），全量加载后内存筛选响应快（< 500ms），无需额外请求后端。搜索关键词大小写不敏感，每次输入变化立即触发筛选。

### 5. 页面导航与数据刷新：Navigator.push + 结果回调
**决策**: 从网格页跳转到详情页/编辑页时，使用 Navigator.push 并 await 返回结果。如果结果为 true，调用 RecipeProvider.loadRecipes() 刷新列表。

**理由**: 这是 Flutter 中页面间传递刷新信号的标准模式。详情页和编辑页在数据变更后 pop(true)，网格页接收后重新加载数据。

### 6. 数据模型：Hive + HiveType 注解
**决策**: Recipe 模型使用 @HiveType 和 @HiveField 注解，通过 hive_generator 自动生成 Adapter。

**理由**: 与项目已有的 Dish 模型保持一致，Hive 提供高效的本地持久化。typeId 使用 101 避免与 Dish 模型冲突。

## Risks / Trade-offs

- **[风险] 图片加载失败无占位处理**: 当前 Image.network 和 Image.file 未设置 errorBuilder，网络图片加载失败时可能显示异常。→ **缓解**: 后续可添加 errorBuilder 显示默认图标。
- **[风险] 全量加载性能**: 当前一次性加载全部菜谱到内存，菜谱数量极大时可能影响性能。→ **缓解**: 当前菜谱数量有限，暂不优化。后续可考虑分页加载。
- **[权衡] 搜索未防抖**: 每次输入变化立即触发筛选，未做 debounce 处理。→ **缓解**: 数据量小，本地筛选足够快，暂不需要防抖。