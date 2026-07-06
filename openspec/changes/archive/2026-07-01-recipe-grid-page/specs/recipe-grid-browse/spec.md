## ADDED Requirements

### Requirement: 菜谱两列网格展示
系统 SHALL 以两列固定列数的网格布局（GridView）展示菜谱列表，每行两个菜谱卡片。

#### Scenario: 有菜谱数据时展示网格
- **WHEN** 菜谱数据加载完成且列表非空
- **THEN** 页面以两列网格形式展示菜谱卡片，卡片间水平和垂直间距为 12px

### Requirement: 菜谱卡片展示封面图
系统 SHALL 在每个菜谱卡片顶部展示封面图片区域，高度固定为 120px。

#### Scenario: 菜谱有网络封面图
- **WHEN** 菜谱的 coverImage 字段以 "http" 开头
- **THEN** 卡片使用 `Image.network` 加载并展示封面图，fit 为 BoxFit.cover

#### Scenario: 菜谱有本地封面图
- **WHEN** 菜谱的 coverImage 字段为本地文件路径
- **THEN** 卡片使用 `Image.file` 加载并展示封面图，fit 为 BoxFit.cover

#### Scenario: 菜谱无封面图
- **WHEN** 菜谱的 coverImage 字段为 null 或空字符串
- **THEN** 卡片封面区域显示默认菜单书图标（Icons.menu_book），蓝色

### Requirement: 菜谱卡片展示名称
系统 SHALL 在每个菜谱卡片封面图下方展示菜谱名称。

#### Scenario: 菜谱名称展示
- **WHEN** 菜谱卡片渲染
- **THEN** 卡片底部显示菜谱名称，单行展示，超出部分省略号截断

### Requirement: 菜谱卡片圆角样式
系统 SHALL 使用圆角卡片样式，卡片圆角半径为 12px，白色背景，无阴影。

#### Scenario: 卡片样式
- **WHEN** 菜谱卡片渲染
- **THEN** 卡片为白色背景，圆角 12px，elevation 为 0

### Requirement: 菜谱按更新时间排序
系统 SHALL 按更新时间降序排列菜谱列表，最新更新的菜谱排在最前。

#### Scenario: 列表排序
- **WHEN** 菜谱列表加载完成
- **THEN** 菜谱按 updateTime 字段降序排列