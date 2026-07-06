## ADDED Requirements

### Requirement: 搜索栏样式
系统 SHALL 在页面顶部展示搜索栏，背景使用应用主题色（primaryColor），搜索框为白色圆角设计。

#### Scenario: 搜索栏渲染
- **WHEN** 菜谱网格页加载
- **THEN** 搜索栏区域背景为主题色，内部白色搜索框高度 40px、圆角 20px，左侧有搜索图标

### Requirement: 按菜谱名称实时搜索
系统 SHALL 支持用户在搜索框中输入关键词，实时筛选匹配的菜谱。

#### Scenario: 输入关键词筛选
- **WHEN** 用户在搜索框中输入关键词
- **THEN** 网格列表实时更新，仅展示名称包含关键词（大小写不敏感）的菜谱

#### Scenario: 无匹配结果
- **WHEN** 搜索关键词无匹配菜谱
- **THEN** 显示空状态（暂无菜谱数据）

### Requirement: 搜索清除按钮
系统 SHALL 在搜索框有内容时，在搜索框右侧显示清除按钮。

#### Scenario: 显示清除按钮
- **WHEN** 搜索框中有文本内容
- **THEN** 搜索框右侧显示清除图标（Icons.clear）

#### Scenario: 点击清除按钮
- **WHEN** 用户点击清除按钮
- **THEN** 搜索框清空，列表恢复显示所有菜谱