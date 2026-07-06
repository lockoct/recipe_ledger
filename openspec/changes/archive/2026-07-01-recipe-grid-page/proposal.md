## Why

菜谱管理是 RecipeLedger 应用的核心功能之一，用户需要一个直观的菜谱浏览入口来查看、搜索和管理所有菜谱。作为底部导航栏的三个标签页之一（菜品、菜谱、我的），菜谱网格页需要提供高效的浏览体验和快速的菜谱创建入口。

## What Changes

- 新增菜谱网格页（RecipeGridPage），以两列网格形式展示菜谱列表
- 新增顶部搜索栏，支持按菜谱名称实时搜索
- 新增菜谱卡片组件，支持封面图（网络图片/本地文件）和默认图标展示
- 点击卡片跳转到菜谱详情页，返回后自动刷新列表
- 右下角浮动添加按钮，跳转到菜谱编辑页，返回后自动刷新列表
- 支持加载中、加载失败（含重试）、空状态三种状态展示
- 菜谱按更新时间降序排序
- 新增 RecipeProvider 状态管理，管理菜谱列表的加载、搜索和筛选
- 新增 Recipe 数据模型（Hive 持久化），包含基本信息、配料、做法、注意事项等字段

## Capabilities

### New Capabilities

- `recipe-grid-browse`: 菜谱网格浏览，以两列网格形式展示菜谱，支持封面图展示、默认图标回退、按更新时间排序
- `recipe-search`: 菜谱搜索，顶部搜索栏支持按菜谱名称实时筛选，含清除按钮
- `recipe-grid-state`: 菜谱网格状态管理，通过 RecipeProvider 管理加载、空状态、错误状态
- `recipe-navigation`: 菜谱页面导航，从网格页跳转到详情页/编辑页，返回后自动刷新列表

## Impact

- 新增文件: `lib/pages/recipe/recipe_grid_page.dart`
- 新增文件: `lib/providers/recipe_provider.dart`
- 新增文件: `lib/models/recipe.dart`, `lib/models/recipe.g.dart`
- 新增文件: `lib/models/recipe_ingredient.dart`, `lib/models/recipe_ingredient.g.dart`
- 新增文件: `lib/services/recipe_service.dart`
- 依赖: Provider（状态管理）、Hive（本地持久化）
- 导航: 与 RecipeDetailPage、RecipeEditPage 之间通过 Navigator.push 传递结果