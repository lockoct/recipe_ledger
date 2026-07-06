## 1. 数据模型层

- [x] 1.1 创建 Recipe 模型（recipe.dart），包含 id、name、coverImage、ingredients、instructions、createTime、updateTime、notes 字段，配置 HiveType 注解（typeId: 101）
- [x] 1.2 实现 Recipe.fromJson 工厂构造函数和 toJson 方法
- [x] 1.3 实现 Recipe.copyWith 方法
- [x] 1.4 运行 build_runner 生成 recipe.g.dart（Hive Adapter）
- [x] 1.5 创建 RecipeService（recipe_service.dart），封装 Hive 的 getAllRecipes 操作

## 2. 状态管理

- [x] 2.1 创建 RecipeProvider（recipe_provider.dart），继承 ChangeNotifier
- [x] 2.2 实现 loadRecipes 方法，加载全部菜谱并按更新时间降序排序
- [x] 2.3 实现 setSearchQuery 方法，按名称大小写不敏感筛选，更新 filteredRecipes
- [x] 2.4 实现 _applySearchFilter 内部方法，统一处理搜索筛选和排序逻辑
- [x] 2.5 实现 addRecipe、updateRecipe、deleteRecipe 方法，操作后自动重新加载列表
- [x] 2.6 处理加载状态（isLoading）和错误状态（errorMessage），在 try-catch 中正确设置状态并通知监听者
- [x] 2.7 在 main.dart 中通过 MultiProvider 注册 RecipeProvider

## 3. 页面框架

- [x] 3.1 创建 RecipeGridPage（recipe_grid_page.dart），使用 StatefulWidget
- [x] 3.2 配置 AnnotatedRegion，设置状态栏颜色为主题色（statusBarColor: primaryColor）
- [x] 3.3 配置 AppBar（toolbarHeight: 0），仅用于设置 systemOverlayStyle
- [x] 3.4 配置 Scaffold 背景色为 #F6F6F6

## 4. 搜索栏

- [x] 4.1 实现 _buildSearchBar 方法，Container 背景为主题色，padding 上下 12px 左右 16px
- [x] 4.2 使用 Stack 布局：底层白色圆角容器（height: 40, borderRadius: 20），上层 Row 放置搜索图标、输入框和清除按钮
- [x] 4.3 搜索框使用 TextField，hintText 为 "搜索菜谱名称..."，onChanged 调用 _onSearchChanged
- [x] 4.4 搜索框右侧条件显示清除按钮（Icons.clear），点击清空搜索框并恢复列表

## 5. 菜谱网格与卡片

- [x] 5.1 实现 _buildRecipeGrid 方法，使用 Consumer 监听 RecipeProvider
- [x] 5.2 使用 GridView.builder + SliverGridDelegateWithFixedCrossAxisCount 实现两列网格（crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.05）
- [x] 5.3 实现 _buildRecipeCard 方法，使用 GestureDetector 包裹 Card 组件
- [x] 5.4 卡片封面区域：Container 高度 120px，clipBehavior 为 Clip.antiAlias
- [x] 5.5 封面图逻辑：coverImage 以 "http" 开头使用 Image.network，否则使用 Image.file，空值显示 Icons.menu_book 默认图标
- [x] 5.6 卡片名称区域：Padding 包裹 Text，单行显示（maxLines: 1），超出省略号

## 6. 页面状态处理

- [x] 6.1 加载中状态：isLoading 为 true 且 filteredRecipes 为空时，显示 CircularProgressIndicator + "加载中..."
- [x] 6.2 错误状态：errorMessage 非空且 filteredRecipes 为空时，显示错误图标 + 错误信息 + "重试" ElevatedButton
- [x] 6.3 空状态：filteredRecipes 为空且非加载/错误状态时，显示 Icons.menu_book + "暂无菜谱数据"

## 7. 导航与数据刷新

- [x] 7.1 实现 _viewRecipeDetail 方法，Navigator.push 到 RecipeDetailPage，传入 recipe.id
- [x] 7.2 详情页返回后检查 result == true，调用 RecipeProvider.loadRecipes() 刷新列表
- [x] 7.3 实现 FloatingActionButton，圆形、主题色背景、Icons.add 图标
- [x] 7.4 实现 _addNewRecipe 方法，Navigator.push 到 RecipeEditPage
- [x] 7.5 编辑页返回后检查 result == true，调用 RecipeProvider.loadRecipes() 刷新列表
- [x] 7.6 所有 Navigator 回调中检查 mounted 状态，防止 Widget 已销毁后调用 setState