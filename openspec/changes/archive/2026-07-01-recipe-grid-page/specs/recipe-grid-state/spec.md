## ADDED Requirements

### Requirement: 加载中状态
系统 SHALL 在菜谱数据加载过程中显示加载状态，包含加载动画和文字提示。

#### Scenario: 首次加载
- **WHEN** 页面首次加载菜谱数据且列表为空
- **THEN** 页面中央显示 CircularProgressIndicator 和 "加载中..." 文字

### Requirement: 加载失败状态
系统 SHALL 在菜谱数据加载失败时显示错误状态，包含错误信息和重试按钮。

#### Scenario: 加载失败
- **WHEN** 菜谱数据加载失败且列表为空
- **THEN** 页面中央显示错误图标、错误信息文字和 "重试" 按钮

#### Scenario: 点击重试
- **WHEN** 用户点击 "重试" 按钮
- **THEN** 重新发起菜谱数据加载请求

### Requirement: 空状态
系统 SHALL 在无菜谱数据时显示空状态提示。

#### Scenario: 列表为空
- **WHEN** 菜谱列表为空（无数据或搜索结果为空）
- **THEN** 页面中央显示菜单书图标（Icons.menu_book）和 "暂无菜谱数据" 文字

### Requirement: RecipeProvider 状态管理
系统 SHALL 通过 RecipeProvider（ChangeNotifier）管理菜谱列表的加载、搜索和筛选状态。

#### Scenario: 初始化加载
- **WHEN** RecipeProvider 实例化
- **THEN** 自动调用 loadRecipes() 加载菜谱数据

#### Scenario: 搜索筛选
- **WHEN** 调用 setSearchQuery() 设置搜索关键词
- **THEN** filteredRecipes 更新为名称匹配的菜谱列表，按更新时间降序排列

#### Scenario: 状态通知
- **WHEN** 菜谱数据或搜索状态发生变化
- **THEN** 通过 notifyListeners() 通知所有 Consumer 重建 UI

### Requirement: 菜谱本地持久化
系统 SHALL 使用 Hive 将菜谱数据持久化到本地存储。

#### Scenario: Recipe 模型序列化
- **WHEN** Recipe 对象存储到 Hive
- **THEN** 使用 HiveType 注解和自动生成的 Adapter 进行序列化/反序列化