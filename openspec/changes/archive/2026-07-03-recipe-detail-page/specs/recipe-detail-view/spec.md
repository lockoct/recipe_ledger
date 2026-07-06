## ADDED Requirements

### Requirement: 页面加载菜谱数据

系统 SHALL 接收 `recipeId` 参数，在页面初始化时加载对应的菜谱数据。

#### Scenario: 正常加载菜谱

- **WHEN** 用户从菜谱网格页点击菜谱卡片进入详情页
- **THEN** 页面显示该菜谱的完整信息

#### Scenario: 菜谱不存在

- **WHEN** `recipeId` 对应的菜谱在 Hive 中不存在
- **THEN** 页面显示"菜谱不存在"提示

### Requirement: 封面图片展示

系统 SHALL 在页面顶部展示封面图片，覆盖状态栏区域。

#### Scenario: 网络图片封面

- **WHEN** 菜谱封面为网络图片 URL
- **THEN** 顶部展示该网络图片

#### Scenario: 本地文件封面

- **WHEN** 菜谱封面为本地文件路径
- **THEN** 顶部展示该本地图片

#### Scenario: 无封面

- **WHEN** 菜谱无封面图片
- **THEN** 顶部显示默认菜单书图标（Icons.menu_book）

### Requirement: 菜谱基本信息展示

系统 SHALL 展示菜谱名称和更新时间。

#### Scenario: 菜谱名称展示

- **WHEN** 菜谱有名称
- **THEN** 名称正确显示，最多不超过2行

#### Scenario: 更新时间展示

- **WHEN** 菜谱有更新时间
- **THEN** 显示"更新于" + 日期格式（如"更新于 2025-01-15"）

### Requirement: 原材料列表展示

系统 SHALL 展示菜谱的原材料列表，包含名称、用量和成本。

#### Scenario: 菜品类型原材料

- **WHEN** 原材料为菜品类型，关联菜品库中的菜品
- **THEN** 显示菜品名称、用量、单位和成本

#### Scenario: 自定义类型原材料

- **WHEN** 原材料为自定义类型
- **THEN** 显示自定义名称、用量和单位，不显示成本

#### Scenario: 成本计算

- **WHEN** 原材料为菜品类型且菜品存在
- **THEN** 成本 = 菜品单价 × (用量 / 菜品单位换算系数)，统一转换为"斤"计算

#### Scenario: 合计成本

- **WHEN** 存在多个菜品类型原材料
- **THEN** 显示所有原材料成本合计，以红色字体展示

#### Scenario: 无原材料

- **WHEN** 菜谱无原材料
- **THEN** 显示"暂无原材料"提示

### Requirement: 做法步骤展示

系统 SHALL 以只读富文本形式展示做法步骤。

#### Scenario: 有做法步骤

- **WHEN** 菜谱有做法步骤内容
- **THEN** 以只读 QuillEditor 展示做法步骤，无工具栏

### Requirement: 注意事项展示

系统 SHALL 以只读富文本形式展示注意事项，无内容时隐藏该区域。

#### Scenario: 有注意事项

- **WHEN** 菜谱有注意事项内容
- **THEN** 以只读 QuillEditor 展示注意事项，无工具栏

#### Scenario: 无注意事项

- **WHEN** 菜谱无注意事项内容
- **THEN** 不显示注意事项区域

### Requirement: 状态栏样式

系统 SHALL 设置状态栏为透明，图标为深色。

#### Scenario: 进入详情页

- **WHEN** 用户进入菜谱详情页
- **THEN** 状态栏背景透明，状态栏图标为深色