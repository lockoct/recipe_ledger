## ADDED Requirements

### Requirement: 返回按钮

系统 SHALL 提供返回按钮，点击后返回上一页。

#### Scenario: 点击返回

- **WHEN** 用户点击返回浮动按钮
- **THEN** 返回上一页（菜谱网格页）

### Requirement: 编辑跳转

系统 SHALL 提供编辑按钮，点击后跳转到菜谱编辑页。

#### Scenario: 点击编辑

- **WHEN** 用户点击编辑浮动按钮
- **THEN** 跳转到菜谱编辑页，传递当前菜谱的 `recipeId`

### Requirement: 编辑返回自动刷新

系统 SHALL 在编辑页返回后自动刷新详情数据。

#### Scenario: 编辑保存后返回

- **WHEN** 用户在编辑页修改并保存菜谱后返回详情页
- **THEN** 详情页自动重新加载菜谱数据，展示最新内容

### Requirement: 删除确认对话框

系统 SHALL 在删除前弹出确认对话框。

#### Scenario: 点击删除按钮

- **WHEN** 用户点击删除浮动按钮
- **THEN** 弹出确认删除对话框，包含"确认删除"和"取消"选项

### Requirement: 删除执行

系统 SHALL 在用户确认后执行删除操作。

#### Scenario: 确认删除成功

- **WHEN** 用户确认删除且删除操作成功
- **THEN** 菜谱从 Hive 中删除，返回上一页，显示"菜谱已删除"提示

#### Scenario: 删除失败

- **WHEN** 用户确认删除但删除操作失败
- **THEN** 停留在当前页面，显示删除失败错误提示