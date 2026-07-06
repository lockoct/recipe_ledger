## ADDED Requirements

### Requirement: 点击卡片跳转详情页
系统 SHALL 支持点击菜谱卡片跳转到菜谱详情页（RecipeDetailPage）。

#### Scenario: 点击菜谱卡片
- **WHEN** 用户点击菜谱卡片
- **THEN** 通过 Navigator.push 导航到 RecipeDetailPage，传入菜谱 ID

#### Scenario: 详情页返回后刷新
- **WHEN** 用户从菜谱详情页返回且返回结果为 true
- **THEN** 调用 RecipeProvider.loadRecipes() 重新加载菜谱列表

### Requirement: 浮动添加按钮
系统 SHALL 在页面右下角显示浮动添加按钮（FloatingActionButton），点击跳转到菜谱编辑页。

#### Scenario: 浮动按钮样式
- **WHEN** 菜谱网格页渲染
- **THEN** 右下角显示圆形浮动按钮，背景为主题色，图标为 Icons.add

#### Scenario: 点击添加按钮
- **WHEN** 用户点击浮动添加按钮
- **THEN** 通过 Navigator.push 导航到 RecipeEditPage

#### Scenario: 编辑页返回后刷新
- **WHEN** 用户从菜谱编辑页返回且返回结果为 true
- **THEN** 调用 RecipeProvider.loadRecipes() 重新加载菜谱列表

### Requirement: 状态栏样式
系统 SHALL 配置页面状态栏颜色与搜索栏主题色一致。

#### Scenario: 状态栏颜色
- **WHEN** 菜谱网格页显示
- **THEN** 状态栏背景色为应用主题色（primaryColor），图标为浅色（Brightness.light）